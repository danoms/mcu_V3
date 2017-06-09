library ieee, my_lib;
use 	ieee.std_logic_1164.all,
		ieee.numeric_std.all,
		my_lib.types.all;

entity general_purpose_register_v2 is
	port
	(
		clk	 		: in std_logic;
		rst			: in std_logic;
		en 			: in std_logic;

		ra1			: in unsigned(4 downto 0);
		ra2			: in unsigned(4 downto 0);
		wa3 			: in unsigned(4 downto 0);

		rd1			: out HALF_WORD_U;
		rd2			: out HALF_WORD_U;

		wd3 			: in HALF_WORD_U;
		we 			: in std_logic;
		hword_en		: in std_logic;		-- for MOVW, ADIW, SBIW

		xd_o			: out HALF_WORD_U;
		yd_o 			: out HALF_WORD_U;
		zd_o			: out HALF_WORD_U
	);
end entity;

architecture avr of general_purpose_register_v2 is

	type ramtype is array(0 to 31) of unsigned(7 downto 0);
	signal GPR : ramtype := (others => (others => '0'));

	signal ra1_plus1, ra2_plus1, wa3_plus1 : unsigned(ra1'range);

begin
	ra1_plus1 	<= ra1 + 1;
	ra2_plus1 	<= ra2 + 1;
	wa3_plus1 	<= wa3 + 1;

	process(clk, rst)
	begin
		if rst then
			GPR 	<= (others => (others => '0'));
		elsif rising_edge(clk) then
			if we then
				GPR(to_integer(wa3)) 	<= wd3(7 downto 0);
				if hword_en then
					GPR(to_integer(wa3_plus1))	<= wd3(15 downto 8);
				end if;
			end if;
		end if;
	end process;

	rd1(15 downto 8) 	<= GPR(to_integer(ra1_plus1)) when hword_en else x"00";
	rd1(7 downto 0) 	<= GPR(to_integer(ra1));

	rd2(15 downto 8) 	<= GPR(to_integer(ra2_plus1)) when hword_en else x"00";
	rd2(7 downto 0) 	<= GPR(to_integer(ra2));

	xd_o	<= GPR(27) & GPR(26);
	yd_o 	<= GPR(29) & GPR(28);
	zd_o 	<= GPR(31) & GPR(30);
end architecture;
