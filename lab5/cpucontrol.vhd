library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity CPUControl is
-- Functionality should match the truth table shown in Figure 4.22 of the textbook, inlcuding the
--    output 'X' values.
-- The truth table in Figure 4.22 omits the unconditional branch instruction:
--    UBranch = '1'
--    MemWrite = RegWrite = '0'
--    all other outputs = 'X'	
port(Opcode   : in  STD_LOGIC_VECTOR(10 downto 0);
     Reg2Loc  : out STD_LOGIC;
     CBranch  : out STD_LOGIC;  --conditional
     MemRead  : out STD_LOGIC;
     MemtoReg : out STD_LOGIC;
     MemWrite : out STD_LOGIC;
     ALUSrc   : out STD_LOGIC;
     RegWrite : out STD_LOGIC;
     UBranch  : out STD_LOGIC; -- This is unconditional 
     ALUOp    : out STD_LOGIC_VECTOR(1 downto 0)
);
end CPUControl;

architecture dataflow of CPUControl is
     begin 
     process (Opcode)
          -- ADD
          begin if (Opcode = "10001011000") then
               Reg2Loc  <= '0';
               CBranch  <= '0';
               MemRead  <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc   <= '0';
               RegWrite <= '1';
               UBranch  <= '0';
               ALUOp(1) <= '1';
               ALUOp(0) <= '0';

          -- SUB
          elsif (Opcode = "11001011000") then
               Reg2Loc  <= '0';
               CBranch  <= '0';
               MemRead  <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc   <= '0';
               RegWrite <= '1';
               UBranch  <= '0';
               ALUOp(1) <= '1';
               ALUOp(0) <= '0';

          -- ADDI
          elsif (Opcode(10 downto 1) = "1001000100") then
               Reg2Loc  <= '0';
               CBranch  <= '0';
               MemRead  <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc   <= '1';
               RegWrite <= '1';
               UBranch  <= '0';
               ALUOp(1) <= '1';
               ALUOp(0) <= '0';
          
          -- SUBI
          elsif (Opcode(10 downto 1) = "1101000100") then
               Reg2Loc  <= '0';
               CBranch  <= '0';
               MemRead  <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc   <= '1';
               RegWrite <= '1';
               UBranch  <= '0';
               ALUOp(1) <= '1';
               ALUOp(0) <= '0';
               
          -- ORR
          elsif (Opcode = "10101010000") then
               Reg2Loc  <= '0';
               CBranch  <= '1';
               MemRead  <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc   <= '0';
               RegWrite <= '1';
               UBranch  <= '0';
               ALUOp(1) <= '1';
               ALUOp(0) <= '0';
          
               -- ORRI
          elsif (Opcode(10 downto 1) = "1011001000") then
               Reg2Loc  <= '0';
               CBranch  <= '0';
               MemRead  <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc   <= '1';
               RegWrite <= '1';
               UBranch  <= '0';
               ALUOp(1) <= '1';
               ALUOp(0) <= '0';

          -- LDUR
          elsif (Opcode = "11111000010") then
               Reg2Loc  <= '0';
               CBranch  <= '0';
               MemRead  <= '1';
               MemtoReg <= '1';
               MemWrite <= '0';
               ALUSrc   <= '1';
               RegWrite <= '1';
               UBranch  <= '0';
               ALUOp(1) <= '0';
               ALUOp(0) <= '0';
          
          -- STUR
          elsif (Opcode = "11111000000") then
               Reg2Loc  <= '1';
               CBranch  <= '0';
               MemRead  <= '0';
               MemtoReg <= '0';
               MemWrite <= '1';
               ALUSrc   <= '1';
               RegWrite <= '0';
               UBranch  <= '0';
               ALUOp(1) <= '0';
               ALUOp(0) <= '0';
          
          -- CBZ
          elsif (Opcode(10 downto 3) = "10110100") then
               Reg2Loc  <= '1';
               CBranch  <= '1';
               MemRead  <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc   <= '0';
               RegWrite <= '0';
               UBranch  <= '0';
               ALUOp(1) <= '0';
               ALUOp(0) <= '1';

          -- CBNZ
          elsif (Opcode(10 downto 3) = "10110101") then
               Reg2Loc  <= '1';
               CBranch  <= '1';
               MemRead  <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc   <= '0';
               RegWrite <= '0';
               UBranch  <= '0';
               ALUOp(1) <= '0';
               ALUOp(0) <= '1';

          -- B
          elsif (Opcode(10 downto 5) = "000101") then
               Reg2Loc  <= '0';
               CBranch  <= '0';
               MemRead  <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc   <= '1';
               RegWrite <= '0';
               UBranch  <= '1';
               ALUOp(1) <= '0';
               ALUOp(0) <= '0';

          -- LSL
          elsif Opcode = "11010011011" then
               Reg2Loc  <= '0';
               CBranch  <= '0';
               MemRead  <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc   <= '1';
               RegWrite <= '1';
               UBranch  <= '0';
               ALUOp(1) <= '0';
               ALUOP(0) <= '1';

          -- LSR
          elsif Opcode = "11010011010" then
               Reg2Loc  <= '0';
               CBranch  <= '0';
               MemRead  <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc   <= '1';
               RegWrite <= '1';
               UBranch  <= '0';
               ALUOp(1) <= '0';
               ALUOP(0) <= '1';

          -- NOP
          elsif Opcode = "00000000000" then
               Reg2Loc  <= '0';
               CBranch  <= '0';
               MemRead  <= '0';
               MemtoReg <= '0';
               MemWrite <= '0';
               ALUSrc   <= '0';
               RegWrite <= '0';
               UBranch  <= '0';
               ALUOp(1) <= '0';
               ALUOP(0) <= '0';

          -- Nothing
          else
               Reg2Loc  <= 'U';
               CBranch  <= 'U';
               MemRead  <= 'U';
               MemtoReg <= 'U';
               MemWrite <= 'U';
               ALUSrc   <= 'U';
               RegWrite <= 'U';
               UBranch  <= 'U';
               ALUOp    <= "UU";
          end if;
     end process;
 end dataflow;
