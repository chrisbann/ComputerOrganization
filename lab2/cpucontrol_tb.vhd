library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cpu_control_tb is
-- Empty for Testbench
end cpu_control_tb;

architecture structural of cpu_control_tb is
	component CPUControl is
		port(Opcode   : in  STD_LOGIC_VECTOR(10 downto 0);
     Reg2Loc   : out STD_LOGIC;
     CBranch  : out STD_LOGIC;  --conditional
     MemRead  : out STD_LOGIC;
     MemtoReg : out STD_LOGIC;
     MemWrite : out STD_LOGIC;
     ALUSrc   : out STD_LOGIC;
     RegWrite : out STD_LOGIC;
     UBranch  : out STD_LOGIC; -- This is unconditional
     ALUOp    : out STD_LOGIC_VECTOR(1 downto 0)
  );
	end component;
	
	signal opc : STD_LOGIC_VECTOR(10 downto 0);
	signal reg : STD_LOGIC;
  signal cbr : STD_LOGIC;
	signal memr : STD_LOGIC;
  signal memt : STD_LOGIC;
  signal memw : STD_LOGIC;
  signal alus : STD_LOGIC;
  signal regw : STD_LOGIC;
  signal ubr : STD_LOGIC;
  signal aluo : STD_LOGIC_VECTOR (1 downto 0);

	
begin
	CPUControl_uut : CPUControl
		port map (opc, reg, cbr, memr, memt, memw, alus, regw, ubr, aluo);
		
test_cases : process
begin
	-- test case #1
	opc <= b"10001010000";
		wait for 50 ns;
		assert reg = '0' report "fail tc1 - check 0";
    assert cbr = '0' report "fail tc1 - check 0";
    assert memr = '0' report "fail tc1 - check 0";
    assert memt = '1' report "fail tc1 - check 1";
    assert memw = '0' report "fail tc1 - check 0";
    assert alus = '0' report "fail tc1 - check 0";
    assert regw = '0' report "fail tc1 - check 0";
    assert ubr = '1' report "fail tc1 - check 1";
    assert aluo = "10" report "fail tc1 - check 10";

	-- test case #2
  opc <= b"11111000010";
  wait for 50 ns;
  assert reg = '0' report "fail tc2 - check 0";
  assert cbr = '1' report "fail tc2 - check 1";
  assert memr = '1' report "fail tc2 - check 1";
  assert memt = '1' report "fail tc2 - check 1";
  assert memw = '1' report "fail tc2 - check 1";
  assert alus = '0' report "fail tc2 - check 0";
  assert regw = '0' report "fail tc2 - check 0";
  assert ubr = '0' report "fail tc2 - check 0";
  assert aluo = "10" report "fail tc2 - check 10";
		
	-- test case #3
  opc <= b"11111000000";
  wait for 50 ns;
  assert reg = '1' report "fail tc3 - check 1";
  assert cbr = '1' report "fail tc3 - check 1";
  assert memr = '0' report "fail tc3 - check 0";
  assert memt = '0' report "fail tc3 - check 0";
  assert memw = '0' report "fail tc3 - check 0";
  assert alus = '1' report "fail tc3 - check 1";
  assert regw = '0' report "fail tc3 - check 0";
  assert ubr = '0' report "fail tc3 - check 0";
  assert aluo = "10" report "fail tc3 - check 10";
		
	-- test case #4
  opc <= b"10110100000";
  wait for 50 ns;
  assert reg = '1' report "fail tc1 - check 1";
  assert cbr = '0' report "fail tc1 - check 0";
  assert memr = '0' report "fail tc1 - check 0";
  assert memt = '0' report "fail tc1 - check 0";
  assert memw = '0' report "fail tc1 - check 0";
  assert alus = '0' report "fail tc1 - check 0";
  assert regw = '1' report "fail tc1 - check 1";
  assert ubr = '0' report "fail tc1 - check 0";
  assert aluo = '10' report "fail tc1 - check 10";
		
	-- test case #5
  opc <= b"00010100000";
  wait for 50 ns;
  assert reg = '0' report "fail tc4 - check 0";
  assert cbr = '0' report "fail tc4 - check 0";
  assert memr = '0' report "fail tc4 - check 0";
  assert memt = '0' report "fail tc4 - check 1";
  assert memw = '0' report "fail tc4 - check 0";
  assert alus = '0' report "fail tc4 - check 0";
  assert regw = '0' report "fail tc4 - check 0";
  assert ubr = '1' report "fail tc4 - check 1";
  assert aluo = '00' report "fail tc4 - check 00";
	
	-- test case #6
  opc <= b"10010001000";
  wait for 50 ns;
  assert reg = '0' report "fail tc5 - check 0";
  assert cbr = '0' report "fail tc5 - check 0";
  assert memr = '0' report "fail tc5 - check 0";
  assert memt = '0' report "fail tc5 - check 0";
  assert memw = '0' report "fail tc5 - check 0";
  assert alus = '1' report "fail tc5 - check 0";
  assert regw = '1' report "fail tc5 - check 0";
  assert ubr = '0' report "fail tc5 - check 1";
  assert aluo = "01" report "fail tc5 - check 10";


end process;

end structural;