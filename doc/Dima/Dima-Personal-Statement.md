# Statement on Project Contributions and Personal Reflections - Dima Askarov

## Table of Contents
1. [Main Contributions](#1-main-contributions)      
   - [Design Principles](#11-design-principles)
   - [Custom Logic Types](#12-custom-logic-types)
   - [Control Unit](#13-control-unit)
      - [Instruction Memory](#131-instruction-memory)
      - [Instruction Decode](#132-instruction-decode)
      - [Control Decode](#133-control-decode)
      - [Imm Decode](#134-imm-decode)
      - [Alu Encode](#135-alu-encode)
      - [Control Path](#136-control-path)

   - [Hazard Control](#14-hazard-control)
   - [Limitations](#15-limitations)

2. [Co-Created Modules](#2-co-created-modules)
   - [Data Memory](#21-data-memory)
   - [Instruction Memory](#22-instruction-memory)
   - [Result Mux](#23-result-mux)
   - [PC Register](#24-pc-register)
   - [Register File](#25-register-file)
   - [Top Sheet](#26-top-sheet)

3. [Reflection and Improvements](#3-reflections-and-improvements)


4. [Acknowledgements](#6-acknowledgements)

<br>

---

<br>


# (1) Main Contributions

## (1.1) Design Principles

The driving design principles throughout the development of components for the Single Cycle CPU and the Pipelined CPU were the following :

>- **Modularity** : Components were broken down into specialised units that performed a singluar or a limited set of tasks

>- **Ease of intergration and development** : The ability to easily integrate sub modules together was always a key consideration during design and development

>- **Transparency of operation** : The ability to easily interpret and understand the operation of modules and sub-modules was the main consideration when implementing them. The implications of this approach on the efficiency and cost of the design is explored in *Limitations*

<br>

Implementations of modules driven by the design principles above led to certain advantages and potential disadvantages explored in *limitations*.

## (1.2) Custom Logic Types

To increase the readability of modules and make their operation more transparent and understandable, frequently used control and data signals were encoded into custom logic types using enums and unions. 

These logic types are defined in the 'ControlTypeDefs.svh' file that is included in each module that utilises the respective logic types - shown in **Listing (1.2.1)**.

**Listing (1.2.1)** : Include header example

```verilog
`include "include/ControlTypeDefs.svh" //Include Header
```

<br>

**Table (1.2.1)** Shows the definition of the enum InstructionTypes. This enum was used to store the type of instruction executing as decoded by the control unit. Using this enum made the modules easier to understand as the viewer could easily tell what specific instruction would trigger a given set of outputs. 

**Table (1.2.1)** : Enum - InstructionTypes Definition

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


To further classify a given instruction, a union InstructionSubType was implemented. At any given time, this union would take on the value of an enum type representing the specific instruction sub type. The definition of the 'TypeR' enum is shown in **Table (1.2.2)** as example. For the case of an r-type class of instructions, the InstructionSubTypes union would take on the enum value of the specific r-type instruction.

<br>

**Table (1.2.2)** : Enum - TypeR Definition

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


**Table (1.2.3)** : Union - InstructionSubTypes Definition

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

**Listing(1.2.2) :** Example of instruction type and sub type assignment in InstructionDecode module given the instructin OpCode, funct3 and funct7 values

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

**Listing(1.2.3) :** Example usage of InstructionTypes enum and InstructionSubTypes union in producing control signals

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
<br>



## (1.3) Control Unit
![](images/controlUnit.svg)

>**Description :** The `ControlUnit` module is the combination of the `InstructionMemory` module and the `ControlPath` module - which are detailed below.

<br>

## (1.3.1) Instruction Memory

>**Description** : The `InstructionMemoryF` module is designed as an instruction memory component. It is parameterized to accommodate varying data widths and is responsible for storing and providing instruction data based on the provided Program Counter (PC) value. The memory address space has a size of 4096 (12-bit address) addresses to accomodadate the memory block depicted in the reference memory map - shown in **Figure (1.3.1(1))**. This was done as having an address space of $2^{32}$ addresses caused an out of bounds error when trying to load instructions (probably due to the enormous memory requirements)


### Module Interface

---

### Parameters :



- `DATA_WIDTH`: Specifies the width of the data (and thus the instruction width). It is set to 32 by default, aligning with the typical instruction size in RV32I architecture, yet only the bottom 12-bits are used as the address. 

<br>

**Listing (1.3.1(1)) :** ROM Array Initialization

```verilog
//////////////////////////////////////////////
////     Instruction ROM Array 32 x 4096  ////
//////////////////////////////////////////////

  //ROM Array - Address space is large enough to cover the memory space shown in memory map
  logic [DATA_WIDTH - 1 : 0] rom_array [0 : 2**12  - 1];
```


<br>

### Inputs :
| Input       | Type           | Description                                |
|-------------|----------------|--------------------------------------------|
| `iPC`       | `logic [31:0]` | The Program Counter (PC) value, indicating the address from which the instruction should be fetched. |

<br>

### Outputs :
| Output          | Type                       | Description                                        |
|-----------------|----------------------------|----------------------------------------------------|
| `oInstruction`  | `logic [DATA_WIDTH-1:0]`   | The output instruction fetched from the instruction memory. |

<br>

---

<br>


### Instruction ROM Array :
- The module contains a ROM (Read-Only Memory) array named `rom_array` with a size of 32 x 4096, providing a substantial memory space for storing instructions.
- The ROM array assumes a little endian byte addressable memory architecture

### Loading Instructions into ROM :
- At initialization, the ROM array is populated with instruction data from a hex file made using the Makefile script. This step loads the actual instruction set that the processor will execute.

### Reading Instruction Word from ROM :
- The module implements a combinational logic block to fetch a 32-bit instruction based on the input `iPC` value. Since the memory is byte-addressable, it concatenates four bytes to form a single instruction word. This ensures that instructions are correctly assembled from the individual bytes stored in the ROM.

<br>

**Listing (1.3.1()) :** Reading ROM Cell

```verilog
  //Load LS Byte of 4 consecutive memory cells into instruction word - since byte addressable instructions
  always_comb begin
    oInstruction = {rom_array[iPC + 32'd3][7:0], rom_array[iPC + 32'd2][7:0],   rom_array[iPC + 32'd1][7:0], rom_array[iPC][7:0] };
  end
```



---

<br>

## (1.3.2) Instruction Decode

>**Description :** The `InstructionDecodeD` module interprets the opcode, funct3, and funct7 fields of an instruction and determines its type and subtype.


### Module Interface

---

<br>

 **Inputs**

| Input          | Type         | Description                                        |
|----------------|--------------|----------------------------------------------------|
| `iOpCode`      | `logic [6:0]`| 7-bit opcode field of the instruction.             |
| `iFunct3`      | `logic [2:0]`| 3-bit function field, used in most instructions.   |
| `iFunct7`      | `logic [6:0]`| 7-bit function field, used in some instructions.   |


<br>

 **Outputs**

| Output                 | Type                   | Description                                         |
|------------------------|------------------------|-----------------------------------------------------|
| `oInstructionType`     | `InstructionTypes`     | Enumerated type indicating the general category of the instruction. |
| `oInstructionSubType`  | `InstructionSubTypes`  | Enumerated subtype providing more specific information about the instruction. |

---

### Instruction Type Classification
The module uses a `case` statement to classify the instruction based on its `iOpCode`. It supports the various instruction types like `REG_COMMPUTATION`, `IMM_COMPUTATION`, `LOAD`, `UPPER`, `STORE`, `JUMP`, and `BRANCH`.

### Handling Different Instructions
Based on the opcode, it further differentiates instructions using `iFunct3` and `iFunct7` fields. For example:

- In case of `REG_COMMPUTATION` (opcode `7'd51`), it further classifies the instruction as `ADD`, `SUB`, `SHIFT_LEFT_LOGICAL`, etc., based on `iFunct3` and `iFunct7`.
- For `IMM_COMPUTATION` (opcode `7'd19`), it identifies subtypes like `IMM_ADD`, `IMM_SHIFT_LEFT_LOGICAL`, etc.
- Other instruction types like `LOAD`, `UPPER`, `JUMP`, and `BRANCH` are similarly classified.

### Subtype Assignment
After classification, the module assigns the correct subtype to `oInstructionSubType` based on the identified instruction type. This is done in another `always_comb` block, ensuring that the output is always up to date with the inputs.


<br>

---

<br>

## (1.3.3) Control Decode


>**Description :** The `ControlDecodeD` module interprets the type and subtype of the current instruction and sets various control signals that dictate how the processor should handle the instruction. This includes determining the source of operands, whether to write to registers or memory, and how the program counter (PC) should be updated.

### Module Interface

---

### Inputs :

| Input               | Type                     | Description                                                    |
|---------------------|--------------------------|----------------------------------------------------------------|
| `iInstructionType`  | `InstructionTypes`       | The type of the current instruction (e.g., LOAD, STORE, JUMP). |
| `iInstructionSubType` | `InstructionSubTypes`  | The subtype of the current instruction for further specificity.|
| `iZero`             | `logic`                  | A flag indicating a zero result from the ALU, used in branching.|

<br>

### Outputs :
The module generates the following control signals:

| Output        | Type         | Description                                        |
|---------------|--------------|----------------------------------------------------|
| `oResultSrc`  | `logic [2:0]`| Determines the source of the result to be written back.  |
| `oPCSrc`      | `logic`      | Determines the source for the next PC value (branch/jump).|
| `oAluSrc`     | `logic`      | Determines the second operand source for the ALU.        |
| `oRegWrite`   | `logic`      | Control signal to enable writing to the register file.    |
| `oMemWrite`   | `logic`      | Control signal to enable writing to memory.               |


### Control Signal Determination :

> The module uses a `case` statement based on `iInstructionType` to set the control signals:

- **Register Computations (`REG_COMMPUTATION`)**: Enables register writeback.
- **Immediate Computations (`IMM_COMPUTATION`)**: Enables register writeback and sets ALU source to immediate value.
- **Load Instructions (`LOAD`)**: Sets up for a load operation from memory.
- **Upper Immediate Instructions (`UPPER`)**: Handles `LOAD_UPPER_IMM` subtype specifically for immediate values and PC-related operations.
- **Store Instructions (`STORE`)**: Enables memory write operation.
- **Jump Instructions (`JUMP`)**: Sets PC source for jumps and handles writeback of PC+4 for `JAL` instruction.
- **Branch Instructions (`BRANCH`)**: Uses the `iZero` flag to determine the PC source based on branch condition (BEQ, BNE).

### Default Case
In the default case, all control signals are set to their initial (inactive) state.

---

<br>

## (1.3.4) Imm Decode

>**Description :** The `ImmDecode` module is designed to extract and extend the immediate operand from a given instruction.

<br>

### Module Interface

---

### Inputs :

| Input                | Type                    | Description                                                  |
|----------------------|-------------------------|--------------------------------------------------------------|
| `iInstructionType`   | `InstructionTypes`      | The type of the current instruction.                         |
| `iInstructionSubType`| `InstructionSubTypes`   | The subtype of the current instruction for more specificity. |
| `iInstruction`       | `logic [31:0]`          | The full 32-bit instruction word.                            |

### Output :

| Output        | Type           | Description                                        |
|---------------|----------------|----------------------------------------------------|
| `oImmExt`     | `logic [31:0]` | The extended 32-bit immediate value extracted from the instruction. |

---

<br>

### Immediate Value Extraction and Extension:

>The module uses a `case` statement based on `iInstructionType` to correctly extract and sign-extend the immediate value from the instruction:

- **Immediate Computations (`IMM_COMPUTATION`)** and **Load Instructions (`LOAD`)**: Extracts a 12-bit immediate from the instruction and sign-extends to 32 bits.
- **Upper Immediate Instructions (`UPPER`)**: Extracts a 20-bit immediate from the upper part of the instruction.
- **Store Instructions (`STORE`)**: Constructs a 12-bit immediate from two different parts of the instruction.
- **Jump Instructions (`JUMP`)**: Handles two cases, `JUMP_LINK_REG` and others, to construct the immediate operand.
- **Branch Instructions (`BRANCH`)**: Constructs a branch immediate operand from various bits of the instruction.

### Default Case
In the default case, the immediate value is set to zero.

---

<br>

## (1.3.5) Alu Encode

>**Description :** The `AluEncodeD` module is designed to generate control signals for the Arithmetic Logic Unit (ALU) based on the type and subtype of the current instruction. It instructs the ALU on which operation it should perform.


### Module Interface


---

### Inputs :

| Input                | Type                    | Description                                                  |
|----------------------|-------------------------|--------------------------------------------------------------|
| `iInstructionType`   | `InstructionTypes`      | The type of the current instruction (e.g., LOAD, STORE).     |
| `iInstructionSubType`| `InstructionSubTypes`   | The subtype of the current instruction for further specificity.|

<br>


### Outputs :

| Output        | Type         | Description                                        |
|---------------|--------------|----------------------------------------------------|
| `oAluCtrl`    | `AluOp`      | The control signals for the ALU, indicating which operation to perform.|

<br>

---

<br>


### ALU Control Signal Generation
> The module uses a `case` statement based on `iInstructionType` to set the appropriate ALU control signals:

- **Register Computations (`REG_COMMPUTATION`)**: The ALU operation is determined by the register computation subtype.
- **Immediate Computations (`IMM_COMPUTATION`)**: The ALU operation is determined by the immediate computation subtype.
- **Store (`STORE`)** and **Load (`LOAD`)** Instructions: Both set to perform an immediate addition (`IMM_ADD`), typically for address calculation.
- **Branch Instructions (`BRANCH`)**: Set to perform subtraction (`SUB`) to compare register values.
- **Jump (`JUMP`)** and **Upper (`UPPER`)** Instructions: These do not require an ALU operation and are set to a default 'null' operation.
- **Default Case**: In case of unrecognized instruction types, the ALU control is set to a default 'null' operation.

<br>

### AluOp Type :

>The AluOp type is a union that takes on the value of a TypeR or TypeJ enum and a NULL value when an unrecognized input is present

**Listing (1.4.5()) :** AluOp Union Definition

```verilog
  typedef union packed{
    TypeR REG_COMPUTATION;
    TypeI IMM_COMPUTATION;
    logic [3:0] NULL;
  } AluOp;
```

---

<br>

## (1.3.6) Control Path

>**Description :** The `ControlPath` module serves as a comprehensive control unit in the Decode (D) stage of the processor. It integrates various subcomponents described in the previous sections to decode instruction types, generate immediate values, and determine control signals for subsequent stages, particularly for the ALU and memory operations.

### Module Interface :

---

### Inputs :

| Input           | Type         | Description                                       |
|-----------------|--------------|---------------------------------------------------|
| `iInstruction`  | `logic [31:0]` | The full 32-bit instruction word.               |
| `iZero`         | `logic`       | A flag indicating a zero result from the ALU, used in branching. |

<br>

### Outputs :

| Output               | Type                   | Description                                        |
|----------------------|------------------------|----------------------------------------------------|
| `oInstructionType`   | `InstructionTypes`     | The type of the current instruction.               |
| `oInstructionSubType`| `InstructionSubTypes`  | The subtype of the current instruction.            |
| `oImmExt`            | `logic [31:0]`         | The extended immediate value for the instruction.  |
| `oAluControl`        | `logic [3:0]`          | The control signals for the ALU operation.         |
| `oResultSrc`         | `logic [2:0]`          | Determines the source of the result to be written back. |
| `oAluSrc`            | `logic`                | Determines the second operand source for the ALU.  |
| `oPCSrc`             | `logic`                | Determines the source for the next PC value.       |
| `oMemWrite`          | `logic`                | Control signal to enable writing to memory.        |
| `oRegWrite`          | `logic`                | Control signal to enable writing to the register file. |
| `oRs1`               | `logic [4:0]`          | Source register 1 address.                         |
| `oRs2`               | `logic [4:0]`          | Source register 2 address.                         |
| `oRd`                | `logic [4:0]`          | Destination register address.                      |


---

<br>

### Modules and Operation Within The Control Path :

---

### OpCode, Funct3, Funct7 Extraction
The module extracts `op_code`, `funct7`, and `funct3` from the `iInstruction` for further decoding.

### Register Addresses
The source (`oRs1`, `oRs2`) and destination (`oRd`) register addresses are extracted from the `iInstruction`.

### Instruction Decoder
This submodule decodes the instruction type and subtype based on `op_code`, `funct3`, and `funct7`.

### Immediate Operand Decoder
Generates the sign-extended immediate operand based on the instruction type and subtype.

### Control Signal Decoder
Generates various control signals (`oResultSrc`, `oPCSrc`, `oAluSrc`, `oRegWrite`, `oMemWrite`) based on the instruction type, subtype, and `iZero` flag.

### ALU Operation Encoder
Determines the ALU operation to be performed based on the instruction type and subtype.

---

<br>

## (1.4) PC Adder

## (1.5) Hazard Control

## (1.6) Limitations

<br>

---

<br>

# (2) Co-Created Modules

## (2.1) Data Memory

## (2.2) Instruction Memory

## (2.3) Result Mux

## (2.4) PC Register

## (2.5) Register File

## (2.6) Top Sheet

<br>

---

<br>

# (3) Reflections and Improvements

<br>

---

<br>

# (4) Acknowledgements