library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity ID_EX is 
  port(
      --Inputs
      clk                    : in std_logic;
      rst                    : in std_logic;
      ID_EX_regWrite_in      : in std_logic;
      ID_EX_memToReg_in      : in std_logic;
      ID_EX_UBranch_in       : in std_logic;
      ID_EX_Branch_in        : in std_logic;
      ID_EX_memRead_in       : in std_logic;
      ID_EX_memWrite_in      : in std_logic;
      ID_EX_ALUOp_in         : in std_logic_vector(1 downto 0);
      ID_EX_ALUSrc_in        : in std_logic;
      ID_EX_pc_in            : in std_logic_vector(63 downto 0);
      ID_EX_rd1_in           : in std_logic_vector(63 downto 0);
      ID_EX_rd2_in           : in std_logic_vector(63 downto 0);
      ID_EX_se_in            : in std_logic_vector(63 downto 0);
      ID_EX_opcode_in        : in std_logic_vector(10 downto 0);
      ID_EX_RegisterRn_in    : in std_logic_vector(4 downto 0);
      ID_EX_RegisterRm_in    : in std_logic_vector(4 downto 0);
      ID_EX_RegisterRd_in    : in std_logic_vector(4 downto 0);
      --Outputs
      ID_EX_regWrite_out     : out std_logic;
      ID_EX_memToReg_out     : out std_logic;
      ID_EX_UBranch_out      : out std_logic;
      ID_EX_Branch_out       : out std_logic;
      ID_EX_memRead_out      : out std_logic;
      ID_EX_memWrite_out     : out std_logic;
      ID_EX_ALUOp_out        : out std_logic_vector(1 downto 0);
      ID_EX_ALUSrc_out       : out std_logic;
      ID_EX_pc_out           : out std_logic_vector(63 downto 0);
      ID_EX_rd1_out          : out std_logic_vector(63 downto 0);
      ID_EX_rd2_out          : out std_logic_vector(63 downto 0);
      ID_EX_se_out           : out std_logic_vector(63 downto 0);
      ID_EX_opcode_out       : out std_logic_vector(10 downto 0);
      ID_EX_RegisterRn_out   : out std_logic_vector(4 downto 0);
      ID_EX_RegisterRm_out   : out std_logic_vector(4 downto 0);
      ID_EX_RegisterRd_out   : out std_logic_vector(4 downto 0)
  );
end ID_EX;


architecture dataflow of ID_EX is 
  signal id_ex_reg    : std_logic_vector(290 downto 0);
  begin
    process (clk, rst) is
    begin
      --Case Reset is hit
      if rst = '1' then
        ID_EX_regWrite_out     <= '0';
        ID_EX_memToReg_out     <= '0';
        ID_EX_UBranch_out      <= '0';
        ID_EX_Branch_out       <= '0';
        ID_EX_memRead_out      <= '0';
        ID_EX_memWrite_out     <= '0';
        ID_EX_ALUOp_out        <= (others => '0');
        ID_EX_ALUSrc_out       <= '0';
        ID_EX_pc_out           <= (others => '0');
        ID_EX_rd1_out          <= (others => '0');
        ID_EX_rd2_out          <= (others => '0');
        ID_EX_se_out           <= (others => '0');
        ID_EX_opcode_out       <= (others => '0');
        ID_EX_RegisterRn_out   <= (others => '0');
        ID_EX_RegisterRm_out   <= (others => '0');
        ID_EX_RegisterRd_out   <= (others => '0');

      --On rising edge, assign intermediate value to out
      elsif rising_edge(clk) then
        ID_EX_regWrite_out      <= id_ex_reg(290);
        ID_EX_memToReg_out      <= id_ex_reg(289);
        ID_EX_UBranch_out       <= id_ex_reg(288);
        ID_EX_Branch_out        <= id_ex_reg(287);
        ID_EX_memRead_out       <= id_ex_reg(286);
        ID_EX_memWrite_out      <= id_ex_reg(285);
        ID_EX_ALUOp_out         <= id_ex_reg(284 downto 283);
        ID_EX_ALUSrc_out        <= id_ex_reg(282);
        ID_EX_pc_out            <= id_ex_reg(281 downto 218);
        ID_EX_rd1_out           <= id_ex_reg(217 downto 154);
        ID_EX_rd2_out           <= id_ex_reg(153 downto 90);
        ID_EX_se_out            <= id_ex_reg(89 downto 26);
        ID_EX_opcode_out        <= id_ex_reg(25 downto 15);
        ID_EX_RegisterRn_out    <= id_ex_reg(14 downto 10);
        ID_EX_RegisterRm_out    <= id_ex_reg(9 downto 5);
        ID_EX_RegisterRd_out    <= id_ex_reg(4 downto 0);
      end if;
    end process;
    
    --If not rising clk, store "in" as temp in reg
    id_ex_reg(290) <= ID_EX_regWrite_in;
    id_ex_reg(289) <= ID_EX_memtoReg_in;
    id_ex_reg(288) <= ID_EX_UBranch_in;
    id_ex_reg(287) <= ID_EX_Branch_in;
    id_ex_reg(286) <= ID_EX_memRead_in;
    id_ex_reg(285) <= ID_EX_memWrite_in;
    id_ex_reg(284 downto 283) <= ID_EX_ALUOp_in;
    id_ex_reg(282) <= ID_EX_ALUSrc_in;
    id_ex_reg(281 downto 218) <= ID_EX_pc_in;
    id_ex_reg(217 downto 154) <= ID_EX_rd1_in;
    id_ex_reg(153 downto 90) <= ID_EX_rd2_in;
    id_ex_reg(89 downto 26) <= ID_EX_se_in;
    id_ex_reg(25 downto 15) <= ID_EX_opcode_in;
    id_ex_reg(14 downto 10) <= ID_EX_RegisterRn_in;
    id_ex_reg(9 downto 5) <= ID_EX_RegisterRm_in;
    id_ex_reg(4 downto 0) <= ID_EX_RegisterRd_in;
  
  end dataflow;