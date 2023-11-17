library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

entity PipeCPU_testbench is
end PipeCPU_testbench;

-- when your testbench is complete you should report error with severity failure.
-- this will end the simulation. Do not add stop times to the Makefile


pipelinedcpu : entity work.PipelinedCPU0 port map(clk, rst, debug_pc, debug_instruction, 
						     debug_tmp_regs, debug_saved_regs, debug_mem_contents);


rst <= not rst after period/2 when rst = '1';
clk <= not clk after period;