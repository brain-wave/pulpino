#!/bin/bash
rm -rf ../coverage/all
source run_icm.tcl
imc -exec run_icm_eval.tcl
pwd
imc -load ../coverage/all