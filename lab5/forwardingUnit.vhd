library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity forwardingUnit is
  port(
      EX_MEM_regWrite     : in std_logic;
      EX_MEM_RegisterRd   : in std_logic_vector(4 downto 0);
      ID_EX_RegisterRn1   : in std_logic_vector(4 downto 0);
      ID_EX_RegisterRm2   : in std_logic_vector(4 downto 0);
      MEM_WB_regWrite     : in std_logic;
      MEM_WB_RegisterRd   : in std_logic_vector(4 downto 0);
      ------------------------------------------------------
      forwardA            : out std_logic_vector(1 downto 0);
      forwardB            : out std_logic_vector(1 downto 0)
  );
end forwardingUnit;


architecture behavioral of forwardingUnit is 

begin

    process (all) 
    begin
        -- EX hazard 
        if ( EX_MEM_regWrite = '1' 
            and (EX_MEM_RegisterRd /= "11111") 
            and (EX_MEM_RegisterRd = ID_EX_registerRn1) ) then
            forwardA <= "10";
        -- MEM hazard
        elsif (MEM_WB_regWrite = '1' 
            and (MEM_WB_RegisterRd /= "11111") 
            and not (EX_MEM_regWrite = '1' and (EX_MEM_RegisterRd /= "1111") 
            and (EX_MEM_RegisterRd = ID_EX_registerRn1)) 
            and (MEM_WB_RegisterRd = ID_EX_RegisterRn1) ) then 
            forwardA <= "01";
        else
            forwardA <= "00";
        end if;

        if ( EX_MEM_regWrite = '1' 
            and (EX_MEM_RegisterRd /= "11111") 
            and (EX_MEM_RegisterRd = ID_EX_RegisterRm2) ) then
            forwardB <= "10";
        -- MEM hazard
        elsif (MEM_WB_regWrite = '1' 
                and (MEM_WB_RegisterRd /= "11111") 
                and not (EX_MEM_regWrite = '1' and (EX_MEM_RegisterRd /= "1111") 
                and (EX_MEM_RegisterRd = ID_EX_registerRm2)) 
                and (MEM_WB_RegisterRd = ID_EX_RegisterRm2) ) then 
                forwardB <= "01";
        else
            forwardB <= "00";
        end if;
    end process;
end behavioral;




