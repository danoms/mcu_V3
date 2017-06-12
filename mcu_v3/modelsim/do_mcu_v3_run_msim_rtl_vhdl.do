transcript on

vlib rtl_work
vmap work rtl_work

vlib my_lib
vmap rtl_work my_lib

vcom -2008 -work my_lib {../../CPU/lib/types.vhd}
vcom -2008 -work work {../../CPU/lib/basic/signext.vhd}
vcom -2008 -work work {../../CPU/lib/basic/regU.vhd}
vcom -2008 -work work {../../CPU/lib/basic/reg.vhd}
vcom -2008 -work work {../../CPU/lib/basic/mux4.vhd}
vcom -2008 -work work {../../CPU/lib/basic/mux2.vhd}
vcom -2008 -work work {../../CPU/lib/basic/adder.vhd}
vcom -2008 -work work {../../GPR/src/general_purpose_register_v2.vhd}
vcom -2008 -work work {../../instruction_decoder_v2/src/instruction_decoder_v2.vhd}
vcom -2008 -work work {../../CPU/src/CPU.vhd}
vcom -2008 -work my_lib {../../CPU/lib/instruction_set.vhd}
vcom -2008 -work work {../../mcu_v3/src/mcu_v3.vhd}
vcom -2008 -work work {../../mcu_v3/src/instruction_memory.vhd}
vcom -2008 -work work {../../mcu_v3/src/RAM.vhd}
vcom -2008 -work work {../../IO/src/IO.vhd}
vcom -2008 -work work {../../ALU/src/arithmetic_logic_unit_v2.vhd}

vcom -2008 -work work {../../mcu_v3/work/../tb/mcu_v3_tb.vhd}

vsim -t 1ps -L rtl_work -L work -voptargs="+acc" mcu_V3_tb

add wave *
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/FLASH/instr
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/PC_mux_ctl
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/ctl
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/PC_offset_s
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/state_reg
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/ctl_o
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/en
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/op
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/instr_reg
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/FLASH/mem
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/srcA
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/srcB
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/Rd_addr
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/Rs_addr
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/SP
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/data_o
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/data_i
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/addr_o
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/ctl_o
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/ctl
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/GPR/GPR
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/RAM_core/mem
add wave -position 3  sim:/mcu_v3_tb/mcu_v3_i/PC
add wave -position 16  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/aluResult
add wave -position 16  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/immed
add wave -position 17  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/io_addr
add wave -position 25  sim:/mcu_v3_tb/mcu_v3_i/IO_core/addr
add wave -position 26  sim:/mcu_v3_tb/mcu_v3_i/IO_core/addr_reg
add wave -position 27  sim:/mcu_v3_tb/mcu_v3_i/IO_core/data_o
add wave -position end  sim:/mcu_v3_tb/mcu_v3_i/IO_core/IO
add wave -position 3  sim:/mcu_v3_tb/mcu_v3_i/PINB
add wave -position 4  sim:/mcu_v3_tb/mcu_v3_i/DDRB
add wave -position 5  sim:/mcu_v3_tb/mcu_v3_i/PORTB
add wave -position 15  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/skip_en
add wave -position 16  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/cpse_en
add wave -position 21  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/Rs
add wave -position 22  sim:/mcu_v3_tb/mcu_v3_i/CPU_core/Rd
view structure
view signals

run 100 us
radix -unsigned
radix -hexadecimal
radix signal sim:/mcu_v3_tb/mcu_v3_i/CPU_core/PC_offset_s decimal
radix signal sim:/mcu_v3_tb/mcu_v3_i/FLASH/instr hexadecimal
wave zoom full
