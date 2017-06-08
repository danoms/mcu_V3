library ieee;
use ieee.std_logic_1164.all,
		ieee.numeric_std.all;

entity regU is
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
      if rst then q <= (others => '0');
      elsif rising_edge(clk) then
         if en = '1' then
            q  <= D;
         else
            q  <= q;
         end if;
      end if;
   end process;
end architecture;
