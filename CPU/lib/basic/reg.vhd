library ieee;
use ieee.std_logic_1164.all;

entity reg is
	generic( reg_width : integer);
   port( clk   : in std_logic;
         rst   : in std_logic;
         en    : in std_logic;
         D     : in std_logic_vector(reg_width-1 downto 0);
         q     : out std_logic_vector(reg_width-1 downto 0));
end entity;

architecture rtl of reg is
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
