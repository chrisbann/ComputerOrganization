library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shiftleft2_tb is
end shiftleft2_tb;

architecture structural of shiftleft2_tb is 
  component ShiftLeft2 is
    port(
     x : in  STD_LOGIC_VECTOR(63 downto 0);
     y : out STD_LOGIC_VECTOR(63 downto 0) -- x << 2
  );
  end component;
  
  signal A_in : STD_LOGIC_VECTOR(63 downto 0);
  signal Y_out: STD_LOGIC_VECTOR(63 downto 0);

begin

  uut: shiftleft2 port map(
    x => A_in,
    y => Y_out
  );


stim_proc: process
begin
  -- test case #1: 0 AND 0
  A_in <= x"FFFFFFFFFFFFFFFF";
  wait for 50 ns;
  assert Y_out = x"FFFFFFFFFFFFFFFC" report "FAILED first num = 1";

  -- test case #1: 0 AND 0
  A_in <= x"0000000000000000";
  wait for 50 ns;
  assert Y_out = x"0000000000000000" report "FAILED first num = 0";

  assert false report "TEST done." severity note;
  wait;
end process;
end structural;