library ieee;
use IEEE.std_logic_1164.all;

entity fullAdder is

port(
    in0    : in  std_logic;
    in1    : in  std_logic;
    c_in    : in  std_logic;
    sum    : out std_logic;
    c_out   : out std_logic
);
end fullAdder;


architecture structural of fullAdder is
    begin
      c_out <= ('0') when (in0 = '0' AND in1 = '0' AND c_in = '0') else 
      ('0') when (in0 = '0' AND in1 = '0' AND c_in = '1') else 
      ('0') when (in0 = '0' AND in1 = '1' AND c_in = '0') else 
      ('1') when (in0 = '0' AND in1 = '1' AND c_in = '1') else 
      ('0') when (in0 = '1' AND in1 = '0' AND c_in = '0') else
      ('1') when (in0 = '1' AND in1 = '0' AND c_in = '1') else 
      ('1') when (in0 = '1' AND in1 = '1' AND c_in = '0') else
      ('1') when (in0 = '1' AND in1 = '1' AND c_in = '1');

      sum <= ('0') when (in0 = '0' AND in1 = '0' AND c_in = '0') else 
      ('1') when (in0 = '0' AND in1 = '0' AND c_in = '1') else 
      ('1') when (in0 = '0' AND in1 = '1' AND c_in = '0') else 
      ('0') when (in0 = '0' AND in1 = '1' AND c_in = '1') else 
      ('1') when (in0 = '1' AND in1 = '0' AND c_in = '0') else
      ('0') when (in0 = '1' AND in1 = '0' AND c_in = '1') else 
      ('0') when (in0 = '1' AND in1 = '1' AND c_in = '0') else
      ('1') when (in0 = '1' AND in1 = '1' AND c_in = '1');


end structural;
