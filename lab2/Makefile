GHDL=ghdl
VERS="--std=08"
FLAG="--ieee=synopsys"

# IMPORTANT: do not change the names of the testbench files or entities here
# instead, ensure that YOUR testbench files and entity names match the ones here

add:
	@$(GHDL) -a $(VERS) add.vhd fullAdder.vhd add_testbench.vhd
	@$(GHDL) -e $(VERS) add_testbench
	@$(GHDL) -r $(VERS) add_testbench --wave=add.ghw

alu:
	@$(GHDL) -a $(VERS) alu.vhd add.vhd fullAdder.vhd alu_testbench.vhd	
	@$(GHDL) -e $(VERS) alu_testbench
	@$(GHDL) -r $(VERS) alu_testbench --wave=alu.ghw

alu-control:
	@$(GHDL) -a $(VERS) alucontrol.vhd alu_control_testbench.vhd	
	@$(GHDL) -e $(VERS) alu_control_testbench
	@$(GHDL) -r $(VERS) alu_control_testbench --wave=alu_control.ghw

registers:
	@$(GHDL) -a $(VERS) registers.vhd registers_testbench.vhd
	@$(GHDL) -e $(VERS) registers_testbench
	@$(GHDL) -r $(VERS) registers_testbench --wave=registers.ghw

dmem:
	ghdl -a $(VERS) dmem.vhd dmem_testbench.vhd
	ghdl -e $(VERS) dmem_testbench
	ghdl -r $(VERS) dmem_testbench --wave=dmem.ghw

pc:
	@$(GHDL) -a $(VERS) pc.vhd pc_tb.vhd	
	@$(GHDL) -e $(VERS) pc_tb
	@$(GHDL) -r $(VERS) pc_tb --wave=pc.ghw

clean:
	rm *_sim.out *.cf *.ghw