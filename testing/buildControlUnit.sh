#!/bin/bash

# Verilator command
verilator -Wall --cc --top-module ControlUnit -I./include ./submodules/*.sv ControlUnit.sv --exe ControlUnit_tb.cpp               

# Move to the object directory
cd obj_dir

# Compile with make
make -f VControlUnit.mk

# Run the simulation
./VControlUnit



