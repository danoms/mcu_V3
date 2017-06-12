library ieee, my_lib;
use 	ieee.std_logic_1164.all,
		ieee.numeric_std.all,
		my_lib.types.all;

entity instruction_memory is
	port(	clk : in std_logic;

			PC	 	: in 	unsigned(15 downto 0);
			instr : out std_logic_vector(15 downto 0));
end entity;

architecture rtl of instruction_memory is
	subtype word_t is std_logic_vector(15 downto 0);
	type mem_t is array(0 to 255) of word_t;

	function init_func return mem_t is
		variable tmp : mem_t := (others => (others => '0'));
		constant filez : std_logic_vector := x"09C00EC00DC00CC00BC00AC009C008C0" &
											x"07C006C011241FBECFE9CDBF02D05BC0" &
											x"EFCFCF93DF93CDB7DD27CA50CDBF1E82" &
											x"1D8284E090E09A83898387E090E09C83" &
											x"8B832B813C8189819A81820F931F9A87" &
											x"898789859A859E838D8387B38F6087BB" &
											x"88B3836088BB78E064E052E041E02B81" &
											x"3C8189819A81820F931F98878F838F81" &
											x"98859E838D8386B3811107C048BB8981" &
											x"9A8101969A838983EACF86B3803139F4" &
											x"58BB8B819C8101969C838B83E0CF86B3" &
											x"803239F468BB89819A8101979A838983" &
											x"D6CF86B3803399F678BB8B819C810197" &
											x"9C838B83CCCFF894FFCF";
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
