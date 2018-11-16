#!/bin/tcsh
source ${PULP_PATH}/vsim/vcompile/colors.csh

##############################################################################
# Settings
##############################################################################

set IP_NAME="work.tb"


##############################################################################
# Check settings
##############################################################################

# check if environment variables are defined
if (! $?VSIM_PATH ) then
  echo "${Red} VSIM_PATH is not defined ${NC}"
  exit 1
endif

if (! $?TB_PATH ) then
  echo "${Red} TB_PATH is not defined ${NC}"
  exit 1
endif

if (! $?RTL_PATH ) then
  echo "${Red} RTL_PATH is not defined ${NC}"
  exit 1
endif

set LIB_NAME="tb"
set LIB_PATH="${VSIM_PATH}/${LIB_NAME}"

##############################################################################
# Preparing library
##############################################################################

echo "${Green}--> Compiling ${IP_NAME}... ${NC}"

echo "${Green}Compiling component: ${Brown} ${IP_NAME} ${NC}"
echo "${Red}"

##############################################################################
# Compiling RTL
##############################################################################

echo "DEFINE ${LIB_NAME} ${TB_PATH}" >> cds.lib

ncvlog -q -sv -work ${LIB_NAME} -cdslib cds.lib -hdlvar hdl.var -incdir ${TB_PATH}                                            ${TB_PATH}/pkg_spi.sv          || goto error
ncvlog -q -sv -work ${LIB_NAME} -cdslib cds.lib -hdlvar hdl.var -incdir ${TB_PATH}                                            ${TB_PATH}/if_spi_slave.sv     || goto error
ncvlog -q -sv -work ${LIB_NAME} -cdslib cds.lib -hdlvar hdl.var -incdir ${TB_PATH}                                            ${TB_PATH}/if_spi_master.sv    || goto error
ncvlog -q -sv -work ${LIB_NAME} -cdslib cds.lib -hdlvar hdl.var -incdir ${TB_PATH}                                            ${TB_PATH}/uart.sv             || goto error
ncvlog -q -sv -work ${LIB_NAME} -cdslib cds.lib -hdlvar hdl.var -incdir ${TB_PATH}                                            ${TB_PATH}/i2c_eeprom_model.sv || goto error
ncvlog -q -sv -work ${LIB_NAME} -cdslib cds.lib -hdlvar hdl.var -incdir ${TB_PATH} -incdir ${RTL_PATH}/includes/              ${TB_PATH}/tb.sv               || goto error
     echo "got here"                                                
irun -compile -quiet -sv -work ${LIB_NAME}  -cdslib cds.lib    -incdir ${TB_PATH} -incdir ${TB_PATH}/jtag_dpi -top ${TB_PATH}/jtag_dpi.sv         || goto error
     echo "${Yellow} got here"                                                

irun -compile -work ${LIB_NAME} -messages ${TB_PATH}/jtag_dpi/jtag_dpi.c || goto error
     echo "${Red} got here"                                                
                                                     
irun -compile -q -sv -work ${LIB_NAME} -cdslib cds.lib -hdlvar hdl.var -incdir ${TB_PATH} -incdir ${RTL_PATH}/includes/ -dpiheader  ${TB_PATH}/mem_dpi/dpiheader.h -top ${TB_PATH}/tb.sv || goto error
 echo "${Blue} got here"                                                
irun -compile -nocop -work ${LIB_NAME} -messages -top ${TB_PATH}/mem_dpi/mem_dpi.c -dpiheader ${TB_PATH}/mem_dpi/dpiheader.h                 || goto error

# ${TB_PATH}/mem_dpi/dpiheader.h 
# -dpiheader ${TB_PATH}/jtag_dpi/dpiheader.h

echo "${Cyan}--> ${IP_NAME} compilation complete! ${NC}"
exit 0

##############################################################################
# Error handler
##############################################################################

error:
echo "${NC}"
exit 1
