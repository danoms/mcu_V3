transcript on

set PROJECT_DIR "D:/GIT/deleta/SKOLAAAALAMCU/GPR"

vlib rtl_work
vmap work rtl_work

vlib my_lib
vmap rtl_work my_lib

vcom -2008 -work my_lib "$PROJECT_DIR/lib/types.vhd"

vcom -2008 -work rtl_work "$PROJECT_DIR/src/general_purpose_register_v2.vhd"

vcom -2008 -work rtl_work "$PROJECT_DIR/tb/general_purpose_register_v2_tb.vhd"

vsim -t 1ps -L my_lib -L rtl_work -L work -voptargs="+acc"  general_purpose_register_v2_tb

add wave *
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(0)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(1)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(2)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(3)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(4)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(5)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(6)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(7)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(8)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(9)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(10)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(11)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(12)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(13)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(14)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(15)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(16)

add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(26)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(27)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(28)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(29)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(30)
add wave -position end  sim:/general_purpose_register_v2_tb/general_purpose_register_v2_i/GPR(31)

view structure
view signals
run 200 ns

radix hexadecimal
radix signal ra1 unsigned
radix signal ra2 unsigned
wave zoom full
