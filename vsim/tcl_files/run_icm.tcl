#!/bin/bash

Tests=$(ls ../coverage)

cmd="merge"
for test in $Tests
do
	echo "$test"
	cmd="$cmd ../coverage/$test/scope/test"
done

cmd="$cmd -out ../coverage/all -message 1 -overwrite"
# echo "$cmd"

echo "$cmd" > run_icm_eval.tcl