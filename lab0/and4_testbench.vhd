library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity and4_testbench is
end and4_testbench;

architecture structural of and4_testbench is 
  component AND4 is
  port ( in0 : in STD_LOGIC;
         in1 : in STD_LOGIC;
         in2 : in STD_LOGIC;
         in3 : in STD_LOGIC;
         output : out STD_LOGIC
  );
  end component;
  
  signal A_in : std_logic := '0';
  signal B_in : std_logic := '0';
  signal Y_out : std_logic;
  signal c_in : std_logic := '0';
  signal d_in : std_logic := '0';

begin
  uut: and4 port map(A_in, B_in, c_in, d_in, Y_out);
stim_proc: process
begin
  -- test case #1: 0 AND 0
  A_in <= '0';
  B_in <= '0';
  c_in <= '0';
  d_in <= '0';
  wait for 50 ns;
  assert Y_out = '0' report "FAILED 0 and 0";

  -- test case #1: 1 AND 1
  A_in <= '1';
  B_in <= '1';
  c_in <= '1';
  d_in <= '1';
  wait for 50 ns;
  assert Y_out = '1' report "FAILED 1 and 1 and 1 and 1";

  a_in <= '0';
  b_in <= '0';

  assert false report "TEST done." severity note;
  wait;
end process;
end structural;