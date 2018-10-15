#============================================================
# CLOCK2
#============================================================
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to spi_clk_i
set_location_assignment PIN_AA16 -to spi_clk_i

#============================================================
# CLOCK3
#============================================================
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to tck
set_location_assignment PIN_Y26 -to tck


#============================================================
# CLOCK
#============================================================
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clk
set_location_assignment PIN_AF14 -to clk


#============================================================
# SW
#============================================================
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to rst_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to fetch_enable_i
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SW[9]

set_location_assignment PIN_AB12 -to rst_n
set_location_assignment PIN_AC12 -to fetch_enable_i

set_location_assignment PIN_AF9 -to SW[2]
set_location_assignment PIN_AF10 -to SW[3]
set_location_assignment PIN_AD11 -to SW[4]
set_location_assignment PIN_AD12 -to SW[5]
set_location_assignment PIN_AE11 -to SW[6]
set_location_assignment PIN_AC9 -to SW[7]
set_location_assignment PIN_AD10 -to SW[8]
set_location_assignment PIN_AE12 -to SW[9]

#============================================================
# LED
#============================================================
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_out[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_out[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_out[2]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_out[3]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_out[4]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_out[5]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_out[6]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_out[7]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to gpio_out[8]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LEDR[9]
set_location_assignment PIN_V16 -to gpio_out[0]
set_location_assignment PIN_W16 -to gpio_out[1]
set_location_assignment PIN_V17 -to gpio_out[2]
set_location_assignment PIN_V18 -to gpio_out[3]
set_location_assignment PIN_W17 -to gpio_out[4]
set_location_assignment PIN_W19 -to gpio_out[5]
set_location_assignment PIN_Y19 -to gpio_out[6]
set_location_assignment PIN_W20 -to gpio_out[7]
set_location_assignment PIN_W21 -to gpio_out[8]

set_location_assignment PIN_Y21 -to LEDR[9]
