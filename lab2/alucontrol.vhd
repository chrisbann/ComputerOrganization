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
    begin
        Operation <= ("0010") when (ALUOp = "00") else 
        ("0111") when (ALUOp(0) = '1') else 
        ("0010") when (Opcode = "10001011000") else
        ("0110") when (ALUOp(1) = '1' AND Opcode = "11001011000") else 
        ("0000") when (ALUOp(1) = '1' AND Opcode = "10001010000") else
        ("0001") when (ALUOp(1) = '1' AND Opcode = "10101010000");
end dataflow;