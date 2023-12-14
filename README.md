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



## (1.0) Repository Branch Descriptions : 

The tables below describes the usage of various branches for development and deployment purposes


**Table(1.0.1) :** Assessed/Deployment Repository Branches

---
| Branch |  Purpose | Verified Functionality |
|----------|-------------|----------|
| Single-Cycle-CPU  | Holds the files corresponding to the Single Cycle implementation of the CPU  |  Fully Tested and Verified|
| Pipelined-CPU    | Holds the files corresponding to the Pipelined version of the CPU that implements static branch prediction and hazard handling | Majority Tested and Verified|
|  Cache_And_Pipeline   | Holds the files corresponding to the Pipelined CPU with an additional Data Cache Impelmentation | Partly Tested and Verified| 
| main    | Holds repository information | |

---

<br>

**Table(1.0.2) :** Development Purpose Repository Branches

---
| Branch |  Purpose | Verified Functionality |
|----------|-------------|----------|
| Control-Unit  | Holds the files corresponding to the Single Cycle implementation of the CPU  |  Fully Tested and Verified|
| control-unit   | Holds the files corresponding to the Pipelined version of the CPU that implements static branch prediction and hazard handling | Majority Tested and Verified|
|  compiling-solution   | Holds the files corresponding to the Pipelined CPU with an additional Data Cache Impelmentation | Partly Tested and Verified| 
| Pipeline-Architecture-Dev    | Holds repository information | |

---


## (1.1) Directory Organisation : 

```
-rtl
--Control
```


# (2) Design Process

## (2.0) Task Allocation

### (2.0.1) Single Cycle CPU
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

<br>

## (2.1) Design Principles

The driving design principles throughout the development of components for the Single Cycle CPU and the Pipelined CPU were the following :

>- **Modularity** : Components were broken down into specialised units that performed a singluar or a limited set of tasks

>- **Ease of intergration and development** : The ability to easily integrate sub modules together was always a key consideration during design and development

>- **Transparency of operation** : The ability to easily interpret and understand the operation of modules and sub-modules was the main consideration when implementing them. The implications of this approach on the efficiency and cost of the design is explored in *Limitations*

<br>

## (2.2) Style and Naming

In order to allow quick and clear development, naming conventions and styles were upheld throughout the design and development of modules. The naming conventions and styles used in this project are listed below

**Table (2.2.1)** : Style and Naming Conventions

---
| Subject |  Style/Naming Guide | Example |
|----------|-------------|----------|
| Module Names   | CamelCase and Pipeline Stage Identifier Suffix (To indicate in which pipeline stage the module operates $(F,D,E,M,W)$)  |  `ControlPathD` - Control Path Module in the Decode Stage|
| Input Signals     | CamelCase, Input Identifier Pre-Fix and Optional Pipeline Stage Operation Suffix |   `iInstructionTypeE` - An input of Instruction type from the execution stage  <br> `iClk` - Clock signal input|
| Output Signals    | CamelCase, Output Identifier Pre-Fix and Optional Pipeline Stage Operation Suffix  | `oRecoverPC` - Output Flag to Indicate Incorrect Branch <br> `oTakeJBD` - Output Flag into the Decode stage to indicate that a jump/branch has been taken  | 
| Internal Logic Signals    | Snake case with a Pipeline Stage Identifier Suffix (only in top sheet) | `instruction_type_e` - Type of Instruction Executing in the Execute Stage <br> `reg_data_in_w` - Data Written Back Into Register File From the Write-Back Stage | 
| Pipeline Register Naming| CamelCase with a Pipeline Stage Identifier Prefix and Suffix| `DPipelineRegisterE` - Pipeline Register Taking Signals From Decode Stage and Outputing Them Into The Execution Stage |

---

## (2.3) Note On Custom Logic Types

To increase the readability of modules and make their operation more transparent and understandable, frequently used control and data signals were encoded into custom logic types using enums and unions. 

These logic types are defined in the 'ControlTypeDefs.svh' file that is included in each module that utilises the respective logic types - shown in **Listing (1.2.1)**.

**Listing (2.3.1)** : Include header example

```verilog
`include "include/ControlTypeDefs.svh" //Include Header
```

<br>

**Table (2.3.1)** Shows the definition of the enum InstructionTypes. This enum was used to store the type of instruction executing as decoded by the control unit. Using this enum made the modules easier to understand as the viewer could easily tell what specific instruction would trigger a given set of outputs. 

**Table (2.3.2)** : Enum - InstructionTypes Definition

---
| InstructionTypes[3:0] |  Enum Value | Note |
|----------|-------------|----------|
| BRANCH   | 0000  | **Branch Instruction** (b-type)|
| LOAD     | 0001 | **Load Instruction** (i-type) |
| STORE    | 0010 | **Store Instruction** (s-type) | 
| UPPER    | 0011 | **Upper Instruction** (u-type)| 
| IMM_COMPUTATION | 0100 | **Register-Immediate Computation** : An instruction that performs logical/arithmetic operations on an immediate and register value | 
| REG_COMPUTATION | 0101 | **Register-Register Computation** : An instruction that performs logical/arithmetic operations on two register values  | 
| JUMP    | 0110 | **Jump Insturction** (j-type) | 
| NULLINS | 1111 | **NULL** : Used to represent 'no-instruction'. Helps determine when the decoding of a given isntruction word has failed |
---

<br>


To further classify a given instruction, a union InstructionSubType was implemented. At any given time, this union would take on the value of an enum type representing the specific instruction sub type. The definition of the 'TypeR' enum is shown in **Table (2.3.4)** as example. For the case of an r-type class of instructions, the InstructionSubTypes union would take on the enum value of the specific r-type instruction.

<br>

**Table (2.3.3)** : Enum - TypeR Definition

---
| TypeR[3:0] |  Enum Value | Note |
|----------|-------------|----------|
| ADD   | 0000  | **Register Addition** |
| SUB   | 0001 | **Register Subtraction** |
| SHIFT_LEFT_LOGICAL | 0010 | **Logical Shift Left** | 
| SET_LESS_THAN      | 0011 | **Set Less Than** | 
| USET_LESS_THAN     | 0100 | **Set Less Than Unsigned** |
| XOR | 0101 | **Bit-Wise XOR of Register Operands** | 
| SHIFT_RIGHT_LOGICAL | 0110 | **Logical Shift Right**  | 
| SHIFT_RIGHT_ARITHMETIC    | 0111 | **Arithmetic Shift Right** | 
| OR | 1000 |**Bit-Wise OR of Register Operands** |
| AND    | 1001 | **Bit-Wise AND of Register Operands** | 
| NULL_R    | 1111 |  **NULL** : Used to represent 'no-instruction'. Helps determine when the decoding of a given isntruction word has failed | 
---

<br>


**Table (2.3.4)** : Union - InstructionSubTypes Definition

---
| InstructionSubTypes[3:0] | Value |
|----------|----------|
| TypeR    | **Register-Register Instruction Type** |
| TypeI    | **Register-Immediate Instruction Type** |
| TypeU    | **Upper Instruction Type** | 
| TypeS    | **Store Instruction Type** | 
| TypeJ    | **Jump Instruction Type** |
| TypeB    | **Branch Instruction Type** | 
| NULL     | **NULL :** Helps determine when decoding the instruction sub type has failed  |  
---

<br>

**Listing(2.3.2) :** Example of instruction type and sub type assignment in InstructionDecode module given the instructin OpCode, funct3 and funct7 values

```verilog
  TypeR r_type;
  TypeI i_type;
  TypeU u_type;
  TypeS s_type;
  TypeJ j_type;
  TypeB b_type;

  InstructionTypes instruction_type;

always_comb begin
  case(iOpCode)

      7'd51 : begin
        instruction_type = REG_COMMPUTATION;
        
        i_type = NULL_I;
        u_type = NULL_U;
        s_type = NULL_S;
        j_type = NULL_J;
        b_type = NULL_B;
        
        case(iFunct3)

          3'b000  : begin
            if      (iFunct7 == 7'b0000000) r_type = ADD;
            else if (iFunct7 == 7'b0100000) r_type = SUB;
            else                            r_type = NULL_R;
          end

          3'b001  : r_type = SHIFT_LEFT_LOGICAL;
          3'b010  : r_type = SET_LESS_THAN;
          3'b011  : r_type = USET_LESS_THAN;
          3'b100  : r_type = XOR;
          
          3'b101  : begin
            if      (iFunct7 == 7'b0000000) r_type = SHIFT_RIGHT_LOGICAL;
            else if (iFunct7 == 7'b0100000) r_type = SHIFT_RIGHT_ARITHMETIC  ;
            else                            r_type = NULL_R;
          end

          3'b110  : r_type = OR;
          3'b111  : r_type = AND;    

        endcase
      end

  endcase
end
```

<br>

**Listing(2.3.4) :** Example usage of InstructionTypes enum and InstructionSubTypes union in producing control signals

```verilog
  always_comb begin

    //Initialise Output Signals
    oRegWrite   = 1'b0;
    oAluSrc     = 1'b0;
    oPCSrc      = 1'b0;
    oResultSrc  = 3'b000;
    oMemWrite   = 1'b0;

    case(iInstructionType)

      REG_COMMPUTATION : oRegWrite = 1'b1;


      IMM_COMPUTATION  : begin
        oRegWrite = 1'b1;
        oAluSrc   = 1'b1;
      end


      LOAD   : begin
        oRegWrite  = 1'b1;
        oResultSrc = 3'b001;
      end


      UPPER  : begin
        if (iInstructionSubType == LOAD_UPPER_IMM) begin
          oRegWrite  = 1'b1;
          oAluSrc    = 1'b1;
          oResultSrc = 3'b011;
        end

        else begin
          oResultSrc = 3'b100;  //Data written to register will come from the PC adder
          oPCSrc     = 1'b0;    //PC increments by 4
        end
      end
```

<br>


---

<br>

# (3) About The CPU

## (3.1) Overview

**Table(3.1.1) :** Implemented Instructions

---
| Instruction Type | Implemented Instructions|
|------------------|-------------------------|
| R-Type | Add, Sub <br> Logical Shift Left <br> Set Less Than, Set Less Than Unsigned <br> XOR <br> Shift Right Logical, Shift Right Arithmetic <br> OR  <br> AND  |
| I-Type | Load Byte, Load Half, Load Word <br> Load Byte Unsigned, Load Half Unsigned <br> Add Immediate <br> Logical Shift Left Immediate <br> Set Less Than Immediate, Set Less Than Immediate Unsigned <br> XOR Immediate <br> Shift Right Logical Immediate, Shift Right Arithmetic Immediate <br> OR Immediate <br> AND Immediate|
| U-Type | Load Upper Immediate <br> Add Upper Immediate PC |
| S-Type | Store Byte, Store Half, Store Word <br> Store Byte Unsigned, Store Half Unsigned|
| J-Type | Jump And Link <br> Jump And Link Register| 
| B-Type | Branch Equal To <br> Branch Not Equal To|

---

<br>

> *The decision to leave out the other branch instructions was made to reduce the complexity of the CPU. If accurate implementations of other branch instructions were to be made, like BGE, the use of additional flags that indicate arithmetic overflow may have been needed to determine the branch condition outcome.*

---

<br>


## (3.2) Single Cycle Architecture

Our implementation of the single cycle CPU is split in 5 main stages. 

**Table ()** : 

---

|      Stage      |  Operation | Relevant files |
|-----------------|----------------------------|-------------|
|      $Fetch$    | The Program Counter is incremented by the right amount, so that the correct next instruction is fetched |[PCAdder.sv](PCAdder.sv)   [PCRegister.sv](PCRegister.sv) [InstructionMemory.sv](InstructionMemory.sv)|
|      $Decode$   | The instruction is fully decoded to generate required control signals. During this stage the source registers are also read on the falling edge of the clock | [AluEncode.sv](AluEncode.sv) [ControlDecode.sv](ControlDecode.sv)  [ControlPath.sv](ControlPath.sv)  [ControlUnit.sv](ControlUnit.sv)  [ImmDecode.sv](ImmDecode.sv)  [InstructionDecode.sv](InstructionDecode.sv) [RegisterFile.sv](RegisterFile.sv) |
|     $Execute$   | The Arithmetic Logic Unit executes the computation specified by the instruction (includes no computation at all) | [Alu.sv](Alu.sv) |
|      $Memory$   | In the memory access stage the data memory is either read from or written to given the control signals in the memory stage| [DataMemory.sv](DataMemory.sv) |
|      $Write$    | The final result chosen between; the Alu output, memory data, Upper immediate, PC+4 and PC + Upper Immediate, is written to the register file on the rising edge of the clock| [ResultMux.sv](ResultMux.sv) |

---

### (3.2.1) Fetch Stage
#### (3.2.1.1) PC Register
The Fetch stage begins with the output of the next PC value, so that the next instruction can be fetched. This is implemented in [PCRegister.sv](PCRegister.sv) with the line:
```verilog
   if (iPCSrc == 1'b0) PCNext = iPCSrc ? iBranchTarget : oPC + 32'd4;
```
Depending on the value of PCSrc, the next PC value is either PC + 4 or PC + ImmExt (calculated as BranchTarget. PC + 4 would simply indicate the next instruction, since each 32 bit instruction word is stored in 8 memory locations, as seen below:

**Table ()** : 

---
| Cell 3 |  Cell  2 | Cell  1 | Cell  0 | Address |
|--------|----------|---------|---------|---------|
|8 bytes |8 bytes   |8 bytes  | 8 bytes | 0x004   |
|8 bytes |8 bytes   |8 bytes  | 8 bytes | 0x003   |
|8 bytes |8 bytes   |8 bytes  | 8 bytes | 0x002   |
|8 bytes |8 bytes   |8 bytes  | 8 bytes | 0x001   |
|8 bytes |8 bytes   |8 bytes  | 8 bytes | 0x000   |

---

The PC value maps to the address. When PC is 0, this will map to the first address, and the 4 bytes, forming one instruction word, will be outputted out of Instruction Memory. As such, PC + 4 corresponds to the next address.

<br>

#### (3.2.1.2) PC Adder
When Jump or Branch instructions are carried out, the next instruction that must be carried out is not always the next one stored in memory. The next address must therefore be calculated, which is found using [PCAdder.sv](PCAdder.sv). 
<br>

The PC Adder receives the current instruction type from the Control Unit (see below), and executes the following logic:
<br>

**Table ()** : 

---
| Instruction Type |  Instruction SubType | Output PC Target |
|------------------|----------------------|------------------|
|  JUMP  |  JUMP AND LINK REGISTER      | ImmExt + RegOffset  | 
|  JUMP  |  ANY OTHER  | PC + ImmExt |
| BRANCH | ANY    | PC + ImmExt |

---

When the current instruction is a simple Branch or Jump, the next PC value is calculated by the value of ImmExt (see below), to give the correct next address. However, when the instruction is JALR, an offset can be specified. Since the value of this offset already contains the value of PC, ImmExt is once again added, so that the correct next address is found. 
<br>
#### (3.2.1.3) Instruction Memory

## (3.3) Pipelined Architecture

As with the Single Cycle Architecture, the pipeline architecture broke down the instruction execution cycle into 5 stages. The stages were chosen as the following : 

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
