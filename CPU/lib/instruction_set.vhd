-- synthesis library my_lib
library ieee, my_lib;
use ieee.std_logic_1164.all,
		ieee.numeric_std.all,
		my_lib.types.all;

package instruction_set is
	-- Id: 1.0
	procedure sub (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE);
	-- Id: 2.0
	procedure adiw (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE);
	-- Id: 3.0
	procedure sbiw (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE);
	-- Id: 4.0
	procedure eor (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE);
	-- Id: 5.0
	procedure ldi (signal a_i		 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE);
	-- Id: 6.0
	procedure movw(signal a_i		 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE);
	-- Id: 7.0
	procedure sbc (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE);
	-- Id: 8.0
	procedure cpi (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE);
	-- Id: 9.0
	procedure cpc (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE);

	-- Id: 10.0
	procedure mov(	signal a_i		 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE);

	-- Id: 11.0
	procedure add (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE);

	-- Id: 12.0
	procedure adc (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE);

	-- Id: 13.0
	procedure subi (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE);

	-- Id: 14.0
	procedure sbci (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE);

	-- Id: 15.0
	procedure cli (signal SREG_i : in BYTE;
						signal SREG_o : out BYTE);

	-- Id: 16.0
	procedure orr (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE);

	-- Id: 17.0
	procedure rjmp (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal result			: out unsigned(15 downto 0));

	-- Id: 17.0
	procedure rcall (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal result			: out unsigned(15 downto 0));

	--Id: 18.0
	procedure outt(signal a_i		: in unsigned(15 downto 0);
						signal result 	: out unsigned(15 downto 0));

	-- Id: 19.0
	procedure brlt(signal a_i, b_i 	: in unsigned(15 downto 0);
						signal result 		: out unsigned(15 downto 0));

	-- Id: 20.0
	procedure sum(signal a_i, b_i 	: in unsigned(15 downto 0);
						signal result 		: out unsigned(15 downto 0));

	-- Id: 21.0
	procedure sum_plus1(signal a_i, b_i 	: in unsigned(15 downto 0);
								signal result 		: out unsigned(15 downto 0));
end package;

package body instruction_set is
	-- Id: 1.0
	procedure sub (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE) is
		variable tmp_SREG_o 	: BYTE 	:= SREG_i;
		variable tmp_R 		: unsigned(15 downto 0)	:= (others => '0');

	begin
	-- result
		tmp_R 			:= a_i - b_i;

	--!!! set flags
		tmp_SREG_o(H)	:= (a_i(3)and b_i(3))or(b_i(3)and not(b_i(3)))or(not(tmp_R(3))and a_i(3));
		tmp_SREG_o(S)	:= tmp_R(7) xor ((a_i(7)and b_i(7)and not(tmp_R(7)))or(not(a_i(7))and not(b_i(7))and tmp_R(7)));
		tmp_SREG_o(V)	:= (a_i(7)and b_i(7)and not(tmp_R(7)))or(not(a_i(7))and not(b_i(7))and tmp_R(7));
		tmp_SREG_o(N)	:= tmp_R(7);
		tmp_SREG_o(Z)	:= not(tmp_R(7))and not(tmp_R(6))and not(tmp_R(5))and not(tmp_R(4)) and
								not(tmp_R(3))and not(tmp_R(2))and not(tmp_R(1))and not(tmp_R(0));
		tmp_SREG_o(C)	:= (a_i(7)and b_i(7))or(b_i(7)and not(tmp_R(7)))or(not tmp_R(7)and a_i(7));

	-- out
		result		<= tmp_R;
		SREG_o		<= tmp_SREG_o;
	end procedure;

	-- Id: 2.0
	procedure adiw (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE) is
		variable tmp_SREG_o 	: BYTE 	:= SREG_i;
		variable tmp_R 		: unsigned(15 downto 0);

	begin
	-- result
		tmp_R 			:= a_i + b_i;

	--!!! set flags
		tmp_SREG_o(H)	:= (a_i(3)and b_i(3))or(b_i(3)and not(b_i(3)))or(not(tmp_R(3))and a_i(3));
		tmp_SREG_o(S)	:= tmp_R(7) xor ((a_i(7)and b_i(7)and not(tmp_R(7)))or(not(a_i(7))and not(b_i(7))and tmp_R(7)));
		tmp_SREG_o(V)	:= (a_i(7)and b_i(7)and not(tmp_R(7)))or(not(a_i(7))and not(b_i(7))and tmp_R(7));
		tmp_SREG_o(N)	:= tmp_R(7);
		tmp_SREG_o(Z)	:= not(tmp_R(7))and not(tmp_R(6))and not(tmp_R(5))and not(tmp_R(4)) and
								not(tmp_R(3))and not(tmp_R(2))and not(tmp_R(1))and not(tmp_R(0));
		tmp_SREG_o(C)	:= (a_i(7)and b_i(7))or(b_i(7)and not(tmp_R(7)))or(not tmp_R(7)and a_i(7));

	-- out
		result	<= tmp_R;
		SREG_o	<= tmp_SREG_o;
	end procedure;

	-- Id: 3.0
	procedure sbiw (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE) is
		variable tmp_SREG_o 	: BYTE 	:= SREG_i;
		variable tmp_R 		: unsigned(15 downto 0);

	begin
	-- result
		tmp_R 			:= a_i - b_i;

	--!!! set flags DONE
		tmp_SREG_o(V)	:= tmp_R(15) and not (a_i(7));
		tmp_SREG_o(N)	:= tmp_R(15);
		tmp_SREG_o(Z)	:= not(tmp_R(15))and not(tmp_R(14))and not(tmp_R(13))and not(tmp_R(12)) and
								not(tmp_R(11))and not(tmp_R(10))and not(tmp_R(9))and not(tmp_R(8)) and
								not(tmp_R(7))and not(tmp_R(6))and not(tmp_R(5))and not(tmp_R(4)) and
								not(tmp_R(3))and not(tmp_R(2))and not(tmp_R(1))and not(tmp_R(0));
		tmp_SREG_o(C)	:= tmp_R(15) and not(a_i(7));
		tmp_SREG_o(S)	:= tmp_SREG_o(V) xor tmp_SREG_o(N);
	-- out
		result	<= tmp_R;
		SREG_o	<= tmp_SREG_o;
	end procedure;

	-- Id: 4.0
	procedure eor (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE) is
		variable tmp_SREG_o 	: BYTE 	:= SREG_i;
		variable tmp_R 		: unsigned(15 downto 0);

	begin
	-- result
		tmp_R 			:= a_i xor b_i;
	--!!! set flags
		tmp_SREG_o(V)	:= '0';
		tmp_SREG_o(N)	:= tmp_R(7);
		tmp_SREG_o(S)	:= tmp_SREG_o(V) xor tmp_SREG_o(N);
		tmp_SREG_o(Z)	:= not(tmp_R(7))and not(tmp_R(6))and not(tmp_R(5))and not(tmp_R(4)) and
								not(tmp_R(3))and not(tmp_R(2))and not(tmp_R(1))and not(tmp_R(0));
	-- out
		result	<= tmp_R;
		SREG_o	<= tmp_SREG_o;
	end procedure;

	-- Id: 5.0
	procedure ldi (signal a_i		 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE) is
		variable tmp_SREG_o 	: BYTE 	:= SREG_i;
		variable tmp_R 		: unsigned(15 downto 0);

	begin
	-- result
		tmp_R 			:= a_i;
	-- out
		result	<= tmp_R;
		SREG_o	<= tmp_SREG_o;
	end procedure;

	-- Id: 6.0
	procedure movw(signal a_i		 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE) is
	variable tmp_SREG_o 	: BYTE 	:= SREG_i;
		variable tmp_R 		: unsigned(15 downto 0);

	begin
	-- result
		tmp_R 			:= a_i;

	--!!! set flags
--		tmp_SREG_o(H)	:= (a_i(3)and b_i(3))or(b_i(3)and not(b_i(3)))or(not(tmp_R(3))and a_i(3));
--		tmp_SREG_o(S)	:= tmp_R(7) xor ((a_i(7)and b_i(7)and not(tmp_R(7)))or(not(a_i(7))and not(b_i(7))and tmp_R(7)));
--		tmp_SREG_o(V)	:= (a_i(7)and b_i(7)and not(tmp_R(7)))or(not(a_i(7))and not(b_i(7))and tmp_R(7));
--		tmp_SREG_o(N)	:= tmp_R(7);
--		tmp_SREG_o(Z)	:= not(tmp_R(7))and not(tmp_R(6))and not(tmp_R(5))and not(tmp_R(4)) and
--								not(tmp_R(3))and not(tmp_R(2))and not(tmp_R(1))and not(tmp_R(0));
--		tmp_SREG_o(C)	:= (a_i(7)and b_i(7))or(b_i(7)and not(tmp_R(7)))or(not tmp_R(7)and a_i(7));

	-- out
		result 	<= tmp_R;
		SREG_o	<= tmp_SREG_o;
	end procedure;

	-- Id: 7.0
	procedure sbc (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE) is
	variable tmp_SREG_o 	: BYTE 	:= SREG_i;
		variable tmp_R 		: unsigned(15 downto 0);

	begin
	-- result
		tmp_R 			:= a_i - b_i - ("" & SREG_i(C));

	--!!! set flags
		tmp_SREG_o(H)	:= (a_i(3)and b_i(3))or(b_i(3)and not(b_i(3)))or(not(tmp_R(3))and a_i(3));
		tmp_SREG_o(S)	:= tmp_R(7) xor ((a_i(7)and b_i(7)and not(tmp_R(7)))or(not(a_i(7))and not(b_i(7))and tmp_R(7)));
		tmp_SREG_o(V)	:= (a_i(7)and b_i(7)and not(tmp_R(7)))or(not(a_i(7))and not(b_i(7))and tmp_R(7));
		tmp_SREG_o(N)	:= tmp_R(7);
		tmp_SREG_o(Z)	:= not(tmp_R(7))and not(tmp_R(6))and not(tmp_R(5))and not(tmp_R(4)) and
								not(tmp_R(3))and not(tmp_R(2))and not(tmp_R(1))and not(tmp_R(0));
		tmp_SREG_o(C)	:= (a_i(7)and b_i(7))or(b_i(7)and not(tmp_R(7)))or(not tmp_R(7)and a_i(7));

	-- out
		result	<= tmp_R;
		SREG_o	<= tmp_SREG_o;
	end procedure;

	-- Id: 8.0
	procedure cpi (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE) is
	variable tmp_SREG_o 	: BYTE 	:= SREG_i;
		variable tmp_R 		: unsigned(15 downto 0);

	begin
	-- result
		tmp_R 			:= a_i - b_i;

	--!!! set flags
		tmp_SREG_o(H)	:= (a_i(3)and b_i(3))or(b_i(3)and not(b_i(3)))or(not(tmp_R(3))and a_i(3));
		tmp_SREG_o(V)	:= (a_i(7) and not(b_i(7)) and not(tmp_R(7))) or (not (a_i(7)) and b_i(7) and (tmp_R(7)));
		tmp_SREG_o(N)	:= tmp_R(7);
		tmp_SREG_o(Z)	:= not(tmp_R(7))and not(tmp_R(6))and not(tmp_R(5))and not(tmp_R(4)) and
								not(tmp_R(3))and not(tmp_R(2))and not(tmp_R(1))and not(tmp_R(0));
		tmp_SREG_o(C)	:= (a_i(7)and b_i(7))or(b_i(7)and not(tmp_R(7)))or(not tmp_R(7)and a_i(7));
		tmp_SREG_o(S)	:= tmp_SREG_o(N) xor tmp_SREG_o(V);
	-- out
		result	<= tmp_R;
		SREG_o	<= tmp_SREG_o;
	end procedure;

	-- Id: 9.0
	procedure cpc (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE) is
	variable tmp_SREG_o 	: BYTE 	:= SREG_i;
		variable tmp_R 		: unsigned(15 downto 0);

	begin
	-- result
		tmp_R 			:= a_i - b_i - ("" & SREG_i(C));

	--!!! set flags
		tmp_SREG_o(H)	:= (a_i(3)and b_i(3))or(b_i(3)and not(b_i(3)))or(not(tmp_R(3))and a_i(3));
		tmp_SREG_o(S)	:= tmp_R(7) xor ((a_i(7)and b_i(7)and not(tmp_R(7)))or(not(a_i(7))and not(b_i(7))and tmp_R(7)));
		tmp_SREG_o(V)	:= (a_i(7)and b_i(7)and not(tmp_R(7)))or(not(a_i(7))and not(b_i(7))and tmp_R(7));
		tmp_SREG_o(N)	:= tmp_R(7);
		tmp_SREG_o(Z)	:= not(tmp_R(7))and not(tmp_R(6))and not(tmp_R(5))and not(tmp_R(4)) and
								not(tmp_R(3))and not(tmp_R(2))and not(tmp_R(1))and not(tmp_R(0));
		tmp_SREG_o(C)	:= (a_i(7)and b_i(7))or(b_i(7)and not(tmp_R(7)))or(not tmp_R(7)and a_i(7));

	-- out
		result	<= tmp_R;
		SREG_o	<= tmp_SREG_o;
	end procedure;

	-- Id: 10.0
	procedure mov(	signal a_i		 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE) is

		variable tmp_SREG_o 	: BYTE 	:= SREG_i;
		variable tmp_R 		: unsigned(15 downto 0);
	begin
	-- result
		tmp_R 			:= a_i;
	-- out
		result	<= tmp_R;
		SREG_o	<= tmp_SREG_o;
	end procedure;

	-- Id: 11.0
	procedure add (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE) is

		variable tmp_SREG_o 	: BYTE 	:= SREG_i;
		variable tmp_R 		: unsigned(15 downto 0);
	begin
	-- result
		tmp_R 			:= a_i + b_i;

	-- !!! set flags
		tmp_SREG_o(H)	:= (a_i(3)and b_i(3))or(b_i(3)and not(b_i(3)))or(not(tmp_R(3))and a_i(3));
		tmp_SREG_o(S)	:= tmp_R(7) xor ((a_i(7)and b_i(7)and not(tmp_R(7)))or(not(a_i(7))and not(b_i(7))and tmp_R(7)));
		tmp_SREG_o(V)	:= (a_i(7)and b_i(7)and not(tmp_R(7)))or(not(a_i(7))and not(b_i(7))and tmp_R(7));
		tmp_SREG_o(N)	:= tmp_R(7);
		tmp_SREG_o(Z)	:= not(tmp_R(7))and not(tmp_R(6))and not(tmp_R(5))and not(tmp_R(4)) and
								not(tmp_R(3))and not(tmp_R(2))and not(tmp_R(1))and not(tmp_R(0));
		tmp_SREG_o(C)	:= (a_i(7)and b_i(7))or(b_i(7)and not(tmp_R(7)))or(not tmp_R(7)and a_i(7));

	-- out
		result	<= tmp_R;
		SREG_o	<= tmp_SREG_o;
	end procedure;

	-- Id: 12.0
	procedure adc (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE) is

		variable tmp_SREG_o 	: BYTE 	:= SREG_i;
		variable tmp_R 		: unsigned(15 downto 0);
	begin
	-- result
		tmp_R 			:= a_i + b_i + ("" & SREG_i(C));

	-- !!! set flags
		tmp_SREG_o(H)	:= (a_i(3)and b_i(3))or(b_i(3)and not(b_i(3)))or(not(tmp_R(3))and a_i(3));
		tmp_SREG_o(S)	:= tmp_R(7) xor ((a_i(7)and b_i(7)and not(tmp_R(7)))or(not(a_i(7))and not(b_i(7))and tmp_R(7)));
		tmp_SREG_o(V)	:= (a_i(7)and b_i(7)and not(tmp_R(7)))or(not(a_i(7))and not(b_i(7))and tmp_R(7));
		tmp_SREG_o(N)	:= tmp_R(7);
		tmp_SREG_o(Z)	:= not(tmp_R(7))and not(tmp_R(6))and not(tmp_R(5))and not(tmp_R(4)) and
								not(tmp_R(3))and not(tmp_R(2))and not(tmp_R(1))and not(tmp_R(0));
		tmp_SREG_o(C)	:= (a_i(7)and b_i(7))or(b_i(7)and not(tmp_R(7)))or(not tmp_R(7)and a_i(7));

	-- out
		result	<= tmp_R;
		SREG_o	<= tmp_SREG_o;
	end procedure;

	-- Id: 13.0
	procedure subi (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE) is

		variable tmp_SREG_o 	: BYTE 	:= SREG_i;
		variable tmp_R 		: unsigned(15 downto 0);
	begin
	-- result
		tmp_R 			:= a_i - b_i;
	-- !!! set flags
		tmp_SREG_o(H)	:= (a_i(3)and b_i(3))or(b_i(3)and not(b_i(3)))or(not(tmp_R(3))and a_i(3));
		tmp_SREG_o(S)	:= tmp_R(7) xor ((a_i(7)and b_i(7)and not(tmp_R(7)))or(not(a_i(7))and not(b_i(7))and tmp_R(7)));
		tmp_SREG_o(V)	:= (a_i(7)and b_i(7)and not(tmp_R(7)))or(not(a_i(7))and not(b_i(7))and tmp_R(7));
		tmp_SREG_o(N)	:= tmp_R(7);
		tmp_SREG_o(Z)	:= not(tmp_R(7))and not(tmp_R(6))and not(tmp_R(5))and not(tmp_R(4)) and
								not(tmp_R(3))and not(tmp_R(2))and not(tmp_R(1))and not(tmp_R(0));
		tmp_SREG_o(C)	:= (not a_i(7) and b_i(7)) or (b_i(7) and a_i(7)) or (a_i(7) and not(b_i(7)));
	-- out
		result	<= tmp_R;
		SREG_o	<= tmp_SREG_o;
	end procedure;

	-- Id: 14.0
	procedure sbci (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE) is
		variable tmp_SREG_o 	: BYTE 	:= SREG_i;
		variable tmp_R 		: unsigned(15 downto 0);
	begin
	-- result
		tmp_R 			:= a_i - b_i - ("" & SREG_i(C));
	-- !!! set flags
		tmp_SREG_o(H)	:= (a_i(3)and b_i(3))or(b_i(3)and not(b_i(3)))or(not(tmp_R(3))and a_i(3));
		tmp_SREG_o(S)	:= tmp_R(7) xor ((a_i(7)and b_i(7)and not(tmp_R(7)))or(not(a_i(7))and not(b_i(7))and tmp_R(7)));
		tmp_SREG_o(V)	:= (a_i(7)and b_i(7)and not(tmp_R(7)))or(not(a_i(7))and not(b_i(7))and tmp_R(7));
		tmp_SREG_o(N)	:= tmp_R(7);
		tmp_SREG_o(Z)	:= not(tmp_R(7))and not(tmp_R(6))and not(tmp_R(5))and not(tmp_R(4)) and
								not(tmp_R(3))and not(tmp_R(2))and not(tmp_R(1))and not(tmp_R(0));
		tmp_SREG_o(C)	:= (not a_i(7) and b_i(7)) or (b_i(7) and a_i(7)) or (a_i(7) and not(b_i(7)));
	-- out
		result	<= tmp_R;
		SREG_o	<= tmp_SREG_o;
	end procedure;

	-- Id: 15.0
	procedure cli (signal SREG_i : in BYTE;
						signal SREG_o : out BYTE) is
		variable tmp_SREG_o 	: BYTE 	:= SREG_i;
	begin
	-- !!! set flags
		tmp_SREG_o(I) 	:= '0';
	-- out
		SREG_o	<= tmp_SREG_o;
	end procedure;

	-- Id: 16.0
	procedure orr (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal SREG_i			: in BYTE;
						signal result			: out unsigned(15 downto 0);
						signal SREG_o 			: out BYTE) is
		variable tmp_SREG_o 	: BYTE 	:= SREG_i;
		variable tmp_R 		: unsigned(15 downto 0);
	begin
	-- result
		tmp_R 			:= a_i or b_i;
	-- set flags DONE
		tmp_SREG_o(V)	:= '0';
		tmp_SREG_o(N)	:= tmp_R(7);
		tmp_SREG_o(Z)	:= not(tmp_R(7))and not(tmp_R(6))and not(tmp_R(5))and not(tmp_R(4)) and
								not(tmp_R(3))and not(tmp_R(2))and not(tmp_R(1))and not(tmp_R(0));
		tmp_SREG_o(S)	:= tmp_SREG_o(N) xor tmp_SREG_o(V);
	-- out
		result	<= tmp_R;
		SREG_o	<= tmp_SREG_o;
	end procedure;

	-- Id: 17.0
	procedure rjmp (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal result			: out unsigned(15 downto 0)) is
		variable tmp_R 		: unsigned(15 downto 0);
	begin
	-- result
		tmp_R 			:= a_i + b_i + 1;
	-- out
		result	<= tmp_R;
	end procedure;

	-- Id: 17.0
	procedure rcall (signal a_i, b_i 		: in unsigned(15 downto 0);
						signal result			: out unsigned(15 downto 0)) is
		variable tmp_R 		: unsigned(15 downto 0);
	begin
	-- result
		tmp_R 			:= a_i + b_i + 1;
	-- out
		result	<= tmp_R;
	end procedure;

	--Id: 18.0
	procedure outt(signal a_i		: in unsigned(15 downto 0);
						signal result 	: out unsigned(15 downto 0)) is
		variable tmp_R 		: unsigned(15 downto 0);
	begin
	-- result
		tmp_R 			:= a_i;
	-- out
		result	<= tmp_R;
	end procedure;

	-- Id: 19.0
	procedure brlt(signal a_i, b_i 	: in unsigned(15 downto 0);
						signal result 		: out unsigned(15 downto 0)) is
		variable tmp_R 		: unsigned(15 downto 0);
	begin
	-- result
		tmp_R 			:= a_i + b_i + 1;
	-- out
		result	<= tmp_R;
	end procedure;

	-- Id: 20.0
	procedure sum(signal a_i, b_i 	: in unsigned(15 downto 0);
						signal result 		: out unsigned(15 downto 0)) is
		variable tmp_R 		: unsigned(15 downto 0);
	begin
	-- result
		tmp_R 			:= a_i + b_i;
	-- out
		result	<= tmp_R;
	end procedure;

	-- Id: 21.0
	procedure sum_plus1(signal a_i, b_i 	: in unsigned(15 downto 0);
								signal result 		: out unsigned(15 downto 0)) is
		variable tmp_R 		: unsigned(15 downto 0);
	begin
	-- result
		tmp_R 			:= a_i + b_i + 1;
	-- out
		result	<= tmp_R;
	end procedure;
end package body;
