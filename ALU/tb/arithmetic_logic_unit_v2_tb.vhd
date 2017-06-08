library ieee, my_lib;
use   ieee.std_logic_1164.all,
      ieee.numeric_std.all,
      my_lib.types.all;

entity arithmetic_logic_unit_v2_tb is
end entity;

architecture beh of arithmetic_logic_unit_v2_tb is

   component arithmetic_logic_unit_v2
      port (
        a_i    : in  BYTE_U;
        b_i    : in  BYTE_U;
        op_i   : in  operation_type;
        result : out BYTE_U;
        SREG_i : in  BYTE;
        SREG_o : out BYTE
      );
   end component arithmetic_logic_unit_v2;

   type op_arr_t is array(natural range <>) of operation_type;
   constant op_arr : op_arr_t         := (  SUB, EOR );

   signal a_i    : BYTE_U         := x"05";
   signal b_i    : BYTE_U         := x"02";
   signal op_i   : operation_type := NOP;
   signal result : BYTE_U         := (others => '0');
   signal SREG_i : BYTE           := (others => '0');
   signal SREG_o : BYTE           := (others => '0');

begin

change_inputs_and_operation : process
begin
   change_operations :
      for i in op_arr'range loop
         op_i  <= op_arr(i);
         wait for 2 us;
      end loop;
      wait;
end process;

arithmetic_logic_unit_v2_i : arithmetic_logic_unit_v2
   port map (
     a_i    => a_i,
     b_i    => b_i,
     op_i   => op_i,
     result => result,
     SREG_i => SREG_i,
     SREG_o => SREG_o
   );

end architecture;
