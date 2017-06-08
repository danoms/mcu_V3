library ieee;
use ieee.std_logic_1164.all,
		ieee.numeric_std.all;

entity regU is
	generic( limit : integer := 0);
   port( clk   : in std_logic;
         rst   : in std_logic;
         en    : in std_logic;
         D     : in unsigned(15 downto 0);
         q     : out unsigned(15 downto 0));
end entity;

architecture rtl of regU is
begin
   process(clk, rst)
   begin
      if rst then q <= to_unsigned(limit, 16);
      elsif rising_edge(clk) then
         if en = '1' then
            q  <= D;
         else
            q  <= q;
         end if;
      end if;
   end process;
end architecture;
