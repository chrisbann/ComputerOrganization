GHDL=ghdl
VERS="--std=08"
FLAG="--ieee=synopsys"

# IMPORTANT: do not change the names of the testbench files or entities here
# instead, ensure that YOUR testbench files and entity names match the ones here

.common: 
	@$(GHDL) -a $(VERS) mux5.vhd mux64.vhd pc.vhd shiftleft2.vhd signextend.vhd
# TODO: add your adder file names below (from lab2):
	@$(GHDL) -a $(VERS) fullAdder.vhd add.vhd
	@$(GHDL) -a $(VERS) alu.vhd alucontrol.vhd cpucontrol.vhd dmem.vhd registers.vhd
# TODO: add any other single-cycle-cpu helper files below:
#	@$(GHDL) -a $(VERS) 


# You should not need to edit anything below
p1:
	make .common
	@$(GHDL) -a $(VERS) imem_p1.vhd singlecyclecpu.vhd sscpu_testbench.vhd # name your testbench sscpu_testbench.vhd
	@$(GHDL) -e $(VERS) sscpu_testbench
	@$(GHDL) -r $(VERS) sscpu_testbench --wave=p1.ghw

comp:
	make .common
	@$(GHDL) -a $(VERS) imem_comp.vhd singlecyclecpu.vhd sscpu_testbench.vhd
	@$(GHDL) -e $(VERS) sscpu_testbench
	@$(GHDL) -r $(VERS) sscpu_testbench --wave=comp.ghw

ldstr:
	make .common
	@$(GHDL) -a $(VERS) imem_ldstr.vhd singlecyclecpu.vhd sscpu_testbench.vhd
	@$(GHDL) -e $(VERS) sscpu_testbench
	@$(GHDL) -r $(VERS) sscpu_testbench --wave=ldstr.ghw

clean:
	rm *_sim.out *.cf *.ghw