set PROJECT_DIR "../"
set LIB_DIR "../lib"

vlib rtl_work
vmap work rtl_work

vlib my_lib
vmap rtl_work my_lib

# my lib
vcom -2008 -work my_lib "$LIB_DIR/types.vhd"
vcom -2008 -work my_lib "$LIB_DIR/instruction_set.vhd"

# basic entities
vcom -2008 -work rtl_work "$LIB_DIR/basic/adder.vhd"
vcom -2008 -work rtl_work "$LIB_DIR/basic/reg.vhd"
vcom -2008 -work rtl_work "$LIB_DIR/basic/regU.vhd"

# top entity
vcom -2008 -work rtl_work "$PROJECT_DIR/src/CPU.vhd"

# tb entity
vcom -2008 -work rtl_work "$PROJECT_DIR/tb/CPU_tb.vhd"

vsim -t 1ps -L my_lib -L rtl_work -L work CPU_tb

add wave *

view structure
view signals
run 10 us

wave zoom full
