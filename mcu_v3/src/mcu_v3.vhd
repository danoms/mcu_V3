library ieee, my_lib;
use 	ieee.std_logic_1164.all,
		ieee.numeric_std.all,
		my_lib.types.all;

entity mcu_v3 is
	port(	clk 	: in std_logic;
			rst_i 	: in std_logic;

			PB 	: inout std_logic_vector(7 downto 0));
end entity;

architecture rtl of mcu_v3 is
-- signal clk : std_logic := '0';
signal rst 	: std_logic := '0';
component RAM_altera IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END component;
	component mux2
		port( d0    : in unsigned(15 downto 0);
				d1    : in unsigned(15 downto 0);
				s     : in std_logic;
				y     : out unsigned(15 downto 0));
	end component;
	component CPU
		port(	clk 	: in std_logic;
				rst 	: in std_logic;

				PC_o 		: out unsigned(15 downto 0);
				instr_i	: in std_logic_vector(15 downto 0);

				data_o 	: out unsigned(15 downto 0);
				data_i 	: in 	unsigned(15 downto 0);
				addr_o 	: out unsigned(15 downto 0);
				ctl_o 	: out ctl_t
				); -- data_i <- RAM ? IO
	end component;
	component instruction_memory
		port(	clk : in std_logic;

				PC	 	: in 	unsigned(15 downto 0);
				instr : out std_logic_vector(15 downto 0));
	end component;
	component RAM
		generic( DATA_WIDTH 	: integer := 16;
					DATA_SIZE 	: integer := 9);
		port(	clk 	: in std_logic;

				data_i 	: in unsigned(15 downto 0);
				data_o 	: out unsigned(15 downto 0);
				we 	 	: in std_logic;
				addr 		: in unsigned(15 downto 0));
	end component;
	component IO
		port(	clk 	: in std_logic;

			data_i 	: in unsigned(15 downto 0);
			data_o 	: out unsigned(15 downto 0);
			we 	 	: in std_logic;
			addr 		: in unsigned(15 downto 0);

			PINB_i	: in unsigned(7 downto 0);
			DDRB_o 	: out unsigned(7 downto 0);
			PORTB_o 	: out unsigned(7 downto 0));
	end component;
	signal PC  : unsigned(15 downto 0) := (others => '0');
	signal data_from_RAM, data_from_IO, data_from_CPU, data_to_CPU, addr	: unsigned(15 downto 0);
	signal ctl 		: ctl_t;
	signal instr 	: std_logic_vector(15 downto 0);
	signal addr_RAM, addr_IO 	: unsigned(15 downto 0);
--	signal pins_i, pins_o : std_logic_vector(7 downto 0);
	signal PINB, DDRB, PORTB 	: unsigned(7 downto 0);

	-- signal clk_divider : unsigned(15 downto 0);
begin

-- process(clk_i)
-- begin
-- 	if rising_edge(clk_i) then
-- 		clk_divider 	<= clk_divider + 1;
-- 	end if;
-- end process;
--
-- clk 	<= clk_divider(6);

rst 	<=not(rst_i);

addr_RAM 		<= addr when ctl.en.RAM else (others => 'Z');
data_to_CPU 	<= data_from_RAM when ctl.en.RAM else (others => 'Z');
--data_to_CPU 	<= data_from_RAM when ctl.en.RAM else data_from_IO;
addr_IO 			<= addr when ctl.en.IO else (others => 'Z');
data_to_CPU 	<= data_from_IO when ctl.en.IO else (others => 'Z');

FLASH: instruction_memory port map(clk, PC, instr);
--FLASH: RAM_altera port map(std_logic_vector(PC(7 downto 0)), clk, x"0000", '0', instr  );
CPU_core: CPU port map(clk, rst, PC, instr, data_from_CPU, data_to_CPU, addr, ctl );
-- data_to_cpu_mux: mux2 port map(data_from_RAM, data_from_IO, ctl.en.IO, data_to_CPU);
RAM_core: RAM port map(clk, data_from_CPU, data_from_RAM, ctl.we.RAM, addr_RAM);
IO_core: IO port map(clk, data_from_CPU, data_from_IO, ctl.we.IO, addr_IO, PINB, DDRB, PORTB );

-- IO input control
pin_o_ctrl:
	for i in 0 to PB'length-1 generate
		PINB(i) 	<= PB(i) when DDRB(i) = '0' else '0';
	end generate;
	-- PINB(7 downto 6) 	<= "00";
--IO output control
	pin_ctrl:
		for i in 0 to PB'length-1 generate
			PB(i) 	<= PORTB(i) when DDRB(i) else 'Z';
		end generate;
end architecture;
