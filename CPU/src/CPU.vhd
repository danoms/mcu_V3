library ieee, my_lib;
use   ieee.std_logic_1164.all,
		ieee.numeric_std.all,
      my_lib.types.all;

entity CPU is
   port( 	clk      : in std_logic;
				rst      : in std_logic;

				PC_o       : out unsigned(15 downto 0);
				instr_i    : in std_logic_vector(15 downto 0);

				data_o   : out unsigned(15 downto 0);
				data_i   : in 	unsigned(15 downto 0);
				addr_o   : out unsigned(15 downto 0);
				ctl_o 	: out ctl_t
				);
end entity;

architecture rtl of CPU is
   component reg
      generic( reg_width : integer);
		port( clk   : in std_logic;
				rst   : in std_logic;
				en    : in std_logic;
				D     : in std_logic_vector(reg_width-1 downto 0);
				q     : out std_logic_vector(reg_width-1 downto 0));
   end component;
	component regU
		generic( limit : integer := 0);
      port( clk   : in std_logic;
            rst   : in std_logic;
            en    : in std_logic;
            D     : in unsigned(15 downto 0);
            q     : out unsigned(15 downto 0));
   end component;
   component adder
      port( a_i   : in unsigned(15 downto 0);
            b_i   : in unsigned(15 downto 0);
            rez   : out unsigned(15 downto 0));
   end component;
	component mux2
		port( d0    : in unsigned(15 downto 0);
				d1    : in unsigned(15 downto 0);
				s     : in std_logic;
				y     : out unsigned(15 downto 0));
	end component;
	component mux4
   port( d0    : in unsigned(15 downto 0);
         d1    : in unsigned(15 downto 0);
			d2 	: in unsigned(15 downto 0);
			d3 	: in unsigned(15 downto 0);
         s     : in std_logic_vector(1 downto 0);
         y     : out unsigned(15 downto 0));
	end component;
	component signext
   port(	d 	: in unsigned(11 downto 0);
			q 	: out unsigned(15 downto 0));
	end component;
   component instruction_decoder_v2
      port(
         data_i			: in std_logic_vector(15 downto 0);	-- instruction to decode

         Rd_addr_o		: out unsigned(4 downto 0);	-- destinatio reg address in GPR
         Rs_addr_o		: out unsigned(4 downto 0);	-- source reg address in GPR
         addr_mode_o		: out unsigned(7 downto 0);	-- I/O or data addressing
         immed_o			: out unsigned(7 downto 0);	-- immediate value

         op_o				: out operation_type; -- controls ALU
			ctl 				: out ctl_t;
         pc_offset 		: out unsigned(11 downto 0);
         io_addres_o 	: out unsigned(5 downto 0);
         bit_o 			: out unsigned(3 downto 0)
      );
   end component;
   component general_purpose_register_v2
      port(
      clk	 		: in std_logic;
      rst			: in std_logic;
      en          : in std_logic;

      ra1			: in unsigned(4 downto 0);
      ra2			: in unsigned(4 downto 0);
      wa3         : in unsigned(4 downto 0);

      rd1			: out unsigned(15 downto 0);
      rd2			: out unsigned(15 downto 0);

      wd3 			: in unsigned(15 downto 0);
      we 			: in std_logic;
      hword_en		: in std_logic;		-- for MOVW, ADIW, SBIW

      xd_o			: out unsigned(15 downto 0);
      yd_o 			: out unsigned(15 downto 0);
      zd_o			: out unsigned(15 downto 0));
   end component;
   component arithmetic_logic_unit_v2
      port(
         a_i 		: in unsigned(15 downto 0);
         b_i		: in unsigned(15 downto 0);
         op_i		: in operation_type;

         result 	: out unsigned(15 downto 0);

         SREG_i	: in std_logic_vector(7 downto 0);
         SREG_o	: out std_logic_vector(7 downto 0));
   end component;

   type state_t is (waitt ,fetch, decode, execute, memory, writed);
   signal state_reg, state_next : state_t;
	constant RAMEND : integer := 255;
   signal en        : std_logic_vector(7 downto 0) := (others => '0');
   signal instr_reg : std_logic_vector(15 downto 0);
   signal Rd_addr, Rs_addr, wa3_GPR : unsigned(4 downto 0);
   signal addr_mode : unsigned(7 downto 0);
   signal immed : unsigned(7 downto 0);
   signal clk_gating : std_logic_vector(7 downto 0);
   signal pc_offset : unsigned(11 downto 0);
   signal io_addr : unsigned(5 downto 0);
   signal bito : unsigned(3 downto 0);
   signal we_GPR_l, we_GPR, we_SREG, we_SREG_l, hword_en : std_logic;
   signal xd, yd, zd : unsigned(15 downto 0);
   signal op   : operation_type;
   signal srcA, srcB, aluResult, GPR_data : unsigned(15 downto 0);
   signal SREG, SREG_next : std_logic_vector(7 downto 0);
	signal PC, PC_next, PC_plus1, SP_next, SP_adder	: unsigned(15 downto 0)	:= (others => '0');
	signal SP	: unsigned(15 downto 0) := x"00FF";
	signal PC_offset_s	: unsigned(15 downto 0);
	signal Rs, Rd : unsigned(15 downto 0);
	signal brlt_and 	: std_logic;
	signal PC_mux_ctl 	: std_logic := '0';
	signal pointer : unsigned(15 downto 0);
	signal branch_en 	: en_branches_t	:= (others => '0');
	signal go_relative 	: std_logic := '0';
	constant plus1 : unsigned(15 downto 0) := 16d"1";
	constant minus1 : unsigned(15 downto 0) := x"FFFF";
-- mux control signals
	signal ctl : ctl_t;
begin

sm_update : process(clk, rst)
begin
   if rst then
      state_reg   <= waitt;
   elsif rising_edge(clk) then
      state_reg   <= state_next;
   end if;
end process;
sm_seq : process(all)
begin
   case( state_reg ) is
		when waitt =>
			state_next	<= fetch;
      when fetch =>
         state_next  <= decode;
      when decode =>
         state_next  <= execute;
      when execute =>
         state_next  <= memory;
      when memory =>
         state_next  <= writed;
      when writed =>
         state_next  <= waitt;
      when others =>
         state_next  <= fetch;
   end case;
end process;

en(0)    <= '1' when state_reg = fetch else '0';
instruction_reg: reg generic map(16) port map(clk, rst, en(0), instr_i, instr_reg );
DECODER: instruction_decoder_v2 port map(instr_reg, Rd_addr, Rs_addr,
                                    addr_mode, immed, op,
                                    ctl, pc_offset, io_addr,
                                    bito);
en(1)    <= '1' when state_reg = decode or state_reg = writed else '0';
GPR: general_purpose_register_v2 port map(clk, rst, en(1), Rd_addr, Rs_addr, Rd_addr, Rd, Rs, GPR_data,
                     we_GPR_l, ctl.en.word, xd, yd, zd);
signed_PC_offset: signext port map(PC_offset, PC_offset_s);
srcPointermux: mux4 port map(x"0000", xd, yd, zd, ctl.mux.pointer, pointer);
srcAmux: mux4 port map(Rd, PC, pointer, x"0000", ctl.mux.srcA, srcA);
srcBmux: mux4 port map(Rs, x"00" & immed, PC_offset_s, x"0000", ctl.mux.srcB, srcB); -- control mux
ALU: arithmetic_logic_unit_v2 port map(srcA, srcB, op, aluResult, SREG, SREG_next);
dataGPRmux: mux2 port map(aluResult, data_i, ctl.mux.GPR, GPR_data);
sreg_reg: reg generic map(8) port map(clk, rst, we_SREG_l, SREG_next, SREG); -- control sreg
we_GPR_l   	<= '1' when state_reg = writed and ctl.we.GPR = '1' else '0';
we_SREG_l	<= '1' when state_reg = writed and ctl.en.SREG = '1' else '0';
--------------------- PC logic -------------------------
------branch logic ------
branch_en.brlt		<= ctl.en_b.brlt and SREG(S); -- Rd < Rs
branch_en.breq 	<= ctl.en_b.breq and SREG(Z);	-- Rd = Rs
go_relative 		<= branch_en.brlt or branch_en.breq;
------------------------
PC_plus_1: adder port map(PC, 16d"1", PC_plus1);
PC_mux_ctl	<= ctl.mux.PC or go_relative;
PC_srcmux: mux2 port map(PC_plus1, aluResult, PC_mux_ctl, PC_next);
en(7)    <= '1' when state_reg = writed else '0';
pc_reg: regU port map(clk, rst, en(7), PC_next, PC);
--------------------- SP logic -------------------------
SP_add_mux:mux4 port map(x"0001", x"0002", x"FFFF", x"FFFE", ctl.mux.SP, SP_adder); -- SP_adder = [+1 +2 -1 -2]
SP_adder_a: adder port map(SP, SP_adder, SP_next); -- SP = SP_next + SP_adder
en(6) 	<= '1' when state_reg = writed and ctl.en.SP = '1' else '0';
sp_reg: regU generic map(RAMEND) port map(clk, rst, en(6), SP_next, SP);
--------------------- output -------------------------
data_o_mux: mux4 port map(aluResult, PC_plus1, Rd, x"0000", ctl.mux.data, data_o);
addr_o_mux: mux4 port map(aluResult, SP, "0000000000" & io_addr, SP_next, ctl.mux.addr, addr_o);
PC_o 				<= PC;
ctl_o.we.RAM 	<= '1' when state_reg = memory and ctl.we.RAM = '1' else '0';
ctl_o.en.RAM 	<= '1' when state_reg = memory and ctl.en.RAM = '1' else '0';
ctl_o.we.IO 	<= '1' when state_reg = memory and ctl.we.IO = '1' else '0';
ctl_o.en.IO 	<= '1' when state_reg = memory and ctl.en.IO = '1' else '0';
end architecture;
