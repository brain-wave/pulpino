PROJECT:=pulpino
TOP_LEVEL:=pulpino_top


synthesis:
	@mkdir -p syn
	@export FPGA_ROOT="/home/edbruin/projects/pulpino_fpga/fpga_quartus" && cd syn && quartus_sh -t ../tcl/run.qsf

rtlgui:
	@mkdir -p sim/rtl
	@cd sim/rtl && ln -s /home/edbruin/projects/pulpino/sw/build/apps/helloworld/slm_files slm_files
	@export PROJECT_ROOT="/home/edbruin/projects/pulpino_fpga" && export FPGA_ROOT="/home/edbruin/projects/pulpino_fpga/fpga_quartus" && cd sim/rtl && vsim -do ../../scripts/rtl_modelsim.do

ntlgui:
	@mkdir -p sim/syn
	@cd sim/syn && ln -s /home/edbruin/projects/pulpino/sw/build/apps/helloworld/slm_files slm_files
	@export PROJECT_ROOT="/home/edbruin/projects/pulpino_fpga" && export FPGA_ROOT="/home/edbruin/projects/pulpino_fpga/fpga_quartus" && cd sim/syn && vsim -do ../../scripts/modelsim.do

clean:
	@rm -rf syn
	@rm -rf sim
	@rm transcript
