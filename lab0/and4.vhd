library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity AND4 is
port (
      in0    : in  STD_LOGIC;
      in1    : in  STD_LOGIC;
      in2    : in  STD_LOGIC;
      in3    : in  STD_LOGIC;
      output : out STD_LOGIC -- in0 and in1
);
end AND4;


architecture structural of AND4 is
  signal output1: std_logic;
  signal output2: std_logic;
begin
      out1: AND2 portmap(in0, in1, output1);
      out2: AND2 portmap(in2, in3, output2);
      output <= out1 and out2;
end structural;