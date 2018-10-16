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

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cyclonev_ver
vmap cyclonev_ver ./verilog_libs/cyclonev_ver
vlog -vlog01compat -work cyclonev_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/mentor/cyclonev_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/mentor/cyclonev_hmi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/cyclonev_atoms.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/cyclonev_hssi_ver
vmap cyclonev_hssi_ver ./verilog_libs/cyclonev_hssi_ver
vlog -vlog01compat -work cyclonev_hssi_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/mentor/cyclonev_hssi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_hssi_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/cyclonev_hssi_atoms.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {/opt/tools/altera/17.0/quartus/eda/sim_lib/altera_mf.v}

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
    SYNTHESIS=1 \
"

set MODELSIM_MACROS ""
foreach elem $MACROS {
    append MODELSIM_MACROS "+define+$elem " 
}

# Compile test bench
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

eval vlog -sv -work work +incdir+. {$FPGA_ROOT/pulpino/syn/simulation/modelsim/pulpino_top.svo}
eval vlog -sv -work work {*}$MODELSIM_MACROS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/i2c_eeprom_model.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/if_spi_master.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/if_spi_slave.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/jtag_dpi.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/pkg_spi.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS {*}$MODELSIM_INC_DIRS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/fpga_tb.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/tb_jtag_pkg.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/tb_mem_pkg.sv}
#vlog -sv -work work {*}$MODELSIM_MACROS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/tb_spi_pkg.sv}
eval vlog -sv -work work {*}$MODELSIM_MACROS +incdir+$PROJECT_ROOT/fpga_quartus/../tb {$PROJECT_ROOT/fpga_quartus/../tb/uart.sv}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L altera_lnsim_ver -L cyclonev_ver -L lpm_ver -L sgate_ver -L cyclonev_hssi_ver -L altera_mf_ver -L cyclonev_pcie_hip_ver -L gate_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run -all
