library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity muxCPU is
port(
    
     sel         : in STD_LOGIC;

     CBranch_in  : in STD_LOGIC;  --conditional
     MemRead_in  : in STD_LOGIC;
     MemtoReg_in : in STD_LOGIC;
     MemWrite_in : in STD_LOGIC;
     ALUSrc_in   : in STD_LOGIC;
     RegWrite_in : in STD_LOGIC;
     UBranch_in  : in STD_LOGIC; -- This is unconditional 
     ALUOp_in    : in STD_LOGIC_VECTOR(1 downto 0);
     
     CBranch_out  : out STD_LOGIC;  --conditional
     MemRead_out  : out STD_LOGIC;
     MemtoReg_out : out STD_LOGIC;
     MemWrite_out : out STD_LOGIC;
     ALUSrc_out   : out STD_LOGIC;
     RegWrite_out : out STD_LOGIC;
     UBranch_out  : out STD_LOGIC; -- This is unconditional 
     ALUOp_out    : out STD_LOGIC_VECTOR(1 downto 0)
);
end muxCPU;

architecture dataflow of muxCPU is
  begin 
  process(all)
    begin 
    if (sel = '1') then 
        CBranch_out   <=  CBranch_in;      
        MemRead_out   <=  MemRead_in;    
        MemtoReg_out  <=  MemtoReg_in;    
        MemWrite_out  <=  MemWrite_in;    
        ALUSrc_out    <=  ALUSrc_in;     
        RegWrite_out  <=  RegWrite_in;    
        UBranch_out   <=  UBranch_in;      
        ALUOp_out     <=  ALUOp_in;    
    else 
        CBranch_out   <= '0'; 
        MemRead_out   <= '0'; 
        MemtoReg_out  <= '0';  
        MemWrite_out  <= '0';  
        ALUSrc_out    <= '0';
        RegWrite_out  <= '0';  
        UBranch_out   <= '0'; 
        ALUOp_out     <= "00";
    end if;
  end process;
 end dataflow;