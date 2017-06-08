library ieee;
use   ieee.std_logic_1164.all,
      ieee.numeric_std.all;

entity CPU_tb is
   generic( MAIN_CLK_PERIOD : time := 10 ns);
end entity;

architecture testy of cpu_tb is

   component CPU
      port( 	clk      : in std_logic;
   				rst      : in std_logic;

   				PC_o       : out unsigned(15 downto 0);
   				instr_i    : in std_logic_vector(15 downto 0);

   				data_o   : out unsigned(15 downto 0);
   				data_i   : in 	unsigned(15 downto 0);
   				addr_o   : out unsigned(15 downto 0);
   				we_RAM   : out std_logic;
   				we_IO    : out std_logic;

   				ctl_data : out std_logic); -- data_i <- RAM ? IO
   end component;

   signal clk      : std_logic   := '0';
   signal rst      : std_logic   := '0';
   signal PC_o     : unsigned(15 downto 0)   := (others => '0');
   signal instr_i  : std_logic_vector(15 downto 0)   := (others => '0');
   signal data_o   : unsigned(15 downto 0)   := (others => '0');
   signal data_i   : unsigned(15 downto 0)   := (others => '0');
   signal addr_o   : unsigned(15 downto 0)   := (others => '0');
   signal we_RAM   : std_logic := '0';
   signal we_IO    : std_logic := '0';
   signal ctl_data : std_logic := '0';

   -- constant instr_tb : std_logic_vector := x"09C010C00FC00EC00DC00CC00BC00AC0" &
   --                                           x"09C008C011271FBFCFE5D0E0DEBFCDBF" &
   --                                           x"02D04AC0EDCFCF93DF9300D000D000D0" &
   --                                           x"CDB7DEB748EC50E0CE5FDF4F58834A93" &
   --                                           x"C150D04041E950E0CC5FDF4F58834A93" &
   --                                           x"C350D040CA5FDF4F18831A93C550D040" &
   --                                           x"CB5FDF4F49915881C650D040452B79F0" &
   --                                           x"CB5FDF4F49915881C650D0404150510B" &
   --                                           x"CA5FDF4F58834A93C550D040E9CFCF5F" &
   --                                           x"DF4F69917881C250D040CD5FDF4F4991" &
   --                                           x"5881C450D040460F571FCA5FDF4F5883" &
   --                                           x"4A93C550D040D4CFF894FFCF";
   constant instr_tb : std_logic_vector := x"0EEF17E0412F302F340F411F11271027" &
                                             x"1F5F0A40F9CF4F933F930F911F91";
begin
   clk   <= not clk after MAIN_CLK_PERIOD/2;

   uut: CPU
      port map(  clk    => clk,
   				  rst    => rst,

   				PC_o     => PC_o,
   				instr_i  => instr_i,

   				data_o   => data_o,
   				data_i   => data_i,
   				addr_o   => addr_o,
   				we_RAM   => we_RAM,
   				we_IO    => we_IO,

   				ctl_data => ctl_data); -- data_i <- RAM ? IO

   init : process
   begin
      rst <= '1';
      wait for 3*MAIN_CLK_PERIOD;
      rst <= '0';
      wait;
   end process;

-- 04E017E0412F302F340F4B1F4F93
   -- for i in 0 to 7 loop
   --    instr_i  <= instr_tb( 7+(i*2+1)*8 downto (i*2+1)*8) & instr_tb(7+(i*2)*8 downto (i*2)*8);
   -- end loop;

   instr_in : process
   begin
      for i in 0 to instr_tb'length / 16 - 1 loop
         wait for 5*MAIN_CLK_PERIOD;
         instr_i  <= instr_tb( (i*2+1)*8 to 7+(i*2+1)*8) & instr_tb( (i*2)*8 to 7+(i*2)*8);
      end loop;
      wait;
      -- wait for 10*MAIN_CLK_PERIOD;
      -- instr_i  <= x"E004"; -- ldi R16, 4
      -- wait for 10*MAIN_CLK_PERIOD;
      -- instr_i  <= x"E016"; -- ldi R17, 6
   end process;
end architecture;
