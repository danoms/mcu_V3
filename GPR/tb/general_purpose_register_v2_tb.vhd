library ieee, my_lib;
use   ieee.std_logic_1164.all,
      ieee.numeric_std.all,
      my_lib.types.all;

entity general_purpose_register_v2_tb is
   generic (
      MAIN_CLK_PERIOD : time := 20 ns
   );
end entity;

architecture beh of general_purpose_register_v2_tb is
   component general_purpose_register_v2
   generic (
     gpr_width : positive := 8;
     gpr_size  : positive := 32
   );
   port (
		clk	 		: in std_logic;
		rst			: in std_logic;

		ra1			: in unsigned(4 downto 0);
		ra2			: in unsigned(4 downto 0);

		rd1			: out HALF_WORD_U;
		rd2			: out HALF_WORD_U;

		wd1 			: in HALF_WORD_U;
		we 			: in std_logic;
		hword_en		: in std_logic;		-- for MOVW, ADIW, SBIW

		xd_o			: out HALF_WORD_U;
		yd_o 			: out HALF_WORD_U;
		zd_o			: out HALF_WORD_U
   );
   end component general_purpose_register_v2;

   signal clk  	   : std_logic            := '0';
   signal rst  	   : std_logic            := '0';
   signal ra1 			: unsigned(4 downto 0) := "00001";
   signal ra2 			: unsigned(4 downto 0) := "00010";
   signal rd1      	: HALF_WORD_U          := (others => '0');
   signal rd2      	: HALF_WORD_U          := (others => '0');
   signal xd_o       : HALF_WORD_U          := (others => '0');
   signal yd_o       : HALF_WORD_U          := (others => '0');
   signal zd_o       : HALF_WORD_U          := (others => '0');
   signal wd1   		: HALF_WORD_U          := (others => '0');
	signal we 			: std_logic 			  := '0';
   signal hword_en  	: std_logic            := '0';

begin
   clk   <= not clk after MAIN_CLK_PERIOD / 2;

alu_res_change : process
begin
   wait until rising_edge(clk);
   wait for 4 ns;    -- goes through ALU
   wd1   <= x"1232";
   wait until rising_edge(clk);
   wait for 4 ns;    -- goes through ALU
   wd1   <= x"4562";
end process;

up_we : process
begin
   wait for 2*MAIN_CLK_PERIOD;
   we    <= '1';
   wait for 6*MAIN_CLK_PERIOD;
   we    <= '0';
   wait for MAIN_CLK_PERIOD;
   we    <= '1';
   wait;
end process;
-- wd1   <= rd1 + 1;
update_hword_en : process
begin
   wait for 90 ns;
   hword_en <= '1';
end process;

change_wd1n : process
begin
   wait until rising_edge(clk); -- fetch new instruction in INST_REG
                 -- instruction goes through decoder
   ra1   <= "00011";
   ra2   <= "00100";
   wait until rising_edge(clk);
   ra1   <= "00011";
   ra2   <= "00101";
   wait until rising_edge(clk);
   ra1   <= "00011" + 1;
   ra2   <= "00011";
   wait until rising_edge(clk);
   ra1   <= "00011" + 1;
   ra2   <= "00011";
   wait until rising_edge(clk);
   ra1   <= 5d"28";
   ra2   <= 5d"4";
   wait until rising_edge(clk);
   ra1   <= 5d"30";
   ra2   <= 5d"4";
end process;

general_purpose_register_v2_i : general_purpose_register_v2
   port map (
     clk     	=> clk,
     rst     	=> rst,
     ra1 		=> ra1,
     ra2 		=> ra2,
     rd1      	=> rd1,
     rd2      	=> rd2,
     wd1    	=> wd1,
	  we 			=> we,
     hword_en  => hword_en,
     xd_o      => xd_o,
     yd_o      => yd_o,
     zd_o      => zd_o
   );

end architecture;
