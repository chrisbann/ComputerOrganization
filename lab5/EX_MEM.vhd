library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity EX_MEM is 
  port(
      --Inputs
      clk                     : in std_logic;
      rst                     : in std_logic;
      ex_mem_regwrite_in  :  std_logic;
      ex_mem_memtoreg_in  :  std_logic;
      ex_mem_ubranch_in   :  std_logic;
      ex_mem_branch_in    :  std_logic;
      ex_mem_memread_in   :  std_logic;
      ex_mem_memwrite_in  :  std_logic;
      ex_mem_add2_in      :  std_logic_vector(63 downto 0);
      ex_mem_zero_in      :  std_logic;
      ex_mem_aluresult_in :  std_logic_vector(63 downto 0);
      ex_mem_rd2_in :  std_logic_vector(63 downto 0);
      ex_mem_Rd_in        :  std_logic_vector(4 downto 0);
      --Outputs
      EX_MEM_regWrite_out      : out std_logic;
      EX_MEM_memToReg_out      : out std_logic;
      EX_MEM_UBranch_out       : out std_logic;
      EX_MEM_Branch_out        : out std_logic;
      EX_MEM_memRead_out       : out std_logic;
      EX_MEM_memWrite_out      : out std_logic;
      EX_MEM_add2_out          : out std_logic_vector(63 downto 0);
      EX_MEM_zero_out          : out std_logic;
      EX_MEM_ALUResult_out     : out std_logic_vector(63 downto 0);
      EX_MEM_rd2_out           : out std_logic_vector(63 downto 0);
      EX_MEM_Rd_out            : out std_logic_vector(4 downto 0)

  );
end EX_MEM;


architecture dataflow of EX_MEM is 
  signal ex_mem_reg    : std_logic_vector(203 downto 0);
  begin
    process (clk, rst) is
    begin
      --Case Reset is hit
      if rst = '1' then
        EX_MEM_regWrite_out      <= '0';   
        EX_MEM_memToReg_out      <= '0';     
        EX_MEM_UBranch_out       <= '0';   
        EX_MEM_Branch_out        <= '0';     
        EX_MEM_memRead_out       <= '0';   
        EX_MEM_memWrite_out      <= '0';     
        EX_MEM_add2_out          <= (others => '0');           
        EX_MEM_zero_out          <= '0';    
        EX_MEM_ALUResult_out     <= (others => '0');          
        EX_MEM_rd2_out           <= (others => '0');       
        EX_MEM_Rd_out            <= (others => '0');       

      --On rising edge, assign intermediate value to out
      elsif rising_edge(clk) then
        EX_MEM_regWrite_out     <= ex_mem_reg(203);          
        EX_MEM_memToReg_out     <= ex_mem_reg(202);          
        EX_MEM_UBranch_out      <= ex_mem_reg(201);         
        EX_MEM_Branch_out       <= ex_mem_reg(200);          
        EX_MEM_memRead_out      <= ex_mem_reg(199);         
        EX_MEM_memWrite_out     <= ex_mem_reg(198);          
        EX_MEM_add2_out         <= ex_mem_reg(197 downto 134);          
        EX_MEM_zero_out         <= ex_mem_reg(133);          
        EX_MEM_ALUResult_out    <= ex_mem_reg(132 downto 69);         
        EX_MEM_rd2_out          <= ex_mem_reg(68 downto 5);         
        EX_MEM_Rd_out           <= ex_mem_reg(4 downto 0);  
      end if;
    end process;
    
    --If not rising clk, store "in" as temp in reg
    ex_mem_reg(203)             <=    EX_MEM_regWrite_in;       
    ex_mem_reg(202)             <=    EX_MEM_memToReg_in;       
    ex_mem_reg(201)             <=    EX_MEM_UBranch_in;       
    ex_mem_reg(200)             <=    EX_MEM_Branch_in;         
    ex_mem_reg(199)             <=    EX_MEM_memRead_in;       
    ex_mem_reg(198)             <=    EX_MEM_memWrite_in;       
    ex_mem_reg(197 downto 134)  <=    EX_MEM_add2_in;                   
    ex_mem_reg(133)             <=    EX_MEM_zero_in;            
    ex_mem_reg(132 downto 69)   <=    EX_MEM_ALUResult_in;       
    ex_mem_reg(68 downto 5)     <=    EX_MEM_rd2_in;     
    ex_mem_reg(4 downto 0)      <=    EX_MEM_Rd_in; 
   
  end dataflow;