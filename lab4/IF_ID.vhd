library IEEE;
use IEEE.STD_LOGIC_1164.ALL; -- STD_LOGIC and STD_LOGIC_VECTOR
use IEEE.numeric_std.ALL; -- to_integer and unsigned

entity IF_ID is 
  port(
      --Inputs
      clk             : in std_logic;
      rst             : in std_logic;
      IF_ID_pc_in     : in std_logic_vector(63 downto 0);
      IF_ID_addr_in   : in std_logic_vector(31 downto 0);
      --Outputs
      IF_ID_pc_out    : out std_logic_vector(63 downto 0);
      IF_ID_addr_out  : out std_logic_vector(31 downto 0)

  );
end IF_ID;


architecture dataflow of IF_ID is 
  signal if_id_reg    : std_logic_vector(95 downto 0);
  begin
    process (clk, rst)
    begin
      --Case Reset is hit
      if rst = '1' then
        IF_ID_pc_out   <= (others => '0');
        IF_ID_addr_out <= (others => '0');

      --On rising edge, assign intermediate value to out
      elsif rising_edge(clk) then
        IF_ID_pc_out    <= if_id_reg(95 downto 32);
        IF_ID_addr_out  <= if_id_reg(31 downto 0);
      end if;
    end process;
    
    --If not rising clk, store "in" as temp in reg
    if_id_reg(95 downto 32) <= IF_ID_pc_in;
    if_id_reg(31 downto 0)  <= IF_ID_addr_in;
  
  end dataflow;