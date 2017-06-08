library ieee;
use 	ieee.std_logic_1164.all,
		ieee.numeric_std.all;

entity signext is
   port(	d 	: in unsigned(11 downto 0);
			q 	: out unsigned(15 downto 0));
end entity;

architecture rtl of signext is
begin
   q 	<= x"0" & d when d(11) = '0' else x"F" & d;
end architecture;
