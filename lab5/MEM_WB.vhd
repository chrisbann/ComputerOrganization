library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity MEM_WB is 
  port(
      --Inputs
      clk                     : in std_logic;
      rst                     : in std_logic;
      MEM_WB_regWrite_in      : in std_logic;
      MEM_WB_memToReg_in      : in std_logic;
      MEM_WB_DMEM_rd_in       : in std_logic_vector(63 downto 0);  
      MEM_WB_ALUResult_in     : in std_logic_vector(63 downto 0);
      MEM_WB_Rd_in            : in std_logic_vector(4 downto 0);
      --Outputs
      MEM_WB_regWrite_out      : out std_logic;
      MEM_WB_memToReg_out      : out std_logic;
      MEM_WB_DMEM_rd_out       : out std_logic_vector(63 downto 0);  
      MEM_WB_ALUResult_out     : out std_logic_vector(63 downto 0);
      MEM_WB_Rd_out            : out std_logic_vector(4 downto 0)

  );
end MEM_WB;


architecture dataflow of MEM_WB is 
  signal MEM_WB_reg    : std_logic_vector(134 downto 0);
  begin
    process (clk, rst) is
    begin
      --Case Reset is hit
      if rst = '1' then
        MEM_WB_regWrite_out     <= '0';   
        MEM_WB_memToReg_out     <= '0';     
        MEM_WB_DMEM_rd_out      <= (others => '0');   
        MEM_WB_ALUResult_out    <= (others => '0');     
        MEM_WB_Rd_out           <= (others => '0');        

      --On rising edge, assign intermediate value to out
      elsif rising_edge(clk) then
        MEM_WB_regWrite_out     <= MEM_WB_reg(134);          
        MEM_WB_memToReg_out     <= MEM_WB_reg(133);          
        MEM_WB_DMEM_rd_out      <= MEM_WB_reg(132 downto 69);         
        MEM_WB_ALUResult_out    <= MEM_WB_reg(68 downto 5);          
        MEM_WB_Rd_out           <= MEM_WB_reg(4 downto 0);         

      end if;
    end process;
    
    --If not rising clk, store "in" as temp in reg
    MEM_WB_reg(134 downto 133)   <=    MEM_WB_regWrite_in & MEM_WB_memToReg_in;       
    MEM_WB_reg(132 downto 69)    <=    MEM_WB_DMEM_rd_in;       
    MEM_WB_reg(68 downto 5)      <=    MEM_WB_ALUResult_in;         
    MEM_WB_reg(4 downto 0)       <=    MEM_WB_Rd_in;       
   
  end dataflow;