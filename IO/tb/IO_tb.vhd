library ieee;
use 	ieee.std_logic_1164.all,
		ieee.numeric_std.all;

entity IO_tb is
end entity;

architecture testy of IO_tb is

   component IO
   port (
     clk    : in  std_logic;
     data_i : in  unsigned(15 downto 0);
     data_o : out unsigned(15 downto 0);
     we     : in  std_logic;
     addr   : in  unsigned(15 downto 0);
     pins   : inout std_logic_vector(7 downto 0)
   );
   end component IO;

   signal clk    : std_logic;
   signal data_i : unsigned(15 downto 0);
   signal data_o : unsigned(15 downto 0);
   signal we     : std_logic;
   signal addr   : unsigned(15 downto 0);
   signal pins   : std_logic_vector(7 downto 0);

begin
   IO_i : IO
   port map (
     clk    => clk,
     data_i => data_i,
     data_o => data_o,
     we     => we,
     addr   => addr,
     pins   => pins
   );

end architecture;
