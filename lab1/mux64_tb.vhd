library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux64_tb is
end mux64_tb;

architecture structural of mux64_tb is 
  component MUX64 is
  port(
      in0    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 0
      in1    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 1
      sel    : in STD_LOGIC; -- selects in0 or in1
      output : out STD_LOGIC_VECTOR(63 downto 0)
  );
  end component;
  
  signal A_in : STD_LOGIC_VECTOR(63 downto 0);
  signal B_in : STD_LOGIC_VECTOR(63 downto 0);
  signal C_sel : STD_LOGIC;
  signal Y_out: STD_LOGIC_VECTOR(63 downto 0);

begin
  uut: mux64 port map(
    in0 => A_in,
    in1 => B_in,
    sel => C_sel,
    output => Y_out
  );
stim_proc: process
begin
  -- test case #1: 0 AND 0
  A_in <= x"0000000000000000";
  B_in <= x"FFFFFFFFFFFFFFFF";
  C_sel <= '0';
  wait for 50 ns;
  assert Y_out = x"0000000000000000" report "FAILED sel = 0";

  -- test case #1: 0 AND 0
  A_in <= x"0000000000000000";
  B_in <= x"FFFFFFFFFFFFFFFF";
  C_sel <= '1';
  wait for 50 ns;
  assert Y_out = x"FFFFFFFFFFFFFFFF" report "FAILED sel = 1";
  assert false report "TEST done." severity note;
  wait;
end process;
end structural;