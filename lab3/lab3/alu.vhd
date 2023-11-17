library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
-- Implement: AND, OR, ADD (signed), SUBTRACT (signed)
-- as described in Section 4.4 in the textbook.
-- The functionality of each instruction can be found on the 'ARM Reference Data' sheet at the
--    front of the textbook (or the Green Card pdf on Canvas).
port(
     in0       : in     STD_LOGIC_VECTOR(63 downto 0);
     in1       : in     STD_LOGIC_VECTOR(63 downto 0);
     operation : in     STD_LOGIC_VECTOR(3 downto 0);
     result    : buffer STD_LOGIC_VECTOR(63 downto 0);
     zero      : buffer STD_LOGIC;
     overflow  : buffer STD_LOGIC
    );
end ALU;



architecture structural of ALU is
  signal OnesComplement : STD_LOGIC_VECTOR(63 downto 0);
  signal tempResult : STD_LOGIC_VECTOR(63 downto 0);
  signal addResult : STD_LOGIC_VECTOR(63 downto 0);
  signal subResult : STD_LOGIC_VECTOR(63 downto 0);
  component ADD is
    port(
     in0    : in  STD_LOGIC_VECTOR(63 downto 0);
     in1    : in  STD_LOGIC_VECTOR(63 downto 0);
     output : out STD_LOGIC_VECTOR(63 downto 0)
    );
  end component;

    begin

        OnesComplement <= not in1;
        TwoComplement: ADD port map(
          in0 => OnesComplement,
          in1 => 64b"1",
          output => tempResult 
        );
        adding: ADD port map(
          in0 => in0,
          in1 => in1,
          output => addResult
        );
        subtracting: ADD port map(
          in0 => in0,
          in1 => tempResult,
          output => subResult
        );  

        zero <= '1' when (result = 64b"0") else
                '0';

        overflow <= (in0(63) and in1(63) and not addResult(63)) or (not in0(63) and not in1(63) and addResult(63)) when operation = "0010" else
                    (in0(63) and not in1(63) and not subResult(63)) or (not in0(63) and in1(63) and subResult(63)) when operation = "0110" else
                    '0';
    
        result <= (in0 AND in1) when (operation = "0000") else
            (in0 OR in1) when (operation = "0001") else
            (addResult) when (operation = "0010") else 
            (subResult) when (operation = "0110") else
            (in1) when (operation = "0111") else 
            (in0 NOR in1) when (operation = "1100");

end structural;

