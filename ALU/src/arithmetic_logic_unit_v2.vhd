library ieee, my_lib;
use 	ieee.std_logic_1164.all,
	ieee.numeric_std.all,
		my_lib.types.all,
		my_lib.instruction_set.all;

entity arithmetic_logic_unit_v2 is
	port(
		a_i 		: in unsigned(15 downto 0);
		b_i		: in unsigned(15 downto 0);
		op_i		: in operation_type;

		result 	: out unsigned(15 downto 0);

		SREG_i	: in std_logic_vector(7 downto 0);
		SREG_o	: out std_logic_vector(7 downto 0));
end entity;

architecture avr of arithmetic_logic_unit_v2 is
--	(ldi, movw, sub, sbc, cpi, cpc, brlt, adiw, rjmp, sbiw, eor, outt, rcall)
begin

ALU_op_logic :	process(all)
	begin
		case op_i is
			when sub =>
				sub(a_i, b_i, SREG_i, result, SREG_o);
			when sbc =>
				sbc(a_i, b_i, SREG_i, result, SREG_o);
			when cpi =>
				cpi(a_i, b_i, SREG_i, result, SREG_o);
			when cpc =>
				cpc(a_i, b_i, SREG_i, result, SREG_o);
			when adiw =>
				adiw(a_i, b_i, SREG_i, result, SREG_o);
			when sbiw =>
				sbiw(a_i, b_i, SREG_i, result, SREG_o);
			when eor =>
				eor(a_i, b_i, SREG_i, result, SREG_o);
			when ldi =>
				ldi(b_i, SREG_i, result, SREG_o);
			when movw =>
				movw(a_i, SREG_i, result, SREG_o);
			when mov =>
				mov(b_i, SREG_i, result, SREG_o);
			when add =>
				add(a_i, b_i, SREG_i, result, SREG_o);
			when adc =>
				adc(a_i, b_i, SREG_i, result, SREG_o);
			when subi =>
				subi(a_i, b_i, SREG_i, result, SREG_o);
			when sbci =>
				sbci(a_i, b_i, SREG_i, result, SREG_o);
			when cli =>
				cli(SREG_i,SREG_o);
			when orr =>
				orr(a_i, b_i, SREG_i, result, SREG_o);
			when rjmp =>
				rjmp(a_i, b_i, result);
			when rcall =>
				rcall(a_i, b_i, result);
			when others =>
				result 	<= a_i;
				SREG_o	<= SREG_i;
		end case;
	end process;

end architecture;
