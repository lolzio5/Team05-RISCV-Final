#!/bin/sh

#cleanup
rm -rf obj_dir
rm -f NewMem.vcd

# run Verilator to translate Verilog into C++, including C++ testbench
verilator -Wall --cc --trace --top-module NewMem -I./include ./Memory/*.sv NewMem.sv --exe NewMem_tb.cpp

# build C++ project via make automatically generated by Verilator
make -j -C obj_dir/ -f VNewMem.mk VNewMem

#run executable simulation file
obj_dir/VNewMem
