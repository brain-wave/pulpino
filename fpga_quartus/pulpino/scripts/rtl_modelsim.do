transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

if ![file isdirectory vhdl_libs] {
	file mkdir vhdl_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cyclonev_ver
vmap cyclonev_ver ./verilog_libs/cyclonev_ver
vlog -vlog01compat -work cyclonev_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/mentor/cyclonev_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/mentor/cyclonev_hmi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/cyclonev_atoms.v}

vlib verilog_libs/cyclonev_hssi_ver
vmap cyclonev_hssi_ver ./verilog_libs/cyclonev_hssi_ver
vlog -vlog01compat -work cyclonev_hssi_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/mentor/cyclonev_hssi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_hssi_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/cyclonev_hssi_atoms.v}

vlib verilog_libs/cyclonev_pcie_hip_ver
vmap cyclonev_pcie_hip_ver ./verilog_libs/cyclonev_pcie_hip_ver
vlog -vlog01compat -work cyclonev_pcie_hip_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/mentor/cyclonev_pcie_hip_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_pcie_hip_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/cyclonev_pcie_hip_atoms.v}



# Paths
set PROJECT_ROOT $::env(PROJECT_ROOT)
set FPGA_ROOT $::env(FPGA_ROOT)
puts "FPGA_ROOT = ${FPGA_ROOT}"
set TB ${FPGA_ROOT}/../tb
set RTL ${FPGA_ROOT}/../rtl
set IPS ${FPGA_ROOT}/../ips
set FPGA_IPS ${FPGA_ROOT}/ips
set FPGA_RTL ${FPGA_ROOT}/rtl

# Included dirs
set INC_DIRS " \
    $RTL/includes \
    $IPS/axi/axi_node/. \
    $IPS/apb/apb_event_unit/./include/ \
    $IPS/fpu/. \
    $IPS/apb/apb_i2c/. \
    $IPS/zero-riscy/include \
    $IPS/zero-riscy/include \
    $IPS/riscv/include \
    $IPS/riscv/include/.. \
    $IPS/riscv/../../rtl/includes \
    $IPS/riscv/include \
    $IPS/adv_dbg_if/rtl \
"

set MODELSIM_INC_DIRS ""
foreach elem $INC_DIRS {
    append MODELSIM_INC_DIRS "+incdir+$elem " 
}


# Macros
set MACROS " \
    USE_ZERO_RISCY=0 \
    RISCY_RV32F=0 \
    ZERO_RV32M=0 \
    ZERO_RV32E=0 \
    PULP_FPGA_EMUL=1 \
    QUARTUS=1 \
"

set MODELSIM_MACROS ""
foreach elem $MACROS {
    append MODELSIM_MACROS "+define+$elem " 
}


# Start compiling
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/fpga_quartus/ips/altera_mem {$PROJECT_ROOT/fpga_quartus/ips/altera_mem/altera_sp_ram_data.v}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/fpga_quartus/../ips/axi/axi_node/. {$PROJECT_ROOT/fpga_quartus/../ips/axi/axi_node/./defines.v}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/fpga_quartus/../ips/adv_dbg_if/rtl {$PROJECT_ROOT/fpga_quartus/../ips/adv_dbg_if/rtl/adbg_defines.v}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/fpga_quartus/../ips/adv_dbg_if/rtl {$PROJECT_ROOT/fpga_quartus/../ips/adv_dbg_if/rtl/adbg_or1k_defines.v}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/fpga_quartus/../ips/adv_dbg_if/rtl {$PROJECT_ROOT/fpga_quartus/../ips/adv_dbg_if/rtl/adbg_axi_defines.v}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/fpga_quartus/../ips/adv_dbg_if/rtl {$PROJECT_ROOT/fpga_quartus/../ips/adv_dbg_if/rtl/adbg_tap_defines.v}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_node {$PROJECT_ROOT/ips/axi/axi_node/axi_address_decoder_AR.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_node {$PROJECT_ROOT/ips/axi/axi_node/axi_address_decoder_AW.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_node {$PROJECT_ROOT/ips/axi/axi_node/axi_address_decoder_BR.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_node {$PROJECT_ROOT/ips/axi/axi_node/axi_address_decoder_BW.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_node {$PROJECT_ROOT/ips/axi/axi_node/axi_address_decoder_DW.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_node {$PROJECT_ROOT/ips/axi/axi_node/axi_AR_allocator.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_node {$PROJECT_ROOT/ips/axi/axi_node/axi_ArbitrationTree.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_node {$PROJECT_ROOT/ips/axi/axi_node/axi_AW_allocator.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_node {$PROJECT_ROOT/ips/axi/axi_node/axi_DW_allocator.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_node {$PROJECT_ROOT/ips/axi/axi_node/axi_FanInPrimitive_Req.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_node {$PROJECT_ROOT/ips/axi/axi_node/axi_multiplexer.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_node {$PROJECT_ROOT/ips/axi/axi_node/axi_request_block.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_node {$PROJECT_ROOT/ips/axi/axi_node/axi_response_block.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_node {$PROJECT_ROOT/ips/axi/axi_node/axi_RR_Flag_Req.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/apb/apb_node {$PROJECT_ROOT/ips/apb/apb_node/apb_node.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_spi_slave {$PROJECT_ROOT/ips/axi/axi_spi_slave/axi_spi_slave.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_spi_slave {$PROJECT_ROOT/ips/axi/axi_spi_slave/spi_slave_axi_plug.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_spi_slave {$PROJECT_ROOT/ips/axi/axi_spi_slave/spi_slave_cmd_parser.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_spi_slave {$PROJECT_ROOT/ips/axi/axi_spi_slave/spi_slave_controller.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_spi_slave {$PROJECT_ROOT/ips/axi/axi_spi_slave/spi_slave_dc_fifo.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_spi_slave {$PROJECT_ROOT/ips/axi/axi_spi_slave/spi_slave_regs.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_spi_slave {$PROJECT_ROOT/ips/axi/axi_spi_slave/spi_slave_rx.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_spi_slave {$PROJECT_ROOT/ips/axi/axi_spi_slave/spi_slave_syncro.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_spi_slave {$PROJECT_ROOT/ips/axi/axi_spi_slave/spi_slave_tx.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_spi_master {$PROJECT_ROOT/ips/axi/axi_spi_master/axi_spi_master.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_spi_master {$PROJECT_ROOT/ips/axi/axi_spi_master/spi_master_clkgen.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_spi_master {$PROJECT_ROOT/ips/axi/axi_spi_master/spi_master_rx.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_spi_master {$PROJECT_ROOT/ips/axi/axi_spi_master/spi_master_tx.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/apb/apb_gpio {$PROJECT_ROOT/ips/apb/apb_gpio/apb_gpio.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/apb/apb_fll_if {$PROJECT_ROOT/ips/apb/apb_fll_if/apb_fll_if.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/core2axi {$PROJECT_ROOT/ips/axi/core2axi/core2axi.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/apb/apb_i2c {$PROJECT_ROOT/ips/apb/apb_i2c/i2c_master_defines.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_slice_dc {$PROJECT_ROOT/ips/axi/axi_slice_dc/dc_full_detector.v}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_slice_dc {$PROJECT_ROOT/ips/axi/axi_slice_dc/dc_synchronizer.v}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_slice_dc {$PROJECT_ROOT/ips/axi/axi_slice_dc/dc_token_ring_fifo_din.v}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_slice_dc {$PROJECT_ROOT/ips/axi/axi_slice_dc/dc_token_ring_fifo_dout.v}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_slice_dc {$PROJECT_ROOT/ips/axi/axi_slice_dc/dc_token_ring.v}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv/include {$PROJECT_ROOT/ips/riscv/include/apu_core_package.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv/include {$PROJECT_ROOT/ips/riscv/include/riscv_defines.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_alu_div.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_hwloop_controller.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_hwloop_regs.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_load_store_unit.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_prefetch_buffer.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_fetch_fifo.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_register_file.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_slice {$PROJECT_ROOT/ips/axi/axi_slice/axi_ar_buffer.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_slice {$PROJECT_ROOT/ips/axi/axi_slice/axi_aw_buffer.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_slice {$PROJECT_ROOT/ips/axi/axi_slice/axi_b_buffer.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_slice {$PROJECT_ROOT/ips/axi/axi_slice/axi_r_buffer.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_slice {$PROJECT_ROOT/ips/axi/axi_slice/axi_slice.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_slice {$PROJECT_ROOT/ips/axi/axi_slice/axi_w_buffer.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/adv_dbg_if/rtl {$PROJECT_ROOT/ips/adv_dbg_if/rtl/adbg_axi_biu.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/adv_dbg_if/rtl {$PROJECT_ROOT/ips/adv_dbg_if/rtl/adbg_crc32.v}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/adv_dbg_if/rtl {$PROJECT_ROOT/ips/adv_dbg_if/rtl/adbg_or1k_biu.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/adv_dbg_if/rtl {$PROJECT_ROOT/ips/adv_dbg_if/rtl/adv_dbg_if.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/apb/apb2per {$PROJECT_ROOT/ips/apb/apb2per/apb2per.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl/components {$PROJECT_ROOT/rtl/components/cluster_clock_gating.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl/components {$PROJECT_ROOT/rtl/components/cluster_clock_inverter.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl/components {$PROJECT_ROOT/rtl/components/cluster_clock_mux2.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl/components {$PROJECT_ROOT/rtl/components/rstgen.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl/components {$PROJECT_ROOT/rtl/components/pulp_clock_inverter.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl/components {$PROJECT_ROOT/rtl/components/pulp_clock_mux2.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl/components {$PROJECT_ROOT/rtl/components/generic_fifo.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl {$PROJECT_ROOT/rtl/boot_code.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl {$PROJECT_ROOT/rtl/ram_mux.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl {$PROJECT_ROOT/rtl/clk_rst_gen.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/fpga_quartus/rtl {$PROJECT_ROOT/fpga_quartus/rtl/pulpino_wrap.v}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/fpga_quartus/../rtl/includes {$PROJECT_ROOT/fpga_quartus/../rtl/includes/config.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/fpga_quartus/../ips/apb/apb_event_unit/./include {$PROJECT_ROOT/fpga_quartus/../ips/apb/apb_event_unit/./include/defines_event_unit.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/fpga_quartus/../ips/riscv/include {$PROJECT_ROOT/fpga_quartus/../ips/riscv/include/riscv_config.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/fpga_quartus/../ips/riscv/include {$PROJECT_ROOT/fpga_quartus/../ips/riscv/include/apu_macros.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_node {$PROJECT_ROOT/ips/axi/axi_node/axi_BR_allocator.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_node {$PROJECT_ROOT/ips/axi/axi_node/axi_BW_allocator.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_node {$PROJECT_ROOT/ips/axi/axi_node/axi_node.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/apb/apb_node {$PROJECT_ROOT/ips/apb/apb_node/apb_node_wrap.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_mem_if_DP {$PROJECT_ROOT/ips/axi/axi_mem_if_DP/axi_read_only_ctrl.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_mem_if_DP {$PROJECT_ROOT/ips/axi/axi_mem_if_DP/axi_write_only_ctrl.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_spi_master {$PROJECT_ROOT/ips/axi/axi_spi_master/spi_master_axi_if.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_spi_master {$PROJECT_ROOT/ips/axi/axi_spi_master/spi_master_controller.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_spi_master {$PROJECT_ROOT/ips/axi/axi_spi_master/spi_master_fifo.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/apb/apb_event_unit {$PROJECT_ROOT/ips/apb/apb_event_unit/apb_event_unit.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/apb/apb_event_unit {$PROJECT_ROOT/ips/apb/apb_event_unit/generic_service_unit.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/apb/apb_event_unit {$PROJECT_ROOT/ips/apb/apb_event_unit/sleep_unit.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/apb/apb_spi_master {$PROJECT_ROOT/ips/apb/apb_spi_master/apb_spi_master.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/apb/apb_timer {$PROJECT_ROOT/ips/apb/apb_timer/apb_timer.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/apb/apb_timer {$PROJECT_ROOT/ips/apb/apb_timer/timer.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi2apb {$PROJECT_ROOT/ips/axi/axi2apb/axi2apb32.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/apb/apb_i2c {$PROJECT_ROOT/ips/apb/apb_i2c/i2c_master_bit_ctrl.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/apb/apb_i2c {$PROJECT_ROOT/ips/apb/apb_i2c/i2c_master_byte_ctrl.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_slice_dc {$PROJECT_ROOT/ips/axi/axi_slice_dc/dc_data_buffer.v}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_alu.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_compressed_decoder.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_controller.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_cs_registers.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_debug_unit.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_decoder.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_int_controller.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_ex_stage.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_id_stage.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_if_stage.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_mult.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv/include {$PROJECT_ROOT/ips/riscv/include/riscv_tracer_defines.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/riscv {$PROJECT_ROOT/ips/riscv/riscv_core.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/adv_dbg_if/rtl {$PROJECT_ROOT/ips/adv_dbg_if/rtl/adbg_axi_module.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/adv_dbg_if/rtl {$PROJECT_ROOT/ips/adv_dbg_if/rtl/adbg_or1k_module.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/adv_dbg_if/rtl {$PROJECT_ROOT/ips/adv_dbg_if/rtl/adbg_or1k_status_reg.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/adv_dbg_if/rtl {$PROJECT_ROOT/ips/adv_dbg_if/rtl/adbg_top.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/adv_dbg_if/rtl {$PROJECT_ROOT/ips/adv_dbg_if/rtl/adbg_tap_top.v}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl {$PROJECT_ROOT/rtl/axi2apb_wrap.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl {$PROJECT_ROOT/rtl/periph_bus_wrap.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl {$PROJECT_ROOT/rtl/core2axi_wrap.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl {$PROJECT_ROOT/rtl/axi_node_intf_wrap.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl {$PROJECT_ROOT/rtl/axi_spi_slave_wrap.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl {$PROJECT_ROOT/rtl/axi_slice_wrap.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl {$PROJECT_ROOT/rtl/axi_mem_if_SP_wrap.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl {$PROJECT_ROOT/rtl/instr_ram_wrap.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl {$PROJECT_ROOT/rtl/sp_ram_wrap.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl {$PROJECT_ROOT/rtl/boot_rom_wrap.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl {$PROJECT_ROOT/rtl/peripherals.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl {$PROJECT_ROOT/rtl/pulpino_top.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/axi/axi_mem_if_DP {$PROJECT_ROOT/ips/axi/axi_mem_if_DP/axi_mem_if_SP.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/apb/apb_spi_master {$PROJECT_ROOT/ips/apb/apb_spi_master/spi_master_apb_if.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/apb/apb_pulpino {$PROJECT_ROOT/ips/apb/apb_pulpino/apb_pulpino.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/ips/apb/apb_i2c {$PROJECT_ROOT/ips/apb/apb_i2c/apb_i2c.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/rtl {$PROJECT_ROOT/rtl/core_region.sv}
eval vcom -93 -work work {$PROJECT_ROOT/ips/apb/apb_uart/apb_uart.vhd}
eval vcom -93 -work work {$PROJECT_ROOT/ips/apb/apb_uart/slib_clock_div.vhd}
eval vcom -93 -work work {$PROJECT_ROOT/ips/apb/apb_uart/slib_counter.vhd}
eval vcom -93 -work work {$PROJECT_ROOT/ips/apb/apb_uart/slib_edge_detect.vhd}
eval vcom -93 -work work {$PROJECT_ROOT/ips/apb/apb_uart/slib_fifo.vhd}
eval vcom -93 -work work {$PROJECT_ROOT/ips/apb/apb_uart/slib_input_filter.vhd}
eval vcom -93 -work work {$PROJECT_ROOT/ips/apb/apb_uart/slib_input_sync.vhd}
eval vcom -93 -work work {$PROJECT_ROOT/ips/apb/apb_uart/slib_mv_filter.vhd}
eval vcom -93 -work work {$PROJECT_ROOT/ips/apb/apb_uart/uart_baudgen.vhd}
eval vcom -93 -work work {$PROJECT_ROOT/ips/apb/apb_uart/uart_interrupt.vhd}
eval vcom -93 -work work {$PROJECT_ROOT/ips/apb/apb_uart/uart_receiver.vhd}
eval vcom -93 -work work {$PROJECT_ROOT/ips/apb/apb_uart/uart_transmitter.vhd}

# Loading the testbench
eval vlog -sv -work work {*}$MODELSIM_MACROS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/i2c_eeprom_model.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/if_spi_master.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/if_spi_slave.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/jtag_dpi.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/pkg_spi.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/tb.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/tb_jtag_pkg.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/tb_mem_pkg.sv}
#eval vlog -sv -work work {*}$MODELSIM_MACROS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/tb_spi_pkg.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/uart.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run -all
