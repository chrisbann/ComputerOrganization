library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

entity PipeCPU_testbench is
end PipeCPU_testbench;

architecture structural of PipeCPU_testbench is

	signal clk : std_logic := '1';
	signal rst : std_logic := '1';
	signal debug_pc : std_logic_vector(63 downto 0);
	signal debug_instruction : std_logic_vector(31 downto 0);
	signal debug_tmp_regs : std_logic_vector(64*4-1 downto 0);
	signal debug_saved_regs : std_logic_vector(64*4-1 downto 0);
	signal debug_mem_contents : std_logic_vector(64*4-1 downto 0);
	constant period : time := 10 ns;

	component PipelinedCPU0 is
		port(
				 clk : in STD_LOGIC;
				 rst : in STD_LOGIC;
				 --Probe ports used for testing
				 --The current address (AddressOut from the PC)
				 DEBUG_PC : out STD_LOGIC_VECTOR(63 downto 0);
				 --The current instruction (Instruction output of IMEM)
				 DEBUG_INSTRUCTION : out STD_LOGIC_VECTOR(31 downto 0);
				 --DEBUG ports from other components
				 DEBUG_TMP_REGS     : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
				 DEBUG_SAVED_REGS   : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
				 DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
		);
		end component;
		

-- when your testbench is complete you should report error with severity failure.
-- this will end the simulation. Do not add stop times to the Makefile

		begin
		pipelinedcpu : PipelinedCPU0 port map(clk, rst, debug_pc, debug_instruction, 
								     debug_tmp_regs, debug_saved_regs, debug_mem_contents);
		
		
		
		
		rst <= not rst after period/2 when rst = '1';
		clk <= not clk after period;
		
		
	end structural;