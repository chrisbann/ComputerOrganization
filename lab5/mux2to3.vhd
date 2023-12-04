library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux2to3 is -- Two by one mux with 5 bit inputs/outputs
port(
    in0    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 00
    in1    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 01
    in2    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 10
    sel    : in STD_LOGIC_VECTOR(1 downto 0); -- selects in0 or in1 or in 2
    output : out STD_LOGIC_VECTOR(63 downto 0)
);
end mux2to3;

architecture dataflow of mux2to3 is

begin
    with sel select 
        output <= in0 when "00",
                  in1 when "01",
                  in2 when "10",
                  x"----------------"      when others;
end dataflow;
