library ieee;
use ieee.std_logic_1164.all,
		ieee.numeric_std.all;

entity adder is
   port( a_i   : in unsigned(15 downto 0);
         b_i   : in unsigned(15 downto 0);
         rez   : out unsigned(15 downto 0));
end entity;

architecture rtl of adder is
begin
   rez <= a_i + b_i;
end architecture;
