library ieee, my_lib;
use 	ieee.std_logic_1164.all,
		ieee.numeric_std.all,
		my_lib.types.all;

entity instruction_decoder_v2 is
		port(
			data_i			: in HALF_WORD;	-- instruction to decode

			Rd_addr_o		: out unsigned(4 downto 0);	-- destinatio reg address in GPR
			Rs_addr_o		: out unsigned(4 downto 0);	-- source reg address in GPR
			addr_mode_o		: out BYTE_U;	-- I/O or data addressing
			immed_o			: out BYTE_U;	-- immediate value

			op_o				: out operation_type; -- controls ALU
			ctl 				: out ctl_t;
			-- ctl_line_o		: out std_logic_vector(7 downto 0);
			-- ctl_line_o 		: out mux_ctl_t;
			-- ctl_en			: out en_ctl_t;
			-- clk_gating_o	: out std_logic_vector(7 downto 0);

			pc_offset 		: out unsigned(11 downto 0);
			io_addres_o 	: out unsigned(5 downto 0);
			bit_o 			: out unsigned(3 downto 0)

			-- we_gpr 			: out std_logic;
			-- we_sreg 			: out std_logic
		);
end entity;

architecture something of instruction_decoder_v2 is
	-- signal data_i : HALF_WORD := data_i_old;
   -- signal high_x   : unsigned(3 downto 0) := unsigned(data_i(15 downto 12));
   alias high_l_x : std_logic_vector(3 downto 0) is data_i(11 downto 8);
	alias high_x   : std_logic_vector(3 downto 0) is data_i(15 downto 12);

   alias low_h_x  : std_logic_vector(3 downto 0) is data_i(7 downto 4);
   alias low_x    : std_logic_vector(3 downto 0) is data_i(3 downto 0);

begin

   decode_input_data : process(all)
   begin
		-- default values/positions
		Rd_addr_o	<= unsigned(data_i(8 downto 4));
		Rs_addr_o 	<= unsigned(data_i(9) & data_i(3 downto 0));
--		addr_mode_o	<=
		immed_o		<= unsigned(data_i(11 downto 8) & data_i(3 downto 0));

		op_o 			<= NOP;
		ctl.we 		<= (others => '0');	-- read only

		ctl.mux.srcA 		<= "00";	-- Rd
		ctl.mux.srcB 		<= "00";	-- Rs
		ctl.mux.PC 			<= '0';	-- PC + 1
		ctl.mux.GPR			<= '0';	-- aluResult
		ctl.mux.SP 			<= "00";	-- SP + 1
		ctl.mux.data 		<= "00";	-- aluResult
		ctl.mux.addr 		<= "00";	-- aluResult
		ctl.mux.pointer 	<= "00";	-- X

		ctl.en 		<= (others => '0'); 	-- disabled
		ctl.en_b 	<= (others => '0');	-- disabled branches

		pc_offset	<= unsigned(data_i(11 downto 0));
		io_addres_o <= unsigned(data_i(10 downto 9) & data_i(3 downto 0));
		bit_o 		<= unsigned(data_i(9) & data_i(2 downto 0));

      case( high_x ) is

         when x"0" =>

			Rs_addr_o 	<= unsigned(data_i(9) & low_x);
			Rd_addr_o 	<= unsigned(data_i(8) & low_h_x);

            case( high_l_x ) is
					when x"1" =>
						op_o 	<= movw;
						ctl.we.GPR 		<= '1';
						ctl.en.word 	<= '1';

            	when x"4" | x"5" | x"6" | x"7" =>
						op_o 			<= cpc;

					when x"8" | x"9" | x"A" | x"B" =>
						op_o 			<= sbc;

					when x"C" | x"D" | x"E" | x"F" =>
						op_o 			<= add;
						ctl.we.GPR 	<= '1';
						ctl.en.SREG <= '1';
--						we_gpr 		<= '1';
--						we_sreg 		<= '1';
            	when others =>

            end case;

			when x"1" =>
			Rs_addr_o 	<= unsigned(data_i(9) & low_x);
			Rd_addr_o 	<= unsigned(data_i(8) & low_h_x);

            case( high_l_x ) is

					when x"0" | x"1" | x"2" | x"3" =>
						op_o 			<= cpse;

            	when x"4" | x"5" | x"6" | x"7" =>
						op_o 			<= cp;

					when x"8" | x"9" | x"A" | x"B" =>
						op_o 			<= sub;

					when x"C" | x"D" | x"E" | x"F" =>
						op_o 			<= adc;
						ctl.we.GPR  <= '1';
						ctl.en.SREG <= '1';

--						we_gpr 		<= '1';
--						we_SREG 		<= '1';
            	when others =>

            end case;

			when x"2" =>
			Rs_addr_o 	<= unsigned(data_i(9) & low_x);
			Rd_addr_o 	<= unsigned(data_i(8) & low_h_x);

            case( high_l_x ) is


            	when x"0" | x"1" | x"2" | x"3" =>
						op_o 			<= andd;

            	when x"4" | x"5" | x"6" | x"7" =>
						op_o 			<= eor;
						ctl.we.GPR 	<= '1';

					when x"8" | x"9" | x"A" | x"B" =>
						op_o 			<= orr;
						ctl.en.SREG 	<= '1';
						ctl.we.GPR 		<= '1';

					when x"C" | x"D" | x"E" | x"F" =>
						op_o 			<= mov;
						ctl.we.GPR 	<= '1';
--						we_gpr		<= '1';

					when others =>

				end case;

			when x"3" =>
				Rd_addr_o 	<= unsigned('1' & low_h_x);
				immed_o 		<= unsigned(high_l_x & low_x);
				op_o 			<= cpi;
				ctl.mux.srcB 	<= "01"; -- srcB is immediate
				ctl.en.SREG 	<= '1';

			when x"4" =>
				Rd_addr_o 	<=unsigned('1' & low_h_x);
				immed_o 		<= unsigned(high_l_x & low_x);
				op_o 			<= sbci;
				ctl.mux.srcB 	<= "01"; -- immediate
				ctl.we.GPR 		<= '1';
				ctl.en.SREG 	<= '1';

			when x"5" =>
				Rd_addr_o 	<= unsigned('1' & low_h_x);
				immed_o 		<= unsigned(high_l_x & low_x);
				op_o 			<= subi;
				ctl.mux.srcB 	<= "01"; -- srcB is immediate
				ctl.we.GPR 		<= '1';
				ctl.en.SREG 	<= '1';


			when x"6" =>
				Rd_addr_o 	<=unsigned('1' & low_h_x);
				immed_o 		<= unsigned(high_l_x & low_x);
				op_o 			<= ori;

			when x"7" =>
				Rd_addr_o 	<= unsigned('1' & low_h_x);
				immed_o 		<= unsigned(high_l_x & low_x);
				op_o 			<= andi;

			when x"8" | x"A" =>
			Rd_addr_o 	<= unsigned(data_i(8 downto 4));
			immed_o		<= unsigned("00" & data_i(13) & data_i(11 downto 10) & data_i(2 downto 0));
			ctl.en.RAM 	<= '1';
			ctl.mux.srcA 	<= "10"; 		-- pointer
			ctl.mux.srcB 	<= "01"; 		-- immediate
			ctl.mux.data 	<= "10"; 		-- Rd
				case?( high_l_x & low_x ) is

					when "--0-0---" => -- read RAM
						op_o	<= lddz;
						ctl.mux.pointer 	<= "11";	-- Z

					when "--0-1---" =>
						op_o	<= lddy;
						ctl.mux.pointer 	<= "10";	-- Y

					when "--1-0---" => -- write RAM
						op_o	<= stdz;
						ctl.mux.pointer 	<= "11";	-- Z
						ctl.we.RAM 			<= '1';
					when "--1-1---" =>
						op_o	<= stdy;
						ctl.mux.pointer 	<= "10";	-- Y
						ctl.we.RAM 			<= '1';
					when others =>

				end case?;

			when x"9" =>
			Rd_addr_o 	<= unsigned(data_i(8 downto 4));

				case( high_l_x ) is
					when x"0" | x"1" =>
						case( low_x ) is
							when x"0" =>
								op_o	<= lds;

							when x"1" =>
								op_o 	<= ldzp;

							when x"2" =>
								op_o 	<= ldzm;

							when x"4" =>
								op_o 	<= lpmz;

							when x"5" =>
								op_o 	<= lpmzp;

							when x"6" =>
								op_o 	<= elpmz;

							when x"7" =>
								op_o 	<= elpmzp;

							when x"9" =>
								op_o 	<= ldyp;

							when x"A" =>
								op_o 	<= ldym;

							when x"C" =>
								op_o 	<= ldx;

							when x"D" =>
								op_o 	<= ldxp;

							when x"E" =>
								op_o 	<= ldxm;

							when x"F" =>
								op_o 				<= pop;
--								ctl_en.SP 		<= '1';
								ctl.en.SP 		<= '1'; 	-- update SP
								ctl.mux.SP 		<= "00"; -- plus 1
								ctl.we.GPR 		<= '1';
								ctl.mux.GPR 	<= '1'; -- data from RAM to GPR
								ctl.en.RAM 		<= '1';
								ctl.mux.addr 	<= "11"; -- pre SP + 1
							when others =>

						end case;

					when x"2" | x"3" =>
						case( low_x ) is
							when x"0" =>
								op_o	<= sts;

							when x"1" =>
								op_o 	<= stzp;

							when x"2" =>
								op_o 	<= stzm;

							when x"9" =>
								op_o 	<= styp;

							when x"A" =>
								op_o 	<= stym;

							when x"C" =>
								op_o 	<= stx;

							when x"D" =>
								op_o 	<= stxp;

							when x"E" =>
								op_o 	<= stxm;

							when x"F" =>
								op_o 				<= push;
								ctl.en.SP	 	<= '1'; 		-- update SP
								ctl.mux.SP 		<= "10"; 	-- SP - 1
								ctl.we.RAM 		<= '1';
								ctl.en.RAM 		<= '1';
								ctl.mux.data 	<= "10";		-- Rd
								ctl.mux.addr 	<= "01";		-- SP
							when others =>
						end case;

					when x"4" | x"5" =>
						case( low_x ) is
							when x"0" =>
								op_o	<= com;

							when x"1" =>
								op_o 	<= neg;

							when x"2" =>
								op_o 	<= swap;

							when x"3" =>
								op_o 	<= inc;

							when x"5" =>
								op_o 	<= asr;

							when x"6" =>
								op_o 	<= lsr;

							when x"7" =>
								op_o 	<= rorr;

							when x"8" =>
								op_o 	<= secc;

							when x"9" =>
								op_o 	<= inc;

							when x"A" =>
								op_o 	<= stym;

							when x"C" =>
								op_o 	<= stx;

							when x"D" =>
								op_o 	<= stxp;

							when x"E" =>
								op_o 	<= stxm;

							when x"F" =>
								op_o 	<= call;
							when others =>
						end case;

					when x"6" =>
						immed_o		<= unsigned("00" & data_i(7 downto 6) & low_x);
						Rd_addr_o	<= unsigned("11" & data_i(5 downto 4) & '0');
						op_o			<= adiw;
						ctl.en.word 	<= '1';
						ctl.we.GPR 		<= '1';

					when x"7" =>
						immed_o		<= unsigned("00" & data_i(7 downto 6) & low_x);
						Rd_addr_o	<= unsigned("11" & data_i(5 downto 4) & '0');
						op_o			<= sbiw;

					when x"8" =>
--						bit_o				<= unsigned(data_i(2 downto 0));
						io_addres_o 	<= unsigned('0' & data_i(7 downto 3));
						op_o				<= cbi;

					when x"9" =>
--						bit_o				<= unsigned(data_i(2 downto 0));
						io_addres_o 	<= unsigned('0' & data_i(7 downto 3));
						op_o				<= sbic;

					when x"A" =>
--						bit_o				<= unsigned(data_i(2 downto 0));
						io_addres_o 	<= unsigned('0' & data_i(7 downto 3));
						op_o				<= sbi;

					when x"B" =>
--						bit_o				<= unsigned(data_i(2 downto 0));
						io_addres_o 	<= unsigned('0' & data_i(7 downto 3));
						op_o				<= sbis;

					when x"C" | x"D" | x"E" | x"F" =>
						Rs_addr_o	<= unsigned(data_i(9) & data_i(3 downto 0));
						Rd_addr_o	<= unsigned(data_i(8 downto 4));
						op_o			<= mul;

					when others =>
				end case;

			when x"B" =>
			io_addres_o 	<= unsigned(data_i(10 downto 9) & low_x);
			Rd_addr_o 		<= unsigned(data_i(8) & low_h_x);

				case( high_l_x ) is

					when x"0" | x"1" | x"2" | x"3" | x"4" | x"5" | x"6" | x"7" =>
						op_o 			<= inn;

					when x"8" | x"9" | x"A" | x"B" | x"C" | x"D" | x"E" | x"F" =>
						op_o 				<= outt;
						ctl.mux.addr 	<= "10"; 	-- addr = I/O_addr
						ctl.we.IO 		<= '1';
						ctl.en.IO 		<= '1';

					when others =>
				end case;
			when x"C" =>
				pc_offset 	    <= unsigned(data_i(11 downto 0));
				op_o 			    <= rjmp;
				ctl.mux.PC 	    <= '1'; 	-- PC_next = aluResult
				ctl.mux.srcA 	 <= "01"; 	-- PC to srcA
				ctl.mux.srcB 	 <= "10"; 	-- signed immediate to srcB
			when x"D" =>
				pc_offset 	    <= unsigned(data_i(11 downto 0));
				op_o 			    <= rcall;
				ctl.mux.PC      <= '1'; 			-- PC_next    = ALU result
				ctl.mux.srcA 	 <= "01"; 			-- srcA       = PC
				ctl.mux.srcB 	 <= "10"; 			-- srcB       = immed_s
				ctl.mux.data 	 <= "01"; 			-- RAM_data_i = PC_plus1
				ctl.mux.SP 		 <= "10";     		-- SP_next = SP - 1, ram 16x255
				ctl.mux.addr 	 <= "01"; 			-- SP
				ctl.en.SP 		 <= '1';
				ctl.we.RAM 		 <= '1';
			when x"E" =>
				immed_o 		    <= unsigned(data_i(11 downto 8) & data_i(3 downto 0));
				Rd_addr_o 	    <= unsigned('1' & data_i(7 downto 4));
				op_o 			    <= ldi;
				ctl.we.GPR 	    <= '1';
				ctl.mux.srcB 	 <= "01";
--				we_gpr		<= '1';
--				ctl_line_o.immed 	<= '1';

			when x"F" =>
			bit_o 		<= unsigned(data_i(3 downto 0));

				case( high_l_x ) is

					when x"0" | x"1" | x"2" | x"3"  =>
						pc_offset 	<= data_i(9)&data_i(9)&data_i(9)&data_i(9)&
											data_i(9) & unsigned(data_i(9 downto 3));
						ctl.mux.srcA 	<= "01"; 	-- PC
						ctl.mux.srcB 	<= "01"; 	-- signed immed

						case (low_x(2 downto 0)) is
							when "100" =>
								op_o 	<= brlt;
								ctl.en_b.brlt 	<= '1';
							when "001" =>
								op_o 	<= breq;
								ctl.en_b.breq 	<= '1';

							when others =>
						end case;

					when x"8" | x"9" =>
						op_o 			<= bld;
						Rd_addr_o 	<= unsigned(data_i(8) & low_h_x);

					when x"A" | x"B" =>
						op_o 			<= bst;
						Rd_addr_o 	<= unsigned(data_i(8) & low_h_x);

					when x"C" | x"D" =>
						op_o 			<= sbrc;
						Rd_addr_o 	<= unsigned(data_i(8) & low_h_x);

					when x"E" | x"F" =>
						op_o 			<= sbrs;
						Rd_addr_o 	<= unsigned(data_i(8) & low_h_x);

					when others =>

				end case;

         when others =>

      end case;
   end process;
end architecture;
