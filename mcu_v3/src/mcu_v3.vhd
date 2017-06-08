library ieee;
use ieee.std_logic_1164.all;

entity mcu_v3 is
	port(	clk 	: in std_logic;
			rst 	: in std_logic;

			pins 	: inout std_logic_vector(3 downto 0));
end entity;

architecture rtl of mcu_v3 is
	component CPU
		port(	clk 	: in std_logic;
				rst 	: in std_logic;

				PC 	: out unsigned(15 downto 0);
				instr	: in std_logic_vector(15 downto 0);

				data_o 	: out unsigned(15 downto 0);
				data_i 	: in 	unsigned(15 downto 0);
				addr_o 	: out unsigned(15 downto 0);
				we_RAM 	: out std_logic;
				we_IO 	: out std_logic;

				ctl_data 	: out std_logic); -- data_i <- RAM ? IO
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

				data_i 	: in unsigned(15 downto 0);
				data_o 	: out unsigned(15 downto 0);
				we 	 	: in std_logic;
				addr 		: in unsigned(15 downto 0));
	end component;
	component IO
		port(	clk 	: in std_logic;
				rst 	: in std_logic;

				data_i 	: in unsigned(15 downto 0);
				data_o 	: out unsigned(15 downto 0);
				we 		: in std_logic;
				addr 		: in unsigned(15 downto 0));
	end component;
begin

end architecture;
