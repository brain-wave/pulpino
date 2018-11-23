#!/bin/bash

echo "start run_test.tcl"

set TB            tb
set MEMLOAD       "PRELOAD"

Passed="0"
NextWord="0"

# source ./tcl_files/config/vsim.tcl
rm uart.out
rm -rf ./cov_work
pwd
irun -cdslib ${SW_DIR}/../vsim/cds.lib -work tb ${SW_DIR}/../tb/tb.sv -incdir ${SW_DIR}/../rtl/includes  -incdir ${SW_DIR}/../tb/  -access +rwc  -timescale 1ns/1ps  -notimingchecks -lib_binding -update -coverage block -coverage expr -coverage fsm -coverage toggle -coverage functional -messages


dirname=${PWD##*/}
ls

if [ ! -d "${SW_DIR}/../vsim/coverage" ]; then
  mkdir ${SW_DIR}/../vsim/coverage
fi

if [ ! -d "${SW_DIR}/../vsim/coverage/${dirname}" ]; then
  mkdir ${SW_DIR}/../vsim/coverage/${dirname}
fi

mv cov_work/* ${SW_DIR}/../vsim/coverage/${dirname}
pwd
ls ${SW_DIR}/../vsim/coverage/${dirname}
while IFS='' read -r line || [[ -n "$line" ]]; do
	for word in $line
	do
		echo "word $word"
		if [ $NextWord = "1" ]
			then
			echo "expected SUCCESS"
			if [ $word = "SUCCESS" ]
			then
				Passed="1"
			fi
		fi
		if [ $word = "SUMMARY:" ] 
		then
			NextWord="1"
		fi
	done
done < uart.out

ExitCode=1
ExitCode=$(cat exit_status.txt) 
echo "ExitCode $ExitCode"
if [ $ExitCode != "0" ]
then
	echo "exit........."
	exit -1
fi
if [ $Passed != "1" ]
then
	echo "exit........."
	exit -1
fi

echo "end run_test.tcl"
