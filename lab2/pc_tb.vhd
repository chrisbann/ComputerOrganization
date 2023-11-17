library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use IEEE.numeric_std.all;

entity pc_tb is
end pc_tb;
  

architecture Behavioral of pc_tb is 
constant CLK_Time : time := 15 ns;

  component PC is
  port(
      clk          : in  STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
      write_enable : in  STD_LOGIC; -- Only write if '1'
      rst          : in  STD_LOGIC; -- Asynchronous reset! Sets AddressOut to 0x0
      AddressIn    : in  STD_LOGIC_VECTOR(63 downto 0); -- Next PC address
      AddressOut   : out STD_LOGIC_VECTOR(63 downto 0) -- Current PC address
  );
  end component;

  signal simulationStop : BOOLEAN := false;
  signal clk : STD_LOGIC := '0';
  signal write_enable : STD_LOGIC := '0';
  signal rst : STD_LOGIC := '0';
  signal AddressIn : STD_LOGIC_VECTOR (63 downto 0);
  signal AddressOut : STD_LOGIC_VECTOR (63 downto 0);

  begin 

  process begin 

  while not simulationStop loop
    clk <= '0';
    wait for CLK_Time / 3;
    clk <= '1';
    wait for CLK_Time / 3;
    end loop;
    wait;
    end process;
  
  uut : PC port map(clk, write_enable, rst, AddressIn, AddressOut);

  process begin 
  write_enable <= '0';
  rst <= '0';
  AddressIn <= x"1234512345123456";
  wait for CLK_Time * 2;
  write_enable <= '1';
  AddressIn <= x"1234512345123456";
  wait for CLK_Time * 2;

  rst <= '1';

  simulationStop <= true;
  assert false report "Test Done" severity note;
  wait; 
  end process;

  end Behavioral; 
  

