# Team-05 RISC-V CPU

## Table of Contents
1. [Directory Information](#1-directory-information)
2. [Design Process](#2-design-process)
   - [Task Allocation](#21-task-allocation)
   - [Style and Naming](#22-style-and-naming)
   - [Note On Custom Logic Types](#23-note-on-custom-logic-types)
   - [Design Principles](#24-design-principles)
3. [About The CPU](#3-about-the-cpu)
   - [Overview](#31-overview)
   - [Single Cycle Architecture](#32-single-cycle-architecture)
   - [Pipelined Architecture](#33-pipelined-architecture)
   - [Limitations](#34-limitations)
4. [Contributing](#4-contributing)
5. [Contact](#5-contact)
6. [Acknowledgements](#6-acknowledgements)

---

<br>

# (1) Directory Information
Directory Organisation Information

# (2) Design Process

## (2.1) Task Allocation

### (2.1.1) Single Cycle CPU
 #### **Arithmetic Logic Unit** 
 - Sam Barber 

 #### **Control**
 - Dima Askarov

 #### **Memory**
  - **Instruction Memory :**
    - Dima Askarov
  - **Data Memory :**
    - Lolezio
    - Dima Askarov 

 #### **Multiplexers**

 #### **Program Counter**

 #### **Testing**

## (2.2) Style and Naming
Content for the Installing subsection...

## (2.3) Note On Custom Logic Types

## (2.4) Design Principles

<br>

---

<br>

# (3) About The CPU

## (3.1) Overview
Content for the Basic Usage subsection...

## (3.2) Single Cycle Architecture
Content for the Advanced Features subsection...

## (3.3) Pipelined Architecture

The pipeline architecture broke down the instruction execution cycle into 5 stages. The stages were chosen as the following : 

**Table ()** : 

---
| Pipe Line Stage |   Name       | Operation |
|-----------------|----------------------------|-------------|
| $F/D_{jb}$   | $Fetch/Decode \ Jump -Branch$  | The instruction is fetched and partly decoded to determine if a branch or jump type (only JAL) instruction is executing. In the case of a branch or jump the required control signals are generated (ie. setting $PC = JTA$) |
| $D$     | $Decode$ | The instruction is fully decoded to generate required control signals. During this stage the source registers are also read on the falling edge of the clock |
| $E$    | $Execute$ | The Arithmetic Logic Unit executes the computation specified by the instruction (includes no computation at all) | 
| $M$    | $Memory$ | In the memory access stage the data memory is either read from or written to given the control signals in the memory stage| 
| $W$ | $Write \ Back$ | The final result chosen between; the Alu output, memory data, Upper immediate, PC+4 and PC + Upper Immediate, is written to the register file on the rising edge of the clock| 

---

<br>

<br>

>*Note that the JALR instruciton is dealt with in the main $DECODE$ stage and only the JAL instruction is resolved in the $F/D_{jb}$ stage.* 

>*This is because, if $JALR$ was to be decoded and acted upon in the $F/D_{jb}$ stage, then a data dependancy between the previous instruction and the $JALR$ source register would require further forwarding all the way back to the $F/D_{jb}$ stage - instead of adding additional hardware and complexity, the choice of leaving $JALR$ for the main $DECODE$ stage was made.* 

>*This means however, that for every $JALR$ instructions, the decode stage has to be flushed and the $JTA$ instruction has to be fetched (giving a waste in a cycle)*

---

<br>

## Key Features

### Hazard Handling


#### Load Data Dependency
- **Issue**: If a load instruction is in the Execute stage (`iInstructionTypeE == LOAD`), and its destination register matches a source register in the Decode stage, a data hazard occurs.
- **Resolution**: The Fetch, Decode, and Execute stages are stalled, and the Execute stage is flushed.

#### Branch Instructions (RAW Hazards)
- **Issue**: Occurs when an instruction in the Decode stage is dependent on the result of an instruction in the Memory stage.
- **Resolution**: Forwarding is applied if there is no load instruction in the Memory stage. If there is a load, the Fetch, Decode, and Execute stages are stalled, and the Execute stage is flushed.

#### General RAW Hazards
- **Issue**: Occurs when a source register in the Execute stage is about to be written in the Memory or Write Back stages.
- **Resolution**: Data is forwarded from the Memory or Write Back stage to the Execute stage.

<br>

#### Forwarding Logic

   | Instruction Stage | Forwarding Condition | Action |
   |-------------------|----------------------|--------|
   | Execute           | Source register in Execute matches destination in Memory/Write Back | Data is forwarded to prevent stall |
   | Decode            | Source register in Decode matches destination in Memory | Data is forwarded for comparison operations |


#### Stall and Flush Logic

   | Instruction Stage | Forwarding Condition | Action |
   |-------------------|----------------------|--------|
   | Execute           |**Load Dependancy :** The instruction in the Execute stage is a load, and it writes to either one of the source registers in the Decode stage  | Pipeline is stalled at the Fetch and Decode stages, and the Execute stage is flushed to avoid using incorrect data. |
   | Decode            | **Branch Data Dependancy :** For branch instructions in the Decode stage, if either of the two source registers are to be written to by an instruction in the Executin stage, | Pipeline is stalled, and the Execute stage is flushed on the next cycle. This gives time for the instruction previously in the Execution stage to reach the Memory stage where the output of the Execution stage can be forwarded to the Decode stage.|

---

<br>

### Static Branch Prediction
---

In an attempt to reduce the CPI of the pipelined CPU and increase its' efficiency, the choice to implement static branch prediction was made. 

<br>

> **Static Branch Prediction :** The CPU will always take the branch if it is to be taken backward (ie. the branch target address is less than the current address). This can improve the processors' performance as 'for' and 'while' loops, which are blocks of code that execute many times, are typically implemented using a branch instruction, thus in a programme utilising loops, the probability that a given branch instruction will indeed branch backwards is higher than the inverse. 

>This means if you predict a branch outcome before the decode stage such that backward branches are always taken, you can save many clock cycles that would be used to flush out the incorrectly fetched instructions.

<br>

To accomodate for static branch prediction, a part of the instruction had to be decoded within the fetch stage to determine if its a branch or jump.

In the case of a branch that is to be taken backwards, the module `JumpBranchHandlerF` would create the branch target address using the current PC value in the fetch stage and the instruction word.


#### Edge Cases and Stalls

In the case that the branch taken backwards resolves to be incorrect (ie. branch was taken backward when it should not have been), the `ComparatorD` module will detect the incorrect prediction by comparing the two source registers of the branch instruction within the main $DECODE$ stage - alongside additional information on the branch prediction made in the fetch stage.

**Listing() :** Example in `ComparatorD` of incorrect branch prediction detection based on the value of source registers and branch decision in the previous stage

```verilog
  case(iInstructionTypeD)

    BRANCH : begin

      case(iJBTypeD)

        BEQ : begin

         // If registers are equal and we didnt take the branch
          if      (iRegData1D == iRegData2D & iTakeJBD == 1'b0) begin 
            oPCSrcD    = 1'b1;
            oFlushD    = 1'b1; 
            oRecoverPC = 1'b0; 
          end 

         // If registers aren't equal and we did take the branch
          else if (iRegData1D != iRegData2D & iTakeJBD == 1'b1) begin 
            oPCSrcD    = 1'b1;
            oFlushD    = 1'b1; 
 //If we have branched when we were not supposed to -> must recover PC of instruction after BEQ
            oRecoverPC = 1'b1;
          end

//This covers the registers being equal and branch being taken or registers being not equal and branch not taken
          else begin 
            oPCSrcD    = 1'b0;
            oFlushD    = 1'b0;
            oRecoverPC = 1'b0;
          end
          
        end
```




## (3.4) Limitations

<br>

---

<br>

# (4) Contributing
Content for the Contributing section...

<br>

---

<br>

# (5) Contact
Content for the Contact section...

<br>

---

<br>

# (6) Acknowledgements

*Acknowledge/credit Peter Cheung and the computer architecture book*
