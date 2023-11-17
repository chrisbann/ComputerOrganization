library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SignExtend is
port(
     x : in  STD_LOGIC_VECTOR(31 downto 0);
     y : out STD_LOGIC_VECTOR(63 downto 0) -- sign-extend(x)
);
end SignExtend;

architecture dataflow of SignExtend is
     begin
         y <= (x & x"FFFFFFFF") when (x(0) = '1') else
              (x & x"00000000");
end dataflow;