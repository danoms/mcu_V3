library ieee, my_lib;
use 	ieee.std_logic_1164.all,
		ieee.numeric_std.all;

entity mcu_V3_tb is
	generic( MAIN_CLK_PERIOD : time := 10ns);
end entity;

architecture testy of mcu_V3_tb is

component mcu_v3
port (
  clk  : in  std_logic;
  rst  : in  std_logic;
  pins : inout std_logic_vector(3 downto 0)
);
end component mcu_v3;

signal clk  : std_logic	:= '0';
signal rst  : std_logic := '0';
signal pins : std_logic_vector(3 downto 0) := (others => '0');

begin

clk <= not clk after MAIN_CLK_PERIOD/2;

init : process
begin
	rst <= '1';
	wait for 3*MAIN_CLK_PERIOD;
	rst <= '0';
	wait;
end process;
mcu_v3_i : mcu_v3
port map (
  clk  => clk,
  rst  => rst,
  pins => pins
);

end architecture;
