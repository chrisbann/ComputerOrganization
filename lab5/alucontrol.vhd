library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;

entity ALUControl is
-- Functionality should match truth table shown in Figure 4.13 in the textbook.
-- Check table on page2 of ISA.pdf on canvas. Pay attention to opcode of operations and type of operations. 
-- If an operation doesn't use ALU, you don't need to check for its case in the ALU control implemenetation.	
--  To ensure proper functionality, you must implement the "don't-care" values in the funct field,
-- for example when ALUOp = '00", Operation must be "0010" regardless of what Funct is.
port(
     ALUOp     : in  STD_LOGIC_VECTOR(1 downto 0);
     Opcode    : in  STD_LOGIC_VECTOR(10 downto 0);
     Operation : out STD_LOGIC_VECTOR(3 downto 0)
    );
end ALUControl;

architecture dataflow of ALUControl is
    signal concat : std_logic_vector(12 downto 0);
	signal concat2 : std_logic_vector(11 downto 0);	

    begin
		Operation <= "0010" when ALUOp = "00" else

        -- R-type
        "0010" when Opcode = "10001011000"                    else -- ADD
        "0001" when ALUOp(1) = '1' and Opcode = "10101010000" else -- ORR
        "1000" when ALUOp(0) = '1' and Opcode = "11010011010" else -- LSR
        "0110" when ALUOp(1) = '1' and Opcode = "11001011000" else -- SUB
        "0000" when ALUOp(1) = '1' and Opcode = "10001010000" else -- AND
        "1001" when ALUOp(0) = '1' and Opcode = "11010011011" else -- LSR

        -- I-type
        "0010" when ALUOp(1) = '1' and Opcode(10 downto 1) = "1001000100" else -- ADDI
        "0110" when ALUOp(1) = '1' and Opcode(10 downto 1) = "1101000100" else -- SUBI

        -- B-type 
        "0111" when ALUOp(0) = '1' and Opcode(10 downto 3) = "10110100" else -- CBZ
        "1111" when ALUOp(0) = '1' and Opcode(10 downto 3) = "10110101" else -- CBNZ
        "UUUU";
end dataflow;