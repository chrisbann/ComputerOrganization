library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MUX64 is -- Two by one mux with 64 bit inputs/outputs
port(
    in0    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 0
    in1    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 1
    sel    : in STD_LOGIC; -- selects in0 or in1
    output : out STD_LOGIC_VECTOR(63 downto 0)
);
end MUX64;


architecture dataflow of MUX64 is
    begin
        process (in0, in1, sel)
        begin
            if sel = '0' or sel = 'U' then
                output <= in0;
            else
                output <= in1;
            end if;
    end process;
end dataflow;