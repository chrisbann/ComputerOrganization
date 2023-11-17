
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity add32 is 
    port (
            Cin         : in  std_logic;
            A, B        : in  std_logic_vector(31 downto 0);
            S           : out std_logic_vector(31 downto 0);
            V           : out std_logic
         );

end add32;

architecture struct of add32 is 
    component fullAdder is
        port (
            Cin       : in std_logic;
            A, B      : in std_logic;
            S         : out std_logic;
            Cout      : out std_logic
         );
    end component;

    signal C : std_logic_vector(32 downto 0);
    signal X : std_logic_vector(31 downto 0); -- toggle bits to determine
                                              -- subtraction or not
begin
    C(0) <= Cin;

    -- -- add or subtract depends on the carry in, C_in in the following way:
    -- -- B_i xor C_in  = X_i why? because A - B = A + (~B + 1). If you have a carry in,
    -- -- C_in = 1 complement B_i i.e X_i = ~B and adding will be the same as
    -- -- subtracting. 
    -- -- subtracting logic
    toggle : for i in 0 to 31 generate
    X(i) <= Cin xor B(i);
    end generate;

    FA : for i in 0 to 31 generate
        FA_i : fullAdder port map(C(i), A(i), X(i), S(i), C(i+1));
    end generate FA;

    V <= C(32) xor C(31);

end struct;
