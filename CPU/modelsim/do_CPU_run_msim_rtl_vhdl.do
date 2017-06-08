transcript on
set WORK_DIR "D:/GIT/github/mcu_V3/CPU"
set ALL_DIR "D:/GIT/github/mcu_V3"

vlib rtl_work
vmap work rtl_work

vlib my_lib
vmap rtl_work my_lib

vcom -2008 -work my_lib "${ALL_DIR}/CPU/lib/types.vhd"
vcom -2008 -work work "${ALL_DIR}/CPU/lib/basic/adder.vhd"
vcom -2008 -work work "${ALL_DIR}/CPU/lib/basic/mux2.vhd"
vcom -2008 -work work "${ALL_DIR}/CPU/lib/basic/mux4.vhd"
vcom -2008 -work work "${ALL_DIR}/CPU/lib/basic/signext.vhd"
vcom -2008 -work work "${ALL_DIR}/CPU/lib/basic/reg.vhd"
vcom -2008 -work work "${ALL_DIR}/CPU/lib/basic/regU.vhd"
vcom -2008 -work my_lib "${ALL_DIR}/CPU/lib/instruction_set.vhd"
vcom -2008 -work work "${ALL_DIR}/Instruction_decoder_v2/src/instruction_decoder_v2.vhd"
vcom -2008 -work work "${ALL_DIR}/GPR/src/general_purpose_register_v2.vhd"
vcom -2008 -work work "${ALL_DIR}/CPU/src/CPU.vhd"
vcom -2008 -work work "${ALL_DIR}/ALU/src/arithmetic_logic_unit_v2.vhd"

vcom -2008 -work work "${ALL_DIR}/CPU/work/../tb/CPU_tb.vhd"

vsim -t 1ps -L rtl_work -L work -voptargs="+acc"  CPU_tb

add wave *
add wave -position end  sim:/cpu_tb/uut/GPR/GPR
add wave -position end  sim:/cpu_tb/uut/op
add wave -position 11  sim:/cpu_tb/uut/Rd_addr
add wave -position 12  sim:/cpu_tb/uut/Rs_addr
add wave -position end  sim:/cpu_tb/uut/en
add wave -position end  sim:/cpu_tb/uut/state_reg
add wave -position end  sim:/cpu_tb/uut/immed
add wave -position end  sim:/cpu_tb/uut/we_GPR_l
add wave -position end  sim:/cpu_tb/uut/GPR/GPR
add wave -position end  sim:/cpu_tb/uut/GPR/rd1
add wave -position end  sim:/cpu_tb/uut/ALU/a_i
add wave -position end  sim:/cpu_tb/uut/ALU/b_i
add wave -position end  sim:/cpu_tb/uut/ALU/result
add wave -position end  sim:/cpu_tb/uut/SREG
add wave -position end  sim:/cpu_tb/uut/we_SREG_l
add wave -position end  sim:/cpu_tb/uut/ctl.en.SP
add wave -position end  sim:/cpu_tb/uut/ctl
add wave -position end  sim:/cpu_tb/uut/SP
add wave -position end  sim:/cpu_tb/uut/Rs
add wave -position end  sim:/cpu_tb/uut/Rd
add wave -position end  sim:/cpu_tb/uut/pc_offset
add wave -position end  sim:/cpu_tb/uut/PC_offset_s
add wave -position end  sim:/cpu_tb/uut/SP
add wave -position end  sim:/cpu_tb/uut/SP_next

view structure
view signals
run 1.1 us

radix -unsigned
radix signal sim:/cpu_tb/uut/Rd_addr unsigned
radix signal sim:/cpu_tb/uut/Rs_addr unsigned
wave zoom full
