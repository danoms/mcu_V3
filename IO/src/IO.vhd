library ieee;
use 	ieee.std_logic_1164.all,
		ieee.numeric_std.all;

entity IO is
	port(	clk 	: in std_logic;

			data_i 	: in unsigned(15 downto 0);
			data_o 	: out unsigned(15 downto 0);
			we 	 	: in std_logic;
			addr 		: in unsigned(15 downto 0);

--			pins_i	: in std_logic_vector(7 downto 0);
--			pins_o	: out std_logic_vector(7 downto 0);

			PINB_i	: in unsigned(7 downto 0);
			DDRB_o 	: out unsigned(7 downto 0);
			PORTB_o 	: out unsigned(7 downto 0));
end entity;

architecture rtl of IO is
	subtype word_t is unsigned(7 downto 0);
	type mem_t is array(0 to 63) of word_t;



	constant PINBa 	: integer := 22; 	-- 22
	constant DDRBa 	: integer := 23;	-- 23
	constant PORTBa 	: integer := 24;	-- 24

	signal IO : mem_t := (
									-- DDRBa => x"0F", 	-- 0000 1111
									-- PORTBa => x"09",	-- 0000 0011
									others => (others => '0'));

	alias PINB 	: unsigned(7 downto 0) is IO(PINBa);
	alias DDRB 	: unsigned(7 downto 0) is IO(DDRBa);
	alias PORTB : unsigned(7 downto 0) is IO(PORTBa);

	signal addr_reg : unsigned(15 downto 0) := (others => '0');
begin
	process(clk)
	begin
		if rising_edge(clk) then
		PINB 							<= PINB_i;
			if we then
				IO(to_integer(addr)) 	<= data_i(7 downto 0);
			end if;
			addr_reg	<= addr;
		end if;
	end process;

	--IO control
--	pin_ctrl:
--		for i in 0 to 7 generate
--			pins_o(i) 	<= PORTB(i) when DDRB(i) else 'Z';
--		end generate;

	-- output
	data_o 	<= x"00" & IO(to_integer(addr_reg));
	DDRB_o	<= DDRB;
	PORTB_o 	<= PORTB;

end architecture;
