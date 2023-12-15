# Team05-RISCV-Final

_Written by Lolézio Viora Marquet_

This branch contains a fully working Single Cycle CPU in SystemVerilog.

A number of programs are available to use, including F1Single.s, which is the F1 Lights Program for the Single Cycle CPU (it was later made more efficient for a pipelined processor). These can be found in [Testing/Assembly.](https://github.com/lolzio5/Team05-RISCV-Final/tree/43438d88a74539a64d21b76d2120f6fc34ffb4e6/Testing/Assembly)

<br>

However, if you want to assemble your own program, it is possible to assemble them and generate a hex file:

- Upload a .s file to the [Testing](https://github.com/lolzio5/Team05-RISCV-Final/tree/43438d88a74539a64d21b76d2120f6fc34ffb4e6/Testing) folder
- Open this folder with ``` cd Testing ```
- Run ``` make FileName.s```
- Move the generated .hex file to [rtl](https://github.com/lolzio5/Team05-RISCV-Final/tree/43438d88a74539a64d21b76d2120f6fc34ffb4e6/rtl)

To run the program on Vbuddy, and have the output be displayed by the LED Bar, then simply run
```
cd rtl
source buildCPU.sh FileName.s
```

> Note that if you wish to upload your own data to data memory, you will need to provide the path to your file in [DataMemory.sv](https://github.com/lolzio5/Team05-RISCV-Final/blob/43438d88a74539a64d21b76d2120f6fc34ffb4e6/rtl/Memory/DataMemory.sv) (see README.md on the Main Branch for more instructions)

If you wish to display on other parts of Vbuddy, you will need to edit [top_tb.cpp](https://github.com/lolzio5/Team05-RISCV-Final/blob/43438d88a74539a64d21b76d2120f6fc34ffb4e6/rtl/top_tb.cpp).

> Note you may need to change [vbuddy.cfg](https://github.com/lolzio5/Team05-RISCV-Final/blob/43438d88a74539a64d21b76d2120f6fc34ffb4e6/rtl/vbuddy.cfg) with the path to the USB Port Vbuddy is connected to





