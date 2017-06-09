library ieee, my_lib;
use 	ieee.std_logic_1164.all,
		ieee.numeric_std.all,
		my_lib.types.all;

entity instruction_memory is
	port(	clk : in std_logic;
			rst : in std_logic;

			PC	 	: in 	unsigned(15 downto 0);
			instr : out std_logic_vector(15 downto 0));
end entity;

architecture rtl of instruction_memory is
	subtype word_t is std_logic_vector(15 downto 0);
	type mem_t is array(0 to 255) of word_t;

	function init_func return mem_t is
		variable tmp : mem_t := (others => (others => '0'));
		constant filez : std_logic_vector := x"09C00EC00DC00CC00BC00AC009C008C0" &
											x"07C006C011241FBECFE9CDBF02D024C0" &
											x"EFCFCF93DF93CDB7DD27C650CDBF88EC" &
											x"90E09A83898381E990E09C838B831E82" &
											x"1D828D819E81892B31F08D819E810197" &
											x"9E838D83F6CF29813A818B819C81820F" &
											x"931F9E838D83EDCFF894FFCF";
	begin
		for i in 0 to filez'length/16-1 loop
--			tmp(i) 	:= filez((i+1)*8-1 downto (i*8));
			tmp(i) := filez( (i*2+1)*8 to 7+(i*2+1)*8) & filez( (i*2)*8 to 7+(i*2)*8);
		end loop;
		return tmp;
	end function;

	signal mem : mem_t := init_func;
								
	signal addr_reg : unsigned(15 downto 0);
begin
	process(all)
	begin
		if rising_edge(clk) then
			addr_reg 	<= PC;
		end if;
	end process;

	instr 	<= mem(to_integer(addr_reg));
end architecture;
