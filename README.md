# Team05-RISCV-Final

- Sam: Register File and ALU
- Dima: Control Unit and Instruction Memory and Control
- Lolézio: PC Logic, Data Memory, Top, Assembly Language File
- Meric: Testbench


## PC Logic, Data Memory, Top, Assembly Language File
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

### Assembly Language File
- To develop this, discussed with Dima over how to achieve the desired F1 lighting up sequence by using sub routines
- In the testing folder, assembly.cpp contains C++ code that performs the same logic as the assembly.txt file
  -  This code was first developed to help simplify the assembly code as much as possible
  -  In the main, the output value (vbd_value) is incremented by 1 until it reaches 255
    -  vbd_value corresponds to the value passed to vbdBar() to light up the LEDs
  - Between each increment, a constant wait time is implemented
    - This is done by calling the counter() function, which counts down from a very large number, taking a constant time to execute
      - This essentially acts in having cycles be executed but not change the vbd_value
  - When vbd_value reaches its max value, it must turn off after a random amount of time
    - To do this, the function random_counter() is called
      - It uses the pseudo random method using XOR from Lab 3 to wait a random amount of time
  - After this random amount of time, vbd_value is set to 0, and the lights are off
 
- This same logic was developed in Assembly Language
  - Only 6 different kinds of instructions were used, to simplify the program as much as possible
    - These are: addi, jal, jalr, beq, sll, xor
    - Whenever possible, jal was used instead of beq, as this supports a greater offset range and is more robust
  - In the main, variables are initialized to 0, before calling the main while loop with a JAL instruction
  - In loop, a0, correspondong to vbd_value, is incremented
    -  If it is equal to 255, then branch to turning off after a random time
    -  Else, branch to constant_time, to wait before incrementing again
  -  In constant_time, a counter counts down from a large number. This wastes cycles, to increase the time between the lights
    -  If it's zero, return to loop. Else, continue counting down
  -  In random_time, first a subroutine is started, to find a pseudo random number
    -  This performs the same pseudorandom logic detailed in Lab 3.
    -  The JALR instruction then returns to random_time, 1 instruction later than where it was left of
    -  The random result is left shifted a number of times to increase its value (so more time will be wasted)
    -  Then, it is counted down from this number. When the counter is 0, branch to end, which turns off the lights and ends the program
    -  Else, move up 2 instructions using JALR to continue decrementing the counter
- This was then translated to machine code using an [online assembler]([(https://riscvasm.lucasteske.dev/#)])
  - The resulting machine code is stored in instructions.mem, to be loaded by the Instruction ROM