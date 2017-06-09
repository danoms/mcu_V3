library ieee, my_lib;
use 	ieee.std_logic_1164.all,
		ieee.numeric_std.all,
		my_lib.types.all;

entity mcu_v3 is
	port(	clk 	: in std_logic;
			rst 	: in std_logic;

			pins 	: inout std_logic_vector(3 downto 0));
end entity;

architecture rtl of mcu_v3 is
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
				rst : in std_logic;

				PC	 	: in 	unsigned(15 downto 0);
				instr : out std_logic_vector(15 downto 0));
	end component;
	component RAM
		port(	clk 	: in std_logic;
				rst 	: in std_logic;
				en 	: in std_logic;

				data_i 	: in unsigned(15 downto 0);
				data_o 	: out unsigned(15 downto 0);
				we 	 	: in std_logic;
				addr 		: in unsigned(15 downto 0));
	end component;
	component IO
		port(	clk 	: in std_logic;
				rst 	: in std_logic;
				en 	: in std_logic;

				data_i 	: in unsigned(15 downto 0);
				data_o 	: out unsigned(15 downto 0);
				we 		: in std_logic;
				addr 		: in unsigned(15 downto 0));
	end component;
	signal PC  : unsigned(15 downto 0) := (others => '0');
	signal data_from_RAM, data_from_IO, data_from_CPU, data_to_CPU, addr	: unsigned(15 downto 0);
	signal ctl 		: ctl_t;
	signal instr 	: std_logic_vector(15 downto 0);
begin
--FLASH: instruction_memory port map(clk, rst, PC, instr);
FLASH: RAM_altera port map(std_logic_vector(PC(7 downto 0)), clk, x"0000", '0', instr  );
CPU_core: CPU port map(clk, rst, PC, instr, data_from_CPU, data_to_CPU, addr, ctl );
data_to_cpu_mux: mux2 port map(data_from_RAM, data_from_IO, ctl.en.IO, data_to_CPU);
RAM_core: RAM port map(clk, rst, ctl.en.RAM, data_from_CPU, data_from_RAM, ctl.we.RAM, addr);
IO_core: IO port map(clk, rst, ctl.en.IO, data_from_CPU, data_from_IO, ctl.we.IO, addr);
end architecture;
