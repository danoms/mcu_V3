library ieee, my_lib;
use 	ieee.std_logic_1164.all,
		ieee.numeric_std.all;

entity mcu_V3_tb is
	generic( MAIN_CLK_PERIOD 	: time := 20 ns; -- 50 MHz
				WAIT_TIME 			: time := 10 us);
end entity;

architecture testy of mcu_V3_tb is

component mcu_v3
port (
  clk  : in  std_logic;
  rst_i  : in  std_logic;
  PB 	: inout std_logic_vector(7 downto 0)
);
end component mcu_v3;

signal clk  : std_logic	:= '0';
signal rst  : std_logic := '0';
--signal pins : std_logic_vector(3 downto 0) := (others => '0');
signal PB : std_logic_vector(7 downto 0) 	:= (others => '0');
begin

clk <= not clk after MAIN_CLK_PERIOD/2;
upd_PB : process
begin
	PB(7 downto 4) 	<= x"0";
	wait for WAIT_TIME;
	PB(7 downto 4) 	<= x"1";
	wait for WAIT_TIME;
	PB(7 downto 4) 	<= x"2";
	wait for WAIT_TIME;
	PB(7 downto 4) 	<= x"3";
	wait for WAIT_TIME;
end process;
init : process
begin
	rst <= '0';
	wait for 3*MAIN_CLK_PERIOD;
	rst <= '1';
	wait for WAIT_TIME;
	rst <= '0';
	wait for 3*MAIN_CLK_PERIOD;
	rst <= '1';
	wait;
end process;
mcu_v3_i : mcu_v3
port map (
  clk  	=> clk,
  rst_i  	=> rst,
  PB 		=> PB
);

end architecture;
