library ieee, my_lib;
use   ieee.std_logic_1164.all,
      ieee.numeric_std.all,
      my_lib.types.all;

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
   				-- we_RAM   : out std_logic;
   				-- we_IO    : out std_logic;
               --
   				-- ctl_data : out std_logic
               ctl_o 	: out ctl_t
               ); -- data_i <- RAM ? IO
   end component;

   signal clk      : std_logic   := '0';
   signal rst      : std_logic   := '0';
   signal PC_o     : unsigned(15 downto 0)   := (others => '0');
   signal instr_i  : std_logic_vector(15 downto 0)   := (others => '0');
   signal data_o   : unsigned(15 downto 0)   := (others => '0');
   signal data_i   : unsigned(15 downto 0)   := (others => '0');
   signal addr_o   : unsigned(15 downto 0)   := (others => '0');
   signal i : integer;
   signal ctl_o   : ctl_t;
   constant instr_tb : std_logic_vector := x"09C00EC00DC00CC00BC00AC009C008C0" &
                                             x"07C006C011241FBECFE9CDBF02D024C0" &
                                             x"EFCFCF93DF93CDB7DD27C650CDBF88EC" &
                                             x"90E09A83898381E990E09C838B831E82" &
                                             x"1D828D819E81892B31F08D819E810197" &
                                             x"9E838D83F6CF29813A818B819C81820F" &
                                             x"931F9E838D83EDCFF894FFCF";
-- constant instr_tb : std_logic_vector := x"0EEF17E0412F302F340F411F11271027" &
   --                                           x"1F5F0A4002C001D000004F933F9300D0" &
   --                                           x"04BB0F911F914931C4F3" &
   --                                           x"00000000000000000000000000000000000000";

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
   				-- we_RAM   => we_RAM,
   				-- we_IO    => we_IO,

   				-- ctl_data => ctl_data
               ctl_o    => ctl_o); -- data_i <- RAM ? IO

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
   i  <= to_integer(PC_o);
   instr_i  <= instr_tb( (i*2+1)*8 to 7+(i*2+1)*8) & instr_tb( (i*2)*8 to 7+(i*2)*8);
   -- instr_in : process(all)
   -- begin
   --    -- for i in 0 to instr_tb'length / 16 - 1 loop
   --       -- wait for 5*MAIN_CLK_PERIOD;
   --       instr_i  <= instr_tb( (i*2+1)*8 to 7+(i*2+1)*8) & instr_tb( (i*2)*8 to 7+(i*2)*8);
   --    -- end loop;
   --    -- wait;
   --    -- wait for 10*MAIN_CLK_PERIOD;
   --    -- instr_i  <= x"E004"; -- ldi R16, 4
   --    -- wait for 10*MAIN_CLK_PERIOD;
   --    -- instr_i  <= x"E016"; -- ldi R17, 6
   -- end process;
end architecture;
