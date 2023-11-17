library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity AND2 is
port (
      in0    : in  STD_LOGIC;
      in1    : in  STD_LOGIC;
      output : out STD_LOGIC -- in0 and in1
);
end AND2;


architecture dataflow of and2 is

begin
     output <= in0 and in1; 

end dataflow;