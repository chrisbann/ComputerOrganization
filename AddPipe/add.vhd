library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ADD is
    -- Adds two signed 32-bit inputs
    -- output = in1 + in2
    port(
         in0    : in  STD_LOGIC_VECTOR(63 downto 0);
         in1    : in  STD_LOGIC_VECTOR(63 downto 0);
         clk    : in STD_LOGIC;
         rst    : in STD_LOGIC;
         output : out STD_LOGIC_VECTOR(63 downto 0)
    );

end ADD;

architecture behavioral of ADD is
    component add32 is
        port (
            Cin         : in std_logic;
            A, B        : in std_logic_vector(31 downto 0);
            S           : out std_logic_vector(31 downto 0);
            V           : out std_logic
            );
    end component;
    
    signal Cin : std_logic := '0';
    signal Cout : std_logic := '0';
    signal V   : std_logic := '0';
    signal inter : STD_LOGIC_VECTOR(31 downto 0);

    begin
     process (clk, rst) is
     begin
        in0 <= x"0" when (rst = '1');
        in1 <= x"0" when (rst = '1');
        output <= x"0" when (rst = '1');

        adder1 : add32 port map (Cin, in0(31 downto 0), in1 (31 downto 0), inter, V);

             -- Issue with first clk cycle where only [31:0] is added...
       if rising_edge(clk) then
          
          end if;

        adder2 : add32 port map (Cin, in0(63 downto 32), in1(63 downto 32), output(63 downto 32), V);
     

     end process;
   
end;
        

