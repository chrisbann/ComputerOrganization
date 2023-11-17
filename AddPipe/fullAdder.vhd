
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fullAdder is 
    port (
            Cin       : in std_logic;
            A, B      : in std_logic;
            S         : out std_logic;
            Cout      : out std_logic
         );

end fullAdder;

architecture dat_flow of fullAdder is 
    signal P, G: std_logic;
begin 
    P <= A xor B;
    G <= A and B;
    
    S <= P xor Cin;
    Cout <= G or (P and Cin);
end;

