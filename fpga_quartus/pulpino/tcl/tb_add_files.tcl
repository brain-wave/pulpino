# settings
set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
set_global_assignment -name EDA_TEST_BENCH_ENABLE_STATUS TEST_BENCH_MODE -section_id eda_simulation
set_global_assignment -name EDA_NATIVELINK_SIMULATION_TEST_BENCH tb -section_id eda_simulation
set_global_assignment -name EDA_TEST_BENCH_NAME tb -section_id eda_simulation
set_global_assignment -name EDA_DESIGN_INSTANCE_NAME NA -section_id tb
set_global_assignment -name EDA_TEST_BENCH_MODULE_NAME tb -section_id tb

# files
set_global_assignment -name EDA_TEST_BENCH_FILE $TB/i2c_eeprom_model.sv -section_id tb
set_global_assignment -name EDA_TEST_BENCH_FILE $TB/if_spi_master.sv -section_id tb
set_global_assignment -name EDA_TEST_BENCH_FILE $TB/if_spi_slave.sv -section_id tb
set_global_assignment -name EDA_TEST_BENCH_FILE $TB/jtag_dpi.sv -section_id tb
set_global_assignment -name EDA_TEST_BENCH_FILE $TB/mem_dpi.svh -section_id tb
set_global_assignment -name EDA_TEST_BENCH_FILE $TB/pkg_spi.sv -section_id tb
set_global_assignment -name EDA_TEST_BENCH_FILE $TB/spi_debug_test.svh -section_id tb
set_global_assignment -name EDA_TEST_BENCH_FILE $TB/tb.sv -section_id tb
set_global_assignment -name EDA_TEST_BENCH_FILE $TB/tb_jtag_pkg.sv -section_id tb
set_global_assignment -name EDA_TEST_BENCH_FILE $TB/tb_mem_pkg.sv -section_id tb
set_global_assignment -name EDA_TEST_BENCH_FILE $TB/tb_spi_pkg.sv -section_id tb
set_global_assignment -name EDA_TEST_BENCH_FILE $TB/uart.sv -section_id tb
