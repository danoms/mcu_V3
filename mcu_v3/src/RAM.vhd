library ieee, my_lib;
use 	ieee.std_logic_1164.all,
		ieee.numeric_std.all,
		my_lib.types.all;

entity RAM is
	port(	clk 	: in std_logic;
			rst 	: in std_logic;
			en 	: in std_logic;

			data_i 	: in unsigned(15 downto 0);
			data_o 	: out unsigned(15 downto 0);
			we 	 	: in std_logic;
			addr 		: in unsigned(15 downto 0));
end entity;

architecture rtl of RAM is
	subtype word_t is unsigned(15 downto 0);
	type mem_t is array(0 to 255) of word_t;
	
	signal mem : mem_t := (others => (others => '0'));
								
	signal addr_reg : unsigned(15 downto 0);
begin
	process(all)
	begin
		if rst then mem <= (others => (others => '0'));
		elsif rising_edge(clk) then
			if we then
				mem(to_integer(addr)) 	<= data_i;
			end if;
			addr_reg 	<= addr;
		end if;
	end process;
	
	data_o 	<= mem(to_integer(addr_reg));
end architecture;
