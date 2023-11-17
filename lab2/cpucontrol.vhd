entity CPUControl is
-- Functionality should match the truth table shown in Figure 4.22 of the textbook, inlcuding the
--    output 'X' values.
-- The truth table in Figure 4.22 omits the unconditional branch instruction:
--    UBranch = '1'
--    MemWrite = RegWrite = '0'
--    all other outputs = 'X'	
port(Opcode   : in  STD_LOGIC_VECTOR(10 downto 0);
     Reg2Loc   : out STD_LOGIC;
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
     signal OutCode = STD_LOGIC_VECTOR(2 downto 0);
     begin
          -- If OpCode is R-Format
          OutCode <= ("000") when (Opcode(10) = '1' AND Opcode(7 downto 4) = "0101"
          AND Opcode(2 downto 0) = "000") else 
          -- If OpCode is LDUR
          ("001") when (Opcode(10 downto 0) = "11111000010") else 
          -- If OpCode is STUR
          ("010") when (Opcode(10 downto 0) = "11111000000") else 
          -- If Opcode is CBZ
          ("011") when (Opcode(10 downto 3) = "10110100") else 
          -- If Opcode is Unconditional 
          ("100") when (Opcode(10 downto 5) = "000101") else
          -- If Opcode is ADDI 
          ("101") when (Opcode(10 downto 1) = "1001000100");

          Reg2Loc <= ('0') when (OutCode = "000" OR OutCode = "001" OR Outcode = "100" OR Outcode = "101") else
                     ('1') when (OutCode = "010" OR OutCode = "011");
          CBranch <= ('0') when (OutCode = "000" OR OutCode = "001" OR OutCode = "010" OR Outcode = "100" OR Outcode = "101") else 
                     ('1') when (OutCode = "011");
          MemRead <= ('0') when (OutCode = "000" OR OutCode = "010" OR OutCode = "011" OR Outcode = "100" OR Outcode = "101") else 
                     ('1') when (OutCode = "001");
          MemtoReg <= ('0') when (OutCode = "000" OR OutCode = "010" OR OutCode = "011" OR Outcode = "100" OR Outcode = "101") else 
                     ('1') when (OutCode = "001");
          MemWrite <= ('0') when (OutCode = "000" OR OutCode = "001" OR OutCode = "011" OR Outcode = "100" OR Outcode = "101") else 
                     ('1') when (OutCode = "010");
          ALUSrc <= ('0') when (OutCode = "000" OR OutCode = "011" OR Outcode = "100" ) else 
                    ('1') when (OutCode = "001" OR OutCode = "010" OR Outcode = "101");
          RegWrite <= ('0') when (OutCode = "010" OR OutCode = "011" OR Outcode = "100") else
                      ('1') when (OutCode = "000" OR OutCode = "001" OR Outcode = "101");
          UBranch <= ('0') when (OutCode = "000" OR OutCode = "001" OR OutCode = "010" OR Outcode = "101" OR OutCode = "011") else 
                     ('1') when (OutCode = "100");
          ALUOp(1) <= ('0') when (OutCode = "001" OR OutCode = "010" OR OutCode = "011" OR Outcode = "100") else 
                     ('1') when (OutCode = "000" OR Outcode = "101");
          ALUOp(0) <= ('0') when (OutCode = "000" OR OutCode = "001" OR OutCode = "010" OR Outcode = "100" OR Outcode = "101") else 
                     ('1') when (OutCode = "011");


 end dataflow;
