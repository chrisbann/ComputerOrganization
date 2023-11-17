library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC is -- 32-bit rising-edge triggered register with write-enable and synchronous reset
-- For more information on what the PC does, see page 251 in the textbook
port(
     clk          : in  STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
     write_enable : in  STD_LOGIC; -- Only write if '1'
     rst          : in  STD_LOGIC; -- Asynchronous reset! Sets AddressOut to 0x0
     AddressIn    : in  STD_LOGIC_VECTOR(63 downto 0); -- Next PC address
     AddressOut   : out STD_LOGIC_VECTOR(63 downto 0) -- Current PC address
);
end PC;

architecture behavioral of PC is
     begin
       process (clk, rst) is
       begin
          AddressOut <= x"0000000000000000" when (rst = '1') else AddressIn;

         if rising_edge(clk) then
          AddressOut <= AddressIn when (write_enable = '1') else AddressOut;
         end if;
       end process;
     
     end;
