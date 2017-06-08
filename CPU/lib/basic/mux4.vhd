library ieee;
use 	ieee.std_logic_1164.all,
		ieee.numeric_std.all;

entity mux4 is
   port( d0    : in unsigned(15 downto 0);
         d1    : in unsigned(15 downto 0);
			d2 	: in unsigned(15 downto 0);
			d3 	: in unsigned(15 downto 0);
         s     : in std_logic_vector(1 downto 0);
         y     : out unsigned(15 downto 0));
end entity;

architecture rtl of mux4 is
begin
	with s select 
		y 	<= d0 when "00",
				d1 when "01",
				d2 when "10",
				d3 when others;
	
end architecture;
