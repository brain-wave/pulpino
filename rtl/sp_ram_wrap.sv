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

module sp_ram_wrap
  #(
    parameter RAM_SIZE   = 32768,              // in bytes
    parameter ADDR_WIDTH = $clog2(RAM_SIZE),
    parameter DATA_WIDTH = 32
  )(
    // Clock and Reset
    input  logic                    clk,
    input  logic                    rstn_i,
    input  logic                    en_i,
    input  logic [ADDR_WIDTH-1:0]   addr_i,
    input  logic [DATA_WIDTH-1:0]   wdata_i,
    output logic [DATA_WIDTH-1:0]   rdata_o,
    input  logic                    we_i,
    input  logic [DATA_WIDTH/8-1:0] be_i,
    input  logic                    bypass_en_i
  );

`ifdef PULP_FPGA_EMUL
  xilinx_mem_8192x32
  sp_ram_i
  (
    .clka   ( clk                    ),
    .rsta   ( 1'b0                   ), // reset is active high

    .ena    ( en_i                   ),
    .addra  ( addr_i[ADDR_WIDTH-1:2] ),
    .dina   ( wdata_i                ),
    .douta  ( rdata_o                ),
    .wea    ( be_i & {4{we_i}}       )
  );
`elsif TSMC40
    parameter TSMC_ADDR_WIDTH = 13; // 8K words (word-addressing)
    
    wire wPD = 1'b0; // Power down (0 for Power up)
    wire wCLK = clk;
    wire [DATA_WIDTH-1:0] wQ;
    
    wire wWEB = !we_i; // Read/Write (1 for read)
    wire wCEB = !en_i; // Chip Enable (0 for enable)
    wire [DATA_WIDTH-1:0] wBWEB;
    wire [TSMC_ADDR_WIDTH-1:0] wA = addr_i[ADDR_WIDTH-1:2]; // Convert to word-addressing
    wire [DATA_WIDTH-1:0] wD = wdata_i; 
    
    // broadcast byte enable bits to bits
    genvar i;
    generate for(i = 0; i < DATA_WIDTH/8; i++)
        begin
            assign wBWEB[(i+1)*8-1:i*8] = {8{!be_i[i]}}; // Bit enable (0 for enable)
        end
    endgenerate
    
    //"/home/mwijtvliet/git/memories/ts1n40lpb8192x32m16m_210a/VERILOG/ts1n40lpb8192x32m16m_210a_ss0p99v125c.v"    
    TS1N40LPB8192X32M16M sp_ram_i
    (
        .A(wA),
        .D(wD),
        .BWEB(wBWEB),
        .WEB(wWEB),
        .CEB(wCEB), // chip enable connected correctly?
        .CLK(wCLK),
        .PD(wPD),
        .AWT(1'b0), // asynchronous write through (0 for disable)
        .AM(wA),
        .DM(wD),
        .BWEBM(wBWEB),
        .WEBM(wWEB),
        .CEBM(wCEB),
        .RTSEL(2'b01), // recommended Read cycle timing setting
        .WTSEL(2'b01), // recommended Write cycle timing setting
        .BIST(1'b0),   // Normal mode
        .Q(wQ)
    );
    
    assign rdata_o = wQ;
`elsif FDSOI28
  // Needs to be replaced by STM memory
  sp_ram
  #(
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .DATA_WIDTH ( DATA_WIDTH ),
    .NUM_WORDS  ( RAM_SIZE   )
  )
  sp_ram_i
  (
    .clk     ( clk       ),

    .en_i    ( en_i      ),
    .addr_i  ( addr_i    ),
    .wdata_i ( wdata_i   ),
    .rdata_o ( rdata_o   ),
    .we_i    ( we_i      ),
    .be_i    ( be_i      )
  );
`else
  sp_ram
  #(
    .ADDR_WIDTH ( ADDR_WIDTH ),
    .DATA_WIDTH ( DATA_WIDTH ),
    .NUM_WORDS  ( RAM_SIZE   )
  )
  sp_ram_i
  (
    .clk     ( clk       ),

    .en_i    ( en_i      ),
    .addr_i  ( addr_i    ),
    .wdata_i ( wdata_i   ),
    .rdata_o ( rdata_o   ),
    .we_i    ( we_i      ),
    .be_i    ( be_i      )
  );
`endif

endmodule
