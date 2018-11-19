// Copyright 2017 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

`include "config.sv"
`include "tb_jtag_pkg.sv"

`define REF_CLK_PERIOD   (2*15.25us)  // 32.786 kHz --> FLL reset value --> 50 MHz
`define CLK_PERIOD 100000ps // 40.00ns  25 MHz

`define EXIT_SUCCESS  0
`define EXIT_FAIL     1
`define EXIT_ERROR   -1

//`define USE_S25FS256S_MODEL // download model before enabling this option

module tb;
  timeunit      1ns;
  timeprecision 1ps;

  // +MEMLOAD= valid values are "SPI", "STANDALONE" "PRELOAD", "" (no load of L2)
  parameter  SPI            = "QUAD";    // valid values are "SINGLE", "QUAD"
  parameter  BAUDRATE       = 781250;    // 1562500
  parameter  CLK_USE_FLL    = 0;         // 0 or 1
  parameter  TEST           = "";        // valid values are "" (NONE), "DEBUG"
  parameter  USE_ZERO_RISCY = 0;
  parameter  RISCY_RV32F    = 0;
  parameter  ZERO_RV32M     = 1;
  parameter  ZERO_RV32E     = 0;
  //parameter  USE_S25FS256S_MODEL = 0;   // download model before enabling this option

  int           exit_status = `EXIT_ERROR; // modelsim exit code, will be overwritten when successful

  string        memload;
  logic         s_clk = 1'b0;
  logic         s_rst_n = 1'b0;

  logic         fetch_enable = 1'b0;

  logic [1:0]   padmode_spi_master;
  logic         spi_sck = 1'b0;
  logic         spi_csn = 1'b1;
  logic [1:0]   spi_mode;
  logic         spi_sdo0;
  logic         spi_sdo1;
  logic         spi_sdo2;
  logic         spi_sdo3;
  logic         spi_sdi0;
  logic         spi_sdi1;
  logic         spi_sdi2;
  logic         spi_sdi3;

  logic         uart_tx;
  logic         uart_rx;
  logic         s_uart_dtr;
  logic         s_uart_rts;

  logic         scl_pad_i;
  logic         scl_pad_o;
  logic         scl_padoen_o;

  logic         sda_pad_i;
  logic         sda_pad_o;
  logic         sda_padoen_o;

  tri1          scl_io;
  tri1          sda_io;

  logic [31:0]  gpio_in = '0;
  logic [31:0]  gpio_dir;
  logic [31:0]  gpio_out;

  logic [31:0]  recv_data;

  jtag_i jtag_if();

  adv_dbg_if_t adv_dbg_if = new(jtag_if);

  // use 8N1
  uart_bus
  #(
    .BAUD_RATE(BAUDRATE),
    .PARITY_EN(0),
    .CLK_PERIOD(`CLK_PERIOD)
  )
  uart
  (
    .rx         ( uart_rx ),
    .tx         ( uart_tx ),
    .rx_en      ( 1'b1    )
  );

  spi_slave
  spi_master();


    /* SPI flash model (not open-source, from Spansion) */
   tri sdi_o;
   tri sdo_i;
   assign wp_neg = 1'b1;
   assign rst_n = s_rst_n;
/*
   `ifdef USE_S25FS256S_MODEL
   generate
         s25fs256s #(
            .TimingModel   ( "S25FS256SAGMFI000_F_30pF" ),
            .mem_file_name ( "flash_stim.slm" ),
            .UserPreload   (1)
         ) i_spi_flash_csn0 (
            .SI       ( sdo_i ),
            .SO       ( sdi_o ),
            .SCK      ( spi_master.clk   ),
            .CSNeg    ( spi_master.csn  ),
            .WPNeg    ( wp_neg ), // Write Protect disabled
            .RESETNeg ( rst_n )
         );
      end
   endgenerate
`endif
*/
  
  
  i2c_buf i2c_buf_i
  (
    .scl_io       ( scl_io       ),
    .sda_io       ( sda_io       ),
    .scl_pad_i    ( scl_pad_i    ),
    .scl_pad_o    ( scl_pad_o    ),
    .scl_padoen_o ( scl_padoen_o ),
    .sda_pad_i    ( sda_pad_i    ),
    .sda_pad_o    ( sda_pad_o    ),
    .sda_padoen_o ( sda_padoen_o )
  );

  i2c_eeprom_model
  #(
    .ADDRESS ( 7'b1010_000 )
  )
  i2c_eeprom_model_i
  (
    .scl_io ( scl_io  ),
    .sda_io ( sda_io  ),
    .rst_ni ( s_rst_n )
  );

  pulpino_top
`ifndef SYNTHESIS
  #(
    .USE_ZERO_RISCY    ( USE_ZERO_RISCY ),
    .RISCY_RV32F       ( RISCY_RV32F    ),
    .ZERO_RV32M        ( ZERO_RV32M     ),
    .ZERO_RV32E        ( ZERO_RV32E     )
   )
`endif
  top_i
  (
    .clk               ( s_clk        ),
    .rst_n             ( s_rst_n      ),

    .clk_sel_i         ( 1'b0         ),
    .testmode_i        ( 1'b0         ),
    .fetch_enable_i    ( fetch_enable ),

    .spi_clk_i         ( spi_sck      ),
    .spi_cs_i          ( spi_csn      ),
    .spi_mode_o        ( spi_mode     ),
    .spi_sdo0_o        ( spi_sdi0     ),
    .spi_sdo1_o        ( spi_sdi1     ),
    .spi_sdo2_o        ( spi_sdi2     ),
    .spi_sdo3_o        ( spi_sdi3     ),
    .spi_sdi0_i        ( spi_sdo0     ),
    .spi_sdi1_i        ( spi_sdo1     ),
    .spi_sdi2_i        ( spi_sdo2     ),
    .spi_sdi3_i        ( spi_sdo3     ),

    .spi_master_clk_o  ( spi_master.clk     ),
    .spi_master_csn0_o ( spi_master.csn     ),
    .spi_master_csn1_o (                    ),
    .spi_master_csn2_o (                    ),
    .spi_master_csn3_o (                    ),
    .spi_master_mode_o ( spi_master.padmode ),
    .spi_master_sdo0_o ( sdo_i ),//spi_master.sdo[0]  ),
    .spi_master_sdo1_o ( ),//spi_master.sdo[1]  ),
    .spi_master_sdo2_o ( ),//spi_master.sdo[2]  ),
    .spi_master_sdo3_o ( ),//spi_master.sdo[3]  ),
    .spi_master_sdi0_i ( sdi_o ),//spi_master.sdi[0]  ),
    .spi_master_sdi1_i ( ),//spi_master.sdi[1]  ),
    .spi_master_sdi2_i ( ),//spi_master.sdi[2]  ),
    .spi_master_sdi3_i ( ),//spi_master.sdi[3]  ),

    .scl_pad_i         ( scl_pad_i    ),
    .scl_pad_o         ( scl_pad_o    ),
    .scl_padoen_o      ( scl_padoen_o ),
    .sda_pad_i         ( sda_pad_i    ),
    .sda_pad_o         ( sda_pad_o    ),
    .sda_padoen_o      ( sda_padoen_o ),


    .uart_tx           ( uart_rx      ),
    .uart_rx           ( uart_tx      ),
    .uart_rts          ( s_uart_rts   ),
    .uart_dtr          ( s_uart_dtr   ),
    .uart_cts          ( 1'b0         ),
    .uart_dsr          ( 1'b0         ),

    .gpio_in           ( gpio_in      ),
    .gpio_out          ( gpio_out     ),
    .gpio_dir          ( gpio_dir     ),
    //.gpio_padcfg       (              ), // throws error in synthesis: signal [31:0][5:0]gpio_padcfg; => not verilog

    .tck_i             ( jtag_if.tck     ),
    .trstn_i           ( jtag_if.trstn   ),
    .tms_i             ( jtag_if.tms     ),
    .tdi_i             ( jtag_if.tdi     ),
    .tdo_o             ( jtag_if.tdo     )
  );

  generate
    if (CLK_USE_FLL) begin
      initial
      begin
        #(`REF_CLK_PERIOD/2);
        s_clk = 1'b1;
        forever s_clk = #(`REF_CLK_PERIOD/2) ~s_clk;
      end
    end else begin
      initial
      begin
        #(`CLK_PERIOD/2);
        s_clk = 1'b1;
        forever s_clk = #(`CLK_PERIOD/2) ~s_clk;
      end
    end
  endgenerate

  logic use_qspi;

  initial
  begin
    int i;
    integer fp;
    integer addr;
    logic [31:0] data;

`ifdef SYNTHESIS
    $sdf_annotate("../../syn/outputs/pulpino_top.sdf",top_i,"sdf.cfg",,"MAXIMUM"); 
`endif
    
    if(!$value$plusargs("MEMLOAD=%s", memload))
      memload = "PRELOAD"; // PRELOAD or JTAG

    $display("Using %s core", USE_ZERO_RISCY ? "zero-riscy" : "ri5cy");
    
    use_qspi = SPI == "QUAD" ? 1'b1 : 1'b0;

    s_rst_n      = 1'b0;
    fetch_enable = 1'b0;
    
    #(500ns);//*`CLK_PERIOD/40ns);
    #(300us); // wait for Flash to wake up (300us)
    s_rst_n = 1'b1; // TODO: posedge to negative clockedge
    
    #(500ns*`CLK_PERIOD/40ns);
    if (use_qspi)
      spi_enable_qpi();

    $display("Using MEMLOAD method: %s", memload);
    if (memload != "STANDALONE")
    begin
      /* Configure JTAG and set boot address */
      $display("1");
      adv_dbg_if.jtag_reset();
      $display("2");
      adv_dbg_if.jtag_softreset();
      $display("3");
      adv_dbg_if.init();
      $display("4");
      adv_dbg_if.axi4_write32(32'h1A10_7008, 1, 32'h0000_0000);
      $display("5");
    end
    //$display("Using MEMLOAD method: %s", memload);

    if (memload == "PRELOAD")
    begin
      // preload memories
      mem_preload();
    end
    else if (memload == "JTAG")
    begin
    
        // preload memories
        logic [31:0]     data_mem[];  // this variable holds the whole memory content
        logic [31:0]     instr_mem[]; // this variable holds the whole memory content
        event            event_mem_load;

        //task mem_preload;
        integer      addr;
        integer      mem_addr;
        integer      bidx;
        integer      instr_size;
        integer      instr_width;
        integer      data_size;
        integer      data_width;
        logic [31:0] data;
        string       l2_imem_file;
        string       l2_dmem_file;
        
        $display("Preloading memory using JTAG");
`ifdef TSMC40
        instr_width = tb.top_i.core_region_i.instr_mem.sp_ram_wrap_i.sp_ram_i.numBit;
        instr_size   = tb.top_i.core_region_i.instr_mem.sp_ram_wrap_i.sp_ram_i.numWord * instr_width/8;
      
        data_width = tb.top_i.core_region_i.data_mem.sp_ram_i.numBit;
        data_size   = tb.top_i.core_region_i.data_mem.sp_ram_i.numWord * data_width/8;
`elsif FDSOI28
  `ifndef SYNTHESIS
        instr_width = tb.top_i.core_region_i.instr_mem.sp_ram_wrap_i.genmem.sp_ram_i.I1.bits;
        instr_size   = tb.top_i.core_region_i.instr_mem.sp_ram_wrap_i.genmem.sp_ram_i.I1.words * instr_width/8;
        
        data_width = tb.top_i.core_region_i.data_mem.genmem.sp_ram_i.I1.bits;
        data_size   = tb.top_i.core_region_i.data_mem.genmem.sp_ram_i.I1.words * data_width/8;
  `else
        instr_width = tb.top_i.core_region_i.instr_mem.sp_ram_wrap_i.\genmem.sp_ram_i .I1.bits;
        instr_size   = tb.top_i.core_region_i.instr_mem.sp_ram_wrap_i.\genmem.sp_ram_i .I1.words * instr_width/8;
        
        data_width = tb.top_i.core_region_i.data_mem.\genmem.sp_ram_i .I1.bits;
        data_size   = tb.top_i.core_region_i.data_mem.\genmem.sp_ram_i .I1.words * data_width/8;
  `endif
`else
        instr_size   = tb.top_i.core_region_i.instr_mem.sp_ram_wrap_i.RAM_SIZE;
        instr_width = tb.top_i.core_region_i.instr_mem.sp_ram_wrap_i.DATA_WIDTH;

        data_size   = tb.top_i.core_region_i.data_mem.RAM_SIZE;
        data_width = tb.top_i.core_region_i.data_mem.DATA_WIDTH;
`endif
        instr_mem = new [instr_size/4];
        data_mem  = new [data_size/4];

        if(!$value$plusargs("l2_imem=%s", l2_imem_file)) begin
            l2_imem_file = "slm_files/l2_stim.slm";
        end
        $display("Preloading instruction memory from %0s", l2_imem_file);
        $readmemh(l2_imem_file, instr_mem);

        if(!$value$plusargs("l2_dmem=%s", l2_dmem_file)) begin
            l2_dmem_file = "slm_files/tcdm_bank0.slm";
        end
        $display("Preloading data memory from %0s", l2_dmem_file);
        $readmemh(l2_dmem_file, data_mem);
        
        // preload data memory
        for(addr = 0; addr < data_size/4; addr = addr + 1) begin
            if (data_mem[addr] === 32'hxxxx_xxxx)
                data_mem[addr] = 32'h0;
        end
        addr = 32'h0010_0000;
        adv_dbg_if.axi_write_2(5'h3, addr, data_size/4, data_mem); // TODO: burst with 256 words until we are done
        
        // preload instruction memory
        for(addr = 0; addr < instr_size/4; addr = addr + 1) begin
            if (instr_mem[addr] === 32'hxxxx_xxxx)
                instr_mem[addr] = 32'h0;
        end
        addr = 32'h0000_0000;
        adv_dbg_if.axi_write_2(5'h3, addr, instr_size/4, instr_mem); // TODO: burst with 256 words until we are done
    end
    else if (memload == "SPI")
    begin
      spi_load(use_qspi);
      spi_check(use_qspi);
    end

    #(1ns*`CLK_PERIOD/40ns);
    fetch_enable = 1'b1;

    if(TEST == "DEBUG") begin
      debug_tests();
    end else if (TEST == "DEBUG_IRQ") begin
      debug_irq_tests();
    end else if (TEST == "MEM_DPI") begin
      mem_dpi(4567);
    end else if (TEST == "ARDUINO_UART") begin
      if (~gpio_out[0])
        wait(gpio_out[0]);
      uart.send_char(8'h65);
    end else if (TEST == "ARDUINO_GPIO") begin
      // Here  test for GPIO Starts
      if (~gpio_out[0])
        wait(gpio_out[0]);

      gpio_in[4]=1'b1;

      if (~gpio_out[1])
        wait(gpio_out[1]);
      if (~gpio_out[2])
        wait(gpio_out[2]);
      if (~gpio_out[3])
        wait(gpio_out[3]);

      gpio_in[7]=1'b1;

    end else if (TEST == "ARDUINO_SHIFT") begin

      if (~gpio_out[0])
        wait(gpio_out[0]);
      //start TEST

      if (~gpio_out[4])
        wait(gpio_out[4]);
      gpio_in[3]=1'b1;
      if (gpio_out[4])
        wait(~gpio_out[4]);

      if (~gpio_out[4])
        wait(gpio_out[4]);
      gpio_in[3]=1'b1;
      if (gpio_out[4])
        wait(~gpio_out[4]);

      if (~gpio_out[4])
        wait(gpio_out[4]);
      gpio_in[3]=1'b0;
      if (gpio_out[4])
        wait(~gpio_out[4]);

      if (~gpio_out[4])
        wait(gpio_out[4]);
      gpio_in[3]=1'b0;
      if (gpio_out[4])
        wait(~gpio_out[4]);

      if (~gpio_out[4])
        wait(gpio_out[4]);
      gpio_in[3]=1'b1;
      if (gpio_out[4])
        wait(~gpio_out[4]);

      if (~gpio_out[4])
        wait(gpio_out[4]);
      gpio_in[3]=1'b0;
      if (gpio_out[4])
        wait(~gpio_out[4]);

      if (~gpio_out[4])
        wait(gpio_out[4]);
      gpio_in[3]=1'b0;
      if (gpio_out[4])
        wait(~gpio_out[4]);

      if (~gpio_out[4])
        wait(gpio_out[4]);
      gpio_in[3]=1'b1;
      if (gpio_out[4])
        wait(~gpio_out[4]);

    end else if (TEST == "ARDUINO_PULSEIN") begin
      if (~gpio_out[0])
        wait(gpio_out[0]);
      #50us;
      gpio_in[4]=1'b1;
      #500us;
      gpio_in[4]=1'b0;
      #1ms;
      gpio_in[4]=1'b1;
      #500us;
      gpio_in[4]=1'b0;
    end else if (TEST == "ARDUINO_INT") begin
      if (~gpio_out[0])
        wait(gpio_out[0]);
      #50us;
      gpio_in[1]=1'b1;
      #20us;
      gpio_in[1]=1'b0;
      #20us;
      gpio_in[1]=1'b1;
      #20us;
      gpio_in[2]=1'b1;
      #20us;
    end else if (TEST == "ARDUINO_SPI") begin
      for(i = 0; i < 2; i++) begin
        spi_master.wait_csn(1'b0);
        spi_master.send(0, {>>{8'h38}});
      end
    end
    
    // end of computation
    $display("6");
    if (~gpio_out[8])
      wait(gpio_out[8]);
    $display("7");
    
    // dump DMEM content
    fp = $fopen("GM_out.txt", "w");
    for(addr = 0; addr < 32768/4; addr = addr+1) begin
        //adv_dbg_if.axi4_read32(1048576 + 4*addr, 1, data); // read word: 0x00100000 + addr (very slow)
`ifdef TSMC40
        data = tb.top_i.core_region_i.data_mem.sp_ram_i.MEMORY[addr/16][addr%16];
`elsif FDSOI28
  `ifndef SYNTHESIS
        data = tb.top_i.core_region_i.data_mem.genmem.sp_ram_i.I1.Mem[addr];
  `else
        data = tb.top_i.core_region_i.data_mem.\genmem.sp_ram_i .I1.Mem[addr];
  `endif
`else
        data = tb.top_i.core_region_i.data_mem.sp_ram_i.mem[addr]; // (much faster)
`endif
        $fwrite(fp, "%b\n", data);
    end
    $fclose(fp);
    
    spi_check_return_codes(exit_status);
    $display("8");
    $fflush();
    $stop();
  end

  
  // TODO: this is a hack, do it properly!
  `include "tb_spi_pkg.sv"
  `include "tb_mem_pkg.sv"
  `include "spi_debug_test.svh"
  `include "mem_dpi.svh"

endmodule
