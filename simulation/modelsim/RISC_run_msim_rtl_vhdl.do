transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/ganat/Downloads/RISC_Final2.0/RISC/sign_extender_6.vhd}
vcom -93 -work work {C:/Users/ganat/Downloads/RISC_Final2.0/RISC/register_data.vhd}
vcom -93 -work work {C:/Users/ganat/Downloads/RISC_Final2.0/RISC/PriorityEncoder.vhd}
vcom -93 -work work {C:/Users/ganat/Downloads/RISC_Final2.0/RISC/inst_register_data.vhd}
vcom -93 -work work {C:/Users/ganat/Downloads/RISC_Final2.0/RISC/data_extension.vhd}
vcom -93 -work work {C:/Users/ganat/Downloads/RISC_Final2.0/RISC/all_components.vhd}
vcom -93 -work work {C:/Users/ganat/Downloads/RISC_Final2.0/RISC/RISC.vhd}
vcom -93 -work work {C:/Users/ganat/Downloads/RISC_Final2.0/RISC/Shifter.vhd}
vcom -93 -work work {C:/Users/ganat/Downloads/RISC_Final2.0/RISC/Toplevel.vhdl}
vcom -93 -work work {C:/Users/ganat/Downloads/RISC_Final2.0/RISC/alu.vhd}
vcom -93 -work work {C:/Users/ganat/Downloads/RISC_Final2.0/RISC/sign_extender_9.vhd}
vcom -93 -work work {C:/Users/ganat/Downloads/RISC_Final2.0/RISC/reg_file.vhd}
vcom -93 -work work {C:/Users/ganat/Downloads/RISC_Final2.0/RISC/memory.vhd}
vcom -93 -work work {C:/Users/ganat/Downloads/RISC_Final2.0/RISC/instruction_register.vhd}
vcom -93 -work work {C:/Users/ganat/Downloads/RISC_Final2.0/RISC/data_path.vhd}

