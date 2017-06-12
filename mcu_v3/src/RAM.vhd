library ieee, my_lib;
use 	ieee.std_logic_1164.all,
		ieee.numeric_std.all,
		my_lib.types.all;

entity RAM is
	generic( DATA_WIDTH 	: integer := 16;
				DATA_SIZE 	: integer := 9);
	port(	clk 	: in std_logic;

			data_i 	: in unsigned(DATA_WIDTH-1 downto 0);
			data_o 	: out unsigned(DATA_WIDTH-1 downto 0);
			we 	 	: in std_logic;
			addr 		: in unsigned(15 downto 0));
end entity;

architecture rtl of RAM is
	subtype word_t is unsigned(DATA_WIDTH-1 downto 0);
	type mem_t is array(0 to 2**DATA_SIZE-1) of word_t;

	signal mem : mem_t := (others => (others => '0'));

	signal addr_reg : unsigned(DATA_WIDTH-1 downto 0);
begin
	process(all)
	begin
		if rising_edge(clk) then
			if we then
				mem(to_integer(addr)) 	<= data_i;
			end if;
			addr_reg 	<= addr;
		end if;
	end process;

	data_o 	<= mem(to_integer(addr_reg));
end architecture;
