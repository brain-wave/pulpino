#!/bin/bash
# \
exec ncsim -64 -do "$0"
echo "start run_spi.tcl"
set TB            tb
set TB_TEST $::env(TB_TEST)
set VSIM_FLAGS    "-GTEST=\"$TB_TEST\""
set MEMLOAD       "SPI"

source ./tcl_files/config/vsim.tcl
echo "end run_spi.tcl"
