GHDL=ghdl
VERS="--std=08"
FLAG="--ieee=synopsys"

# IMPORTANT: students, please do not change the names of the testbench files or
# entities here. instead, ensure that YOUR testbench files and entity names 
# match the ones here


.common: 
	@$(GHDL) -a $(VERS) mux5.vhd mux64.vhd pc.vhd shiftleft2.vhd signextend.vhd
# TODO: add your adder files below:
	@$(GHDL) -a $(VERS) fullAdder.vhd add.vhd
	@$(GHDL) -a $(VERS) alu.vhd alucontrol.vhd cpucontrol.vhd dmem.vhd registers.vhd
# TODO: add any other helper files below:
	@$(GHDL) -a $(VERS) IF_ID.vhd ID_EX.vhd EX_MEM.vhd MEM_WB.vhd
	@$(GHDL) -a $(VERS) forwardingUnit.vhd hdu.vhd muxCPU.vhd mux2to3.vhd

# TODO: you are free to add files below if that helps
# Do not add stop times. To stop simulations, consult pipecpu1_tv.vhd for information.
p1: 
	make .common
	@$(GHDL) -a $(VERS) imem_p1.vhd
	@$(GHDL) -a $(VERS) pipelinedcpu1.vhd pipecpu1_tb.vhd
	@$(GHDL) -e $(VERS) PipeCPU_testbench
	@$(GHDL) -r $(VERS) PipeCPU_testbench --wave=p1_wave.ghw

p2: 
	make .common
	@$(GHDL) -a $(VERS) imem_p2.vhd
	@$(GHDL) -a $(VERS) pipelinedcpu1.vhd pipecpu1_tb.vhd
	@$(GHDL) -e $(VERS) PipeCPU_testbench
	@$(GHDL) -r $(VERS) PipeCPU_testbench --wave=p2_wave.ghw

#provide:


clean:
	rm *_sim.out *.cf *.ghw