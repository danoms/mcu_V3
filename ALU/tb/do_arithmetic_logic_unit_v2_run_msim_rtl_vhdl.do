transcript on

vlib rtl_work
vmap work rtl_work

vlib my_lib
vmap rtl_work my_lib

vcom -2008 -work my_lib {D:/GIT/github/ALU/lib/types.vhd}
vcom -2008 -work my_lib {D:/GIT/github/ALU/lib/instruction_set.vhd}

vcom -2008 -work rtl_work {D:/GIT/github/ALU/src/arithmetic_logic_unit_v2.vhd}

vcom -2008 -work rtl_work {D:/GIT/github/ALU/tb/arithmetic_logic_unit_v2_tb.vhd}

vsim -t 1ps -L my_lib -L rtl_work -L work -voptargs="+acc"  arithmetic_logic_unit_v2_tb

add wave *
view structure
view signals
run 60 us

wave zoom full
radix signal sreg_o binary
radix signal sreg_i binary
radix unsigned
