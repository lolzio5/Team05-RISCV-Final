# RISC-V RV32I Processor Coursework

___

# Personal Statement of Contributions
### Lolézio Viora Marquet - _November-December 2023_
<br>

___

# Table of contents
1. [PC Logic](#1-pc-logic)
2. [Data Memory](#2-data-memory)
3. [Instruction Memory](#3-instruction-memory)
4. [Top file](#4-top-file)
5. [F1 Program](#5-f1-program)
6. [Vbuddy Functionality](#6-vbuddy-functionality)
7. [Pipelining](#7-pipelining)
8. [Makefile and Shell script](#8-makefile-and-shell-script)
9. [Conclusion and Reflection](#9-conclusion-and-reflection)

<br>

___

## 1 - PC Logic
### PC Register   [PCRegister.sv](PCRegister.sv)

<br>

I made the PC Register in Lab 4, and only had to slightly modify it for this RV32I version. The PC Register works by taking it the next PC value, and outputting it in the next clock cycle. To simplify the processor, I combined the multiplexer pcmux.sv that I had written in Lab 4 with the PC Register, so that the next PC value (the next word in memory, or a jump forward or backward) is chosen depending on PCSrc (from the control unit) directly.

<br>

The next PC value, outputted in the next clock cycle, is determined as follows in PC Register:

| PCSrc | PCNext |
|-------|--------|
|   0   | PC + 4 |
|   1   |PCTarget|

PC Target is itself determined in another block part of the PC logic, the PC Adder as seen below.

<br>

### PC Adder   [PCAdder.sv](PCAdder.sv)

<br>

As this processor required a little more logic, PC Adder was extended to accomodate the register offset that arises when Jump And Link Register (JALR) instructions are executed. PC Adder by default adds the immediate ImmExt to the current PC value to output PCTarget. However, when the instruction is JALR, it also adds the register offset value, and sets the last two bits of PCTarget to 0, to ensure the value is always a multiple of 4. 
<br>

This logic was implemented in partnership with Dima Askarov. I created the files and the initial logic, and once the Control Unit (which he designed and implemented) was fully functional, he was able to connect it to the PC Logic, modifying it with the new signals.

<br>

I extensively tested this functionality by writing the testbench [pc_tb.cpp](pc_tb.cpp) with a shell script.

<br>

___

## 2 - Data Memory 
### Data Memory   [DataMemory.sv](DataMemory.sv)

<br>

I initially designed and implemented the Data Memory to modify a simple ROM into RAM, by allowing to write into it when the write_enable signal was high. This allowed to write and retrieve data in general, but was not instruction specific. Once the Control Unit was operational, Dima Askarov modified the Data Memory to be able to load full or half words, and single bytes into memory, depending on the instructions.

<br>

### Result Multiplexer [ResultMux.sv](ResultMux.sv)
<br>

Taking the output of the Data Memory, I designed and implemented the output multiplexer, depending on ResultSrc. The original version, similar to that of Lab 4, followed the following logic:

<br>

| ResultSrc |  Result  |
|-----------|----------|
|     0     |  ALUOut  |
|     1     | DataRead |

<br>

The result of an arithmetic operation, or data, could therefore be stored back into the register file, our outputted in a0.

However, this would not work for jumps, which need to store the location of the next word in memory, so that the JALR instruction can be used to return from a subroutine. As such, ResultSrc itself is extended to 3 bits (see the Control Unit), to implement the following logic:

<br>

| ResultSrc |  Result  |
|-----------|----------|
|    000    |  ALUOut  | - Result of an arithmetic operation
|    001    | DataRead | - Load data from memory
|    010    |  PC + 4  | - Store the address of the next instruction word (when jumping)
|    011    |  ImmExt  | - Load an Immediate
|    100    | PC+ImmExt| - Store the address of an instruction word after a jump

<br>

I extensively tested this functionality by writing the testbench [mem_tb.cpp](mem_tb.cpp) with a shell script.

<br>

___

## 3 - Instruction Memory 
###  Instruction Memory   [InstructionMemory.sv](InstructionMemory.sv)
<br> 

My contribution to the Instruction Memory was to automate the process of loading instructions, so that the file could be passed as an argument, and loaded. While this has no direct impact on the function of the processor, it saved large amounts of time with testing and debugging. 
<br>

I did this by declaring the function load_program as such:
```
 function void load_program(string file_name);
          $readmemh(file_name, rom_array);
  endfunction
```
The Instruction Memory block is then passed the file name as a signal, which is used as the address out of which the instructions are loaded into the ROM array. 
<br>

___

## 4 - Top File
### Top File   [top.sv](top.sv)
<br>

My first contribution to the Top file was writing a first draft, connecting all modules together for initial testing and debugging, and ensuring all inputs and outputs were consistent throughout, as well as signal widths. As the project progressed, I regularly updated the Top file, for example by adding functionality to automatically load the correct file into memory (see above). The Top file for this project was regularly updated by all members.

<br>

___

## 5 - F1 Program
### C++ Program   [assembly.cpp](assembly.cpp)
<br>

To get started on designing and implementing the F1 Program in Assembly, I wrote an implementation in C++.
The program works as follows:
<br>

Initial Setup:
1. Set up all values.
<br>

Main loop:<br>
2. Increment the output value by 1.<br>
3. Call Constant Time loop.<br>
4. If the output is 255, call Random Time loop.<br>
5. Else, return to Step 2.<br>
6. Set the output to 0.<br>
<br>

Constant Time:<br>
7. Decrement a large value by 1.<br>
8. If the large value is 0, return to step 4. <br>
9. Else, return to step 6.<br>
<br>

Random Time:<br>
10. Generate a 4 bit number.<br>
11. XOR its 3rd and 4th bits, and store the result as the first bit.<br>
12. Decrement the number by 1.<br>
13. If the number is 0, return to Main, step 6.<br>
14. Else, return to step 10.<br>
<br>

This code essentially calls for loops which waste cycle, introducing a constant timer. A pseudorandom sequence is generated, as in Lab 3, to introduce a random timer once all lights are on, before they turn off. This code was tested, to ensure the expected behavior was achieved.

<br>

### F1 Assembly Program For Single Cycle Processor [F1Single.s](F1Single.s)
<br>

The actual implementation of the F1 Program in Assembly is very similar to the above C++ code, following the same logic. A first modification was so the output on the Vbuddy lights increased sequentially, and stayed on (instead of turning off the lower numbers). This was simply done by shifting the output left before incrementing by 1:
```
    sll     a0, a0, 1
    addi    a0, a0, 1
```
This has the effect of ensuring the output a0 fills up withs 1s, so that the lights of the Vbuddy stay on. 
<br>

A second modification was to test the functioning of the JAL and JALR instructions, a subroutine was introduced, by splitting the logic of Random Time into two parts:
<br>

#### Random Time Part 1: random_time
<br>
When a random time must be wasted, the program jumps to random_time. Immediately, it jumps again to random_logic, which outputs a pseudorandom number (see below):

```
    jal     ra, random_logic
```
This number is then decremented, as before in the C++ code:

```
    addi    s1, s1, -1
```
If s1 is then equal to 0, a branch is taken, to a new section named End which contains the logic to end the program. Else, continue looping to decrement the pseudorandom number further:

```
    beq     s1, zero, end
    jalr    x0, ra, 0
```
<br>

#### Random Time Part 2: random_logic
<br>
To output a pseudorandom number, this subroutine is called. For easier bitwise operations, I decided to store each bit of the 4 bit pseudorandom number in 4 separate registers, which are then recombined by adding them together, after shifting the result left once. This result is stored in a register which is accessed by random_time above. Finally, an XOR operation is performed on bits 3 and 4, the result of which is stored in place of the first, most significant bit. 
<br>

- Advantages of this method
    - The next time the random_logic subroutine is called, the output will be a very different number
        - Could be greater or smaller
        - Impossible to predict how it will change without seeing the individual bits
    - Always requires a constant number of cycles to execute
    - Comes at a relatively cheap cost and ease of implementation
- Disadvantages of this method
    - The pseudorandom sequence is the same everytime the processor is restarted
        - Impossible to store past values after the processor is turned off, because memory is flushed
    - Requires 5 different registers
    - Uses 10 cycles to complete

<br>

Once a pseudorandom number has been generated, the JALR instruction is used to return to the random_time loop:

```
    jalr    x0, ra, 0
```

Here, the return address is not needed, and so written to the unwritable register x0. No offset is needed, as JAL automatically stores the address of the next line (to prevent infinite loops).
<br>

### F1 Assembly Program for Pipelined Processor [F1.s](F1.s)
For the Single Cycle CPU, the order in which the loops were written was unimportant, as jumping forward or backward used the same number of instructions. However, the Hazard Handling Unit was designed in such a way that jumping back is always taken, before additional logic determines whether that was the correct decision, or whether to return to the next instruction. If returning to the next instruction, the program must stall for one cycle. 

<br>
Therefore, cycles can be saved by ensuring the program jumps back as often as possible, rather than jumping forward. 
The order of the loops was changed to improve the number of cycles used to complete the program, as evidenced in the table below:
<br>

#### Keeping order the same
For an output counting up to 15, and for a counter of length 15

|     Order        |  Number of Cycles |
|------------------|-------------------|
|      1. Main     |         7         |
|      2. loop     |        25         |
| 3. constant_time |        40         |
|  4. random_time  |   4*random value  |
|  5. random_logic |        10         |
|      6. end      |         2         |
<br>

#### Improving the order
For an output counting up to 15, and for a counter of length 15
|     Order        |  Number of Cycles |
|------------------|-------------------|
|      1. Main     |         7         |
| 2. constant_time |        25         |
|     3. loop      |        25         |
|  4. random_time  |   4*random value  |
|      5. end      |         2         |
| 6. random_logic  |        10         |
<br>

In this way, 15 fewer cycles are needed for an output counting to 15. Setting it to count to 255 would multiply this by 17, meaning 255 more cycles would be needed. This is the most efficient program, because all branches in the (loop, random_time, constant_time) are made to branch forward and not backwards. This means that they do not automatically occur, saving 1 cycle of stalling each time the loop is iterated.

___

## 6 - Vbuddy functionality
### Top Testbench [top_tb.cpp](top_tb.cpp) 
<br>

To test the F1 program, I wrote a testbench that is able to output the result on Vbuddy. To ensure a fair test, the testbench has as little logic as possible, directly passing the output of the processor in a0 in the vbdBar() function, to be displayed on the LED bar:
```
    vbdBar(top->oRega0);
```
<br>

To simplify testing, as mentioned before, I automated the process of loading instructions into the memory ROM, by creating a function. The name of the file to be loaded is passed by the Shell script (see below), and extracted by the C++ testbench with:
```
    std::string programFileName = argv[1];
    top->iFileName = programFileName;
```
<br>

Since the same testbench is used for any program, the header on the screen of Vbuddy must also change when the program is changed. The output will always be outputted on the screen and the LEDs. Therefore, I implemented in C++ that the name of the program is automatically displayed on the screen, without the file extension.

___

## 7 - Pipelining
### fs

___

## 8 - Makefile and Shell Script
### Makefile [Makefile](Makefile)
<br>

I debugged the provided Makefile so it would be able to build our Assembly files in .s format into the required, .hex format, ensuring it would find the right files. The Makefile itself uses the GNU Toolchain Assembler to output a .hex file, calling the format_hex.sh script.
<br>

### Shell Script [buildCPU.sh](buildCPU.sh)
<br>

I wrote the overall build script buildCPU.sh so that it can compile all files together and verilate the simulation. It declares the top.sv module as top with the flag --top-module, and executes the simulation with the top_tb.cpp testbench.
<br>

The Shell script also checks for an input filename, to be passed on to the testbench itself, with the statement:
```
    if [ $# -eq 0 ]; then
        echo "Usage: $0 <program_filename>"
        exit 1
    fi
```

___

## 9 - Conclusion and Reflection
### Conclusion
<br>

To conclude, I believe my contributions were essential in the project. My rapid implementation of the pipelining ensured that the hazard handling could be thoroughly tested, while my development of a robust F1 Assembly Program, along with its testbench, Makefile, and Shell script, allowed the group to test the Single Cycle as well as the Pipelined CPU effectively. I actively attempted to complete my tasks as fast as possible, to ensure that other teammembers could build off my work, and were never delayed due to my parts taking too long to complete. 
<br>

I believe another aspect where I was crucial in the team is in terms of organising meetings and spreading work. Attempting to find times that were ideal for everyone, I actively made the team meet more often, so we could discuss next steps, debug together, and assign the work equally and efficiently. Despite facing numerous hurdles, I attempted to keep the team as positive as possible, congratulating for work well done, and showing support and help at roadblocks.
<br>

### Reflection
<br>

There are a number of ways I could have improved my designs, as well as my efficiency while completing this project. 
<br>

#### Efficiency
I had to spend large amounts of time improving the consistency of the naming conventions throughout the design. Next time, I will come up with naming convention rules before starting to write, and discuss with teammates, so we all use the same ones. My organisation throughout the project was not as optimal as I would have liked, as I was rather new to using Github. As such, a few times, I got lost between branches, and lost unsaved work by stashing out of a branch, before committing to the remote repo. 
<br>

#### Design
My original implementation of the PC Logic and Data Memory proved to be insufficient for the given project, and so had to be heavily modified so it could work with the Control Unit. Next time, I will more thoroughly document myself on the specifics of the architecture, and spend more time planning on what logic needs to be executed. This must be discussed more with teammates as well, to ensure that our work is easy to combine into one. This planning will improve the quality of designs, while saving time in the long run.
<br>

The Assembly Program itself could be improved. For example, the pseudorandom binary sequence is of the form:
>$1 + X^3 + X^4$
<br>
This means it repeats every $2^4 -1 = 15$ iterations, and so the sequence only possesses 15 values. For the sake of testing the CPU, this is sufficient, however, should this program be used in a real Formula 1 race, the time would be far too predictable, and a higher order PRBS would be more optimal (which would only cost more registers).
<br>

### Final Remarks
I have thoroughly enjoyed working on this project, overcoming a number of challenges, and pushing my knowledge of RISC-V hardware design, SystemVerilog, C++, Assembly and Shell script. I believe I am now more equipped in my future career as a software engineer, while having improved my soft skills by working in a team, and coordinating a complex project with a tight deadline.
