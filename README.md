# Team05-RISCV-Final

- Sam: Register File and ALU
- Dima: Control Unit and Instruction Memory and Control
- Lolézio: PC Logic and Data Memory and Top
- Meric: Testbench


## PC Logic, Data Memory, Top
_Completed by Lolézio Viora Marquet_

### PC Logic
- Created two files, pcreg.sv and pcmux.sv. pcreg.sv acts as the top file, so it can be directly connected in the overall top file for the processor
  - **pcreg.sv**
    - Clocked, and connected to rst, so when it is true, PC is set back to 0.
      - Can easily be connected to the trigger, for when the processor is launched.
    - Passes the sign extended immediate ImmExt to the subfile pcmux.sv
    - On the rising edge of the clock, outputs the value of PC, which was calculated using the old value
      - This has the purpose of being able to move through the instructions
        - PC is used as the address in the adjacent Instruction Memory block
        - When PC is increased by 4, the next line in memory will be read (RISC-V instructions are 4 bytes)
        - When PC is increased by the immediate ImmExt, a jump occurs, jumping to whichever line the instruction is stored
        -   This will always be a multiple of 4
  - **pcmux.sv**
    - The above 2 possible next PC values, PC+4 or PC+ImmExt are determined by this mux.
      - When the input PCSrc is 1, PC must take the value PC+ImmExt
      - When the input PCSrc is 0, PC must take the value PC+4
This was tested for positive ImmExt values using the testbench pc_tb.cpp and the command file doit_pc.sh found in the testing folder.

### Data Memory
- Created two files, datamem.sv and datamux.sv. datamem.sv acts as the top file, so it can be directly connected in the overall top file for the processor
  - **datamem.sv**
    - Creation of clocked RAM to store data
      - The RAM was made to have $2^10$ locations, which is more than necessary, but ensures there will always be enough.
      - All other data was given widths of 32 bits, as consistent with RISC-V 32 bit architecture.
      - Takes in the Write Address A, outputted from the ALU.
        - If the write enable WE is true, the data WD is written at RAM Address A.
        - If WE is false, the data at RAM Address A is read into RD.
  - **datamux.sv**
    - Chooses whether to output the stored data at Address A, or simply output A (to read the data at A in the register file)
      - If ResultSrc is true, then the Result (which is then written in the register file) is RD.
      - If ResultSrc is false, then the Result is simply A.
    - This functionality allows the processor to read the data out of memory, and use it within registers, or store addresses in registers when Jumps occur
This was tested for all possible cases using the testbench mem_tb.cpp and the command file doit_mem.sh found in the testing folder.

### Top
- Created a single file to be directly interfaced with the testbench. Connects all 3 submodules together to ensure everything can run smoothly
  - **top.sv**
    - Connect the different parts with different names into one coherent unit
    - Detected a number of bugs, and outputs/inputs that should be taken care of within the modules
    - Forced consistency with different bus widths






