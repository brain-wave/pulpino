#set_property include_dirs {
#    ../.././rtl/includes \
#    ../.././ips/axi/axi_node/. \
#    ../.././ips/apb/apb_event_unit/./include/ \
#    ../.././ips/fpu/. \
#    ../.././ips/apb/apb_i2c/. \
#    ../.././ips/zero-riscy/include \
#    ../.././ips/zero-riscy/include \
#    ../.././ips/riscv/include \
#    ../.././ips/riscv/include/.. \
#    ../.././ips/riscv/../../rtl/includes \
#    ../.././ips/riscv/include \
#    ../.././ips/adv_dbg_if/rtl \
#} [current_fileset] 

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

foreach inc_dir $INC_DIRS { 
    set_global_assignment -name SEARCH_PATH $inc_dir 
}
