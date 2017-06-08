library ieee;
use 	ieee.std_logic_1164.all,
		ieee.numeric_std.all;

entity mux2 is
   port( d0    : in unsigned(15 downto 0);
         d1    : in unsigned(15 downto 0);
         s     : in std_logic;
         y     : out unsigned(15 downto 0));
end entity;

architecture rtl of mux2 is
begin
--   y  <= d0 when s = '0' else d1; 
with s select
	y 	<= d0 when '0',
			d1 when others;
end architecture;
