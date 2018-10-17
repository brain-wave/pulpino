#add_files -norecurse -scan_for_includes $SRC_AXI_NODE
#add_files -norecurse -scan_for_includes $SRC_APB_NODE
#add_files -norecurse -scan_for_includes $SRC_AXI_MEM_IF_DP
#add_files -norecurse -scan_for_includes $SRC_AXI_SPI_SLAVE
#add_files -norecurse -scan_for_includes $SRC_AXI_SPI_MASTER
#add_files -norecurse -scan_for_includes $SRC_APB_UART_SV
#add_files -norecurse -scan_for_includes $SRC_APB_GPIO
#add_files -norecurse -scan_for_includes $SRC_APB_EVENT_UNIT
#add_files -norecurse -scan_for_includes $SRC_APB_SPI_MASTER
#add_files -norecurse -scan_for_includes $SRC_FPU
#add_files -norecurse -scan_for_includes $SRC_APB_PULPINO
#add_files -norecurse -scan_for_includes $SRC_APB_FLL_IF
#add_files -norecurse -scan_for_includes $SRC_CORE2AXI
#add_files -norecurse -scan_for_includes $SRC_APB_TIMER
#add_files -norecurse -scan_for_includes $SRC_AXI2APB
#add_files -norecurse -scan_for_includes $SRC_APB_I2C
#add_files -norecurse -scan_for_includes $SRC_ZERORISCY_REGFILE_FPGA
#add_files -norecurse -scan_for_includes $SRC_ZERORISCY
#add_files -norecurse -scan_for_includes $SRC_AXI_SLICE_DC
#add_files -norecurse -scan_for_includes $SRC_RISCV
#add_files -norecurse -scan_for_includes $SRC_RISCV_REGFILE_FPGA
#add_files -norecurse -scan_for_includes $SRC_APB_UART
#add_files -norecurse -scan_for_includes $SRC_AXI_SLICE
#add_files -norecurse -scan_for_includes $SRC_ADV_DBG_IF
#add_files -norecurse -scan_for_includes $SRC_APB2PER

foreach sv_file $SRC_AXI_NODE { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_APB_NODE { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_AXI_MEM_IF_DP { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_AXI_SPI_SLAVE { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_AXI_SPI_MASTER { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_APB_GPIO { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_APB_EVENT_UNIT { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_APB_SPI_MASTER { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
###foreach sv_file $SRC_FPU { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_APB_PULPINO { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_APB_FLL_IF { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_CORE2AXI { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_APB_TIMER { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_AXI2APB { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_APB_I2C { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_ZERORISCY_REGFILE_FPGA { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_ZERORISCY { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_AXI_SLICE_DC { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_RISCV { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_RISCV_REGFILE_FPGA { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach vhdl_file $SRC_APB_UART { set_global_assignment -name VHDL_FILE $vhdl_file }
foreach sv_file $SRC_AXI_SLICE { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_ADV_DBG_IF { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_APB2PER { set_global_assignment -name SYSTEMVERILOG_FILE $sv_file }
foreach sv_file $SRC_IPS { set_global_assignment -name VERILOG_FILE $sv_file }
