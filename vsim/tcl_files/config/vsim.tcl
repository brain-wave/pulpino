echo "start vsim.tcl"
# source tcl_files/config/vsim_ips.tcl

# set cmd "ncsim -quiet $TB \
  # -L pulpino_lib \
  # $VSIM_IP_LIBS \
  # +nowarnTRAN \
  # +nowarnTSCALE \
  # +nowarnTFMPC \
  # +MEMLOAD=$MEMLOAD \
  # -gUSE_ZERO_RISCY=$env(USE_ZERO_RISCY) \
  # -gRISCY_RV32F=$env(RISCY_RV32F) \
  # -gZERO_RV32M=$env(ZERO_RV32M) \
  # -gZERO_RV32E=$env(ZERO_RV32E) \
  # -t ps \
  # -voptargs=\"+acc -suppress 2103\" \
  # $VSIM_FLAGS"

  echo "elaborate"
  
irun -elaborate -cdslib ${SW_DIR}/../vsim/cds.lib -work tb ${SW_DIR}/../tb/tb.sv -snapshot tb_snapshot -update -forceelab -access +rwc  -timescale 1ns/1ps  -notimingchecks -lib_binding \
										-coverage block -coverage expr -coverage fsm -coverage toggle -coverage functional -messages \
										-incdir ${SW_DIR}/../rtl/includes \
										-incdir ${SW_DIR}/../tb/ 
echo "here"	
pwd	
find ../../../../ -name "tb_snapshot*"
										
# set cmd "$cmd -sv_lib ./work/libri5cyv2sim"
# eval $cmd

# check exit status in tb and quit the simulation accordingly
# proc run_and_exit {} {
  # run -all
  # quit -code [examine -radix decimal sim:/tb/exit_status]
# }
echo "end vsim.tcl"
