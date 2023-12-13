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
   - [PC Adder](#14-pc-adder)
   - [Hazard Control](#15-hazard-control)
      - [Hazard Unit](#151-hazard-unit)
      - [Jump Handling And Static Branch Prediction](#152-jump-handling-and-static-branch-prediction)
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

## (1.0) Design Principles

The driving design principles throughout the development of components for the Single Cycle CPU and the Pipelined CPU were the following :

>- **Modularity** : Components were broken down into specialised units that performed a singluar or a limited set of tasks

>- **Ease of intergration and development** : The ability to easily integrate sub modules together was always a key consideration during design and development

>- **Transparency of operation** : The ability to easily interpret and understand the operation of modules and sub-modules was the main consideration when implementing them. The implications of this approach on the efficiency and cost of the design is explored in *Limitations*

<br>
Implementations of modules driven by the design principles above led to certain advantages and potential disadvantages explored in *limitations*.

<br>


## (1.1) Contribution Summary

Below is a table summarising the contributions made to the design and implementation of the CPU as well as documentation, structure and organisation of the project.

<br>

>*Note that not all commits have been documented in the table due to their large amount - the table shows the more notable commits illustrating the overall contribution*

<br>

**Table(1.1.1) :** Contribution Summary

---
| Module | Contribution | Co Creater | Commit History
|----------|----------|------------|----------------|
| Control Unit                 | Module combines the control path and instruction ROM - Full design and implementation | | Implementing The Control Unit : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/6708ba8f92115fe770dfe7a0cc5fea6586a706c6), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/d1209f29cbb4698781d19419e5ec70b44e06314d), [3](https://github.com/lolzio5/Team05-RISCV-Final/commit/013222c61fe8f18d3499e880665b8ab5db4a470d), [4](https://github.com/lolzio5/Team05-RISCV-Final/commit/9328ef9f3ca17329e4db811c08ed829880941ce4)   |
| Control Path                 | Module generates full set of control signals by combining sub-modules - Full design and implementation| | Implementing The Control Path : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/81aad73dd77f65bb3a943fb627f0abaf46e48796), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/76f96ac5f095c19664bde352b47eb2186de2c426), [3](https://github.com/lolzio5/Team05-RISCV-Final/commit/511b2ab2364be20b989ac8f5b0ecb6767eb00087) <br> Style and Naming : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/e7c050a2aee414955574d4f0cb557a0730a249fb) |
| Control Decode               | Module generates control signals for a given instruction - Full design and implementation| | Implementing Control Decode Logic : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/cec988b801902832a9f805a05800baef71c9cc2d), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/c6ddce225e5456ce87b3b74df91057e8cba7151d), [3](https://github.com/lolzio5/Team05-RISCV-Final/commit/3bd9ecf5eaaea01436261642f1a2c2c58b9f05e2), [4](https://github.com/lolzio5/Team05-RISCV-Final/commit/6b60ce9379c01afc03ee573ad7a5d5a8428d6e24) <br>  |
| Immediate Decode             |Module that extracts the 32-bit immediate from the instruction - Full design and implementation | | Sign Extension Logic : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/fd4b38a312291cc50405a4ee0f0fcdfd58e699ec), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/73234d4c2963db9a97efebf7f824d09ecfeb41e0), [3](https://github.com/lolzio5/Team05-RISCV-Final/commit/cdd3fa6e475c8d8bcc18cd954e76f98e129d2014)  <br> Immediate Decoding Logic : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/70e985f78c55c8befaaf6244dc386da382c2cd48), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/818da68a376826f001fc998e7c430dbc3132275c), [3](https://github.com/lolzio5/Team05-RISCV-Final/commit/6f20562ea5342c9904f4dbeb2388cd724bd00d8d), [4](https://github.com/lolzio5/Team05-RISCV-Final/commit/b66ee54f43a56cf334b0c354569c130ca21743f8) <br> Style and Naming: [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/35c11704569b52352ee60277fe308ecf7f75ea82)  | 
| Alu Encode                   | Module that generates alu control signals - Full design and implementation| | Alu Control Signal Generation : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/32fbf56d37cd0e637fb236376f8080dc4a1edc83), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/7c853dbfdcd0ee822bfdb8dfcfb3d567f976fdac), [3](https://github.com/lolzio5/Team05-RISCV-Final/commit/7ec42b56da41faebfb6ba8dadb7e18a9a041e253), [4](https://github.com/lolzio5/Team05-RISCV-Final/commit/2d24dcea2e6acf75303f548e9133d0cecb6715f8) |
| Instruction Decode           | Module that decodes the type and sub-type of an instruction - Full design and implementation| | Implementing Logic To Decode Instructions : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/00c7d29e8214b549c5f0ab3b781c6774a29a316b), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/f487bb46401c15c78bc584880d6ca50f509ca64f), [3](https://github.com/lolzio5/Team05-RISCV-Final/commit/20c22cb740c5a9551c674cc328e92fb2e45b091b), [4](https://github.com/lolzio5/Team05-RISCV-Final/commit/c2e8d077898b842a19981c2dfb057dca4ed12618), [5](https://github.com/lolzio5/Team05-RISCV-Final/commit/daf545f3c24ecf7a67d7086e3ef80c0a4c8c0a85), [6](https://github.com/lolzio5/Team05-RISCV-Final/commit/daf545f3c24ecf7a67d7086e3ef80c0a4c8c0a85) <br> |
| Instruction ROM              | Memory ROM to hold instructions - Full design and implementation|  | Implementing Byte Addressable ROM Array : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/56f249e777e2d1a153c8432daadc0e88bfb8248f), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/2af18d9200f9f483e556aa815168b1048f24ec05) <br> Style and Naming: [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/11a5e6fe025a320a7f1bd9d5ed5cdd24c5e11379), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/d84d39ba50e9568d39da1c02df9c22a53aea4fbd), [3](https://github.com/lolzio5/Team05-RISCV-Final/commit/27cc9c11ca341c02deba15bb0234e289f3d60d63) | 
| PC Register                  | Added pipelining features, Adjusted initial design to make the register self contained, Added stall logic | [@lolzio5](https://github.com/lolzio5)| PC Selection and Propagation : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/597d6ddf8c3f5eb81c21822ef1b9b8adaa3ae817), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/9a778b31e51770afe913ab06382be427f74723b6) <br> Style and Naming : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/e44e57b548192d00c79772b9a46caa98e664335d) |
| Hazard Unit                  | Module generates control signals for data forwarding in the case of hazard detection - Full design and implementation| | Implementing Hazard Detection and Data Forwarding Logic : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/8f46596fc395622a66ab65c7789dfbd81ec4c672), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/941eca310a097943bf3d80b4802751060fe20137), [3](https://github.com/lolzio5/Team05-RISCV-Final/commit/5be2e9d48dd8d1671ab58f3b553c935598aade27) <br> Handling Hazards Due to Branching : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/c4770d25012f80ee241bc086ce574ae5848bc013), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/cce3140f6d694ce3c0940b9ea8eb17ce0e34fb63), [3](https://github.com/lolzio5/Team05-RISCV-Final/commit/703cab9a5b5eb40ea50122d9526ef96056274d9e)  <br> Style and Naming : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/1c0839cd6f8100e680f8f0f21a46a2204839657b)|
| Jump Branch Handler          | Handles jump and branch control hazards - Full design and implementation| | Branch Prediction : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/5bcb12965f5b56d23c8e2b8745dfb464b11259c3), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/6f2991cfe6194896cda8bed65d5f6b97482eb7d3) <br> Handling Jumps : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/7e71b202f67246ea8749874378cd35f9f33aa28c), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/703cab9a5b5eb40ea50122d9526ef96056274d9e)|
| Register Comparator          | Added to flush and stall logic | [@songmeric](https://github.com/songmeric)| Implementing Stall and Flush Logic : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/cce3140f6d694ce3c0940b9ea8eb17ce0e34fb63), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/703cab9a5b5eb40ea50122d9526ef96056274d9e)|
| Alu Operand Forwarder        | Updated forwarding logic | [@songmeric](https://github.com/songmeric)| Alu Operand Forwarding Logic : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/b303699532cb783e7f5b43ba7804b51896f551a0) |
| Data Memory                  | Implemented read/write logic, address alignment | [@samuelwbarber](https://github.com/samuelwbarber)|  Memory Addressing : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/63b00e5298106c934d3255a43f0d6fe5b1a44f81), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/5407d19a752a2882fea82ed8e712bb0fa6996ec8), [3](https://github.com/lolzio5/Team05-RISCV-Final/commit/8abc3403a5c936c607210757cfa707c28e392db0), [4](https://github.com/lolzio5/Team05-RISCV-Final/commit/5407d19a752a2882fea82ed8e712bb0fa6996ec8)   <br> Handling Load/Store Operations : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/0b1b4fb525a6814ecf499f13c665fb7bf6b3b727) , [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/64aab77ed20bac600cbc883d797656d2e4eda271), [3](https://github.com/lolzio5/Team05-RISCV-Final/commit/64aab77ed20bac600cbc883d797656d2e4eda271)  <br> | 
| Pipe Line Registers          | Adjusted the I/O signals to accomodate for all signals that need to propagate through the pipeline, Added flush and stall logic| [@lolzio5](https://github.com/lolzio5)| Fixed I/O Of Pipeline Registers : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/6bd200c87ad1e9276a7d572e7feffa26ac0b742e), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/2e07d851db20071b549c464e8036bf5e2186cd7f) <br> Stall and Flush Logic : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/703cab9a5b5eb40ea50122d9526ef96056274d9e), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/cce3140f6d694ce3c0940b9ea8eb17ce0e34fb63) | 
| Result Selector              | Module that decides the source for the data that is to be written back to the register - Full design and implementation| | Selecting Write-Back Source : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/df3ef43ce49c8a111c2270d639e4e437669ee722), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/b042dedb97b661e493a0190d9e9b20237d4a4c30), [3](https://github.com/lolzio5/Team05-RISCV-Final/commit/ab415e2c6e570f4bceb2aedc4314b7714ecccfdd)| 
| Register File                | Implemented read/write logic, Added forwarding logic to prevent hazards in a pipeline| [@lolzio5](https://github.com/lolzio5)| Read/Write Operation : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/cba743c702f9b53f03254a8f31e102f4cbb3d6b6), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/ab7904760b6af35010f5bf07d4a45f23c941603d) <br> Style and Naming : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/c08823386b247acc3c3c066eea5941746de008f2) | 
| PC Adder                     | Module to generate jump and branch target addresses - Full design and implementation| | Computing the Branch Target Address : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/57809310c043b34817b8b806eae4e080a821ec1e), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/812f7407e99339c940b445bbba6c83c8de23d39a) <br> Accomodating for Upper and Jump Instructions : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/821bae97d6b3668b563989e5dfed589851f2867c) |
| Top Sheet                    | Continious contribution of keeping module layout, structure, interconnectedness and signal naming up to date and up to standard| [@samuelwbarber](https://github.com/samuelwbarber), [@lolzio5](https://github.com/lolzio5)| Integrating Sub Modules in Top Sheet : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/abf80377f4a6ef5c19ba4246f3f6479a6e422598) <br> Pipelining : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/bdb7391bbe1011e7923fd53b07362ef7bace0dd6), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/fa865bf1c5a6acc4fb9c1b7fa4e53cba2aca5758) | 
| General                      | General contributions to organisation and structure| | Style and Naming : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/24f0529a495f932ae6075249d07100786213447c), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/4427d1ebec40a8a1fe2c6e32d4ccac5da61c6b15), [3](https://github.com/lolzio5/Team05-RISCV-Final/commit/4c4948f805aed9283e108f889a568508c703b0e6), [4](https://github.com/lolzio5/Team05-RISCV-Final/commit/91078cc78c7c750efed9da886ffe86735eeeebbd), [5](https://github.com/lolzio5/Team05-RISCV-Final/commit/2e060a20fcf873926fbfb8056926f94ddcd7de9a) <br> File and Directory Organisation : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/f81c3f8554bb1c05ba200cdd2eee3ad07df29eba), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/5778d1f6dbf0762aab008298e3462fb7d90259f4), [3](https://github.com/lolzio5/Team05-RISCV-Final/commit/98442cad7d019289d9d35447c01442b96f05acbe), [4](https://github.com/lolzio5/Team05-RISCV-Final/commit/c152c5247b978bff421716dacc870332b4f9bee1), [5](https://github.com/lolzio5/Team05-RISCV-Final/commit/78e296416095302a34ea9e9048a1c7d1531baa69) <br> Documentation : [1](https://github.com/lolzio5/Team05-RISCV-Final/commit/d42f55184708a4b43cba8dd081561e87b090772c), [2](https://github.com/lolzio5/Team05-RISCV-Final/commit/1b722ae181a4bf2d8628d6e8d9b04b38d25897e4), [3](https://github.com/lolzio5/Team05-RISCV-Final/commit/65f83eef05c02ac2dd9e0373088c1e689a75e6e6), [4](https://github.com/lolzio5/Team05-RISCV-Final/commit/99de0382af7eeeb031e0bd82233b19541a5cd37e)|

---

<br>



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

**Figure 1.3.1 :** Control Unit High Level Diagram

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

### Control Path and Pipelining 

In the pipelined version, the control path was changed to stop taking the `iZero` flag as input and generating the `oPCSrc` signal as output as the operation of deciding to jump or branch is performed by the `ComparatorD` and `JumpBranchHandlerF` modules.


---

<br>

## (1.4) PC Adder


>**Description :** The `PCAdderD` module is designed for calculating the target program counter (PC) address in the Decode (D) stage of a processor. It is essential for handling jumps, branches, and other PC-relative instructions, facilitating the correct flow of control in the processor pipeline.

## Module Interface

### Inputs

| Input                | Type                   | Description                                                  |
|----------------------|------------------------|--------------------------------------------------------------|
| `iInstructionType`   | `InstructionTypes`     | The type of the current instruction.                         |
| `iInstructionSubType`| `InstructionSubTypes`  | The subtype of the current instruction.                      |
| `iRecoverPCD`        | `logic`                | A flag to indicate whether to recover the original PC.       |
| `iPCD`               | `logic [31:0]`         | The current program counter value in the decode (D) stage.                           |
| `iImmExt`            | `logic [31:0]`         | The extended immediate value for the instruction representing the branch/jump offset.            |
| `iRegOffset`         | `logic [31:0]`         | A register offset value, used in the JALR instruction.  |

<br>

### Output


| Output         | Type          | Description                                        |
|----------------|---------------|----------------------------------------------------|
| `oPCTarget`    | `logic [31:0]`| The calculated target address for the program counter. |

<br>

---

<br>

### Target Address Calculation
>The module calculates the target PC address based on the instruction type:

- **Jump Instructions (`JUMP`)**: 
  - For `JUMP_LINK_REG` subtype, it calculates the target by adding `iImmExt` to `iRegOffset`.
  - For other jump instructions, it adds `iImmExt` to `iPCD`.
- **Branch Instructions (`BRANCH`)**: Adds `iImmExt` to `iPCD`.
- **Default Case**: Also adds `iImmExt` to `iPCD`.

<br>

### Address Alignment
Ensures that the target address is correctly aligned. For `JUMP_LINK_REG`, it explicitly aligns the address to set the lsb to 0 (make the address even).

The immediate operand for other branch/jump instructions is already word aligned via the `ImmDecode` module

In the pipelined version, the register offset is forwarded via the `OperandForwarderD` module in the case that there is a data dependancy occuring (ie. the register used as offset in JALR is being written to by the instruction in the memory stage whilst the JALR instruction is in the decode stage)

<br>

### Recovery of Original PC - Pipelined Version
If `iRecoverPCD` is set, it returns `iPCD + 4`, effectively recovering the original PC address. This is performed in the case that the branch prediction was incorrect (ie. branch was taken incorrectly)


---

<br>

## (1.5) Hazard Control

## (1.5.1) Hazard Unit

>**Description :** The `HazardUnit` module detects and resolves various types of hazards, such as data hazards and control hazards, to ensure smooth and correct execution of instructions in a pipelined processor. The hazard unit generates control signals that dictate which Alu or Comparator signals (if any) are to be forwarded in between pipeline stages, or stall and flush signals if forwarding is not possible.

### Module Interface

---

### Inputs

| Input                    | Type                  | Description                                        |
|--------------------------|-----------------------|----------------------------------------------------|
| `iInstructionTypeD`      | `InstructionTypes`    | The type of the instruction in the Decode stage.   |
| `iInstructionSubTypeD`   | `InstructionSubTypes` | The subtype of the instruction in the Decode stage.|
| `iInstructionTypeE`      | `InstructionTypes`    | The type of the instruction in the Execute stage.  |
| `iInstructionTypeM`      | `InstructionTypes`    | The type of the instruction in the Memory stage.   |
| `iSrcReg1D`, `iSrcReg2D` | `logic [4:0]`         | Source register identifiers in the Decode stage.   |
| `iDestRegE`, `iSrcReg1E`, `iSrcReg2E` | `logic [4:0]` | Destination and source registers in the Execute stage. |
| `iRegWriteEnE`           | `logic`               | Register write enable signal for the Execute stage.|
| `iDestRegM`              | `logic [4:0]`         | Destination register in the Memory stage.          |
| `iRegWriteEnM`           | `logic`               | Register write enable signal for the Memory stage. |
| `iDestRegW`              | `logic [4:0]`         | Destination register in the Write Back stage.      |
| `iRegWriteEnW`           | `logic`               | Register write enable signal for the Write Back stage. |

<br>

### Outputs

| Output                   | Type        | Description                                        |
|--------------------------|-------------|----------------------------------------------------|
| `oForwardAluOp1E`, `oForwardAluOp2E` | `logic [1:0]` | Forwarding control signals for ALU operands in the Execute stage. |
| `oForwardCompOp1D`, `oForwardCompOp2D` | `logic`   | Forwarding control signals for operands in the Decode stage. |
| `oStallF`, `oStallD`     | `logic`     | Stall signals for the Fetch and Decode stages.     |
| `oFlushE`                | `logic`     | Flush signal for the Execute stage.                |


---

<br>

### Hazard Resolution :

---

### Load Dependencies

1. **Detection**: 
   - Load dependency occurs when an instruction in the Decode (D) stage needs data that is being loaded by an instruction in the Execute (E) stage.
   - The module checks if the current instruction in the Execute stage is a load instruction (`iInstructionTypeE == LOAD`) and if the destination register of this load instruction (`iDestRegE`) matches any of the source registers (`iSrcReg1D` or `iSrcReg2D`) of the instruction in the Decode stage.

2. **Resolution**:
   - If a load dependency is detected, the module stalls the Fetch (F) and Decode (D) stages by setting `oStallF` and `oStallD` to 1.
   - Additionally, it flushes the Execute stage (`oFlushE` set to 1) to prevent the instruction in the Execute stage from proceeding further in the pipeline.


### RAW Hazards In Branch And Jump Instructions

1. **Detection**:

   - The module checks for RAW hazards in branch and jump instructions by comparing the source registers of the current instruction in the Decode stage with the destination register of instructions in the Execute (E) and Memory (M) stages.

   - It also checks if there is an additional load data dependancy, in which case the pipeline is stalled at the fetch and decode stage and the execution stage is flushed. The overall effect of having a load instruction following by a branch/jump instruction is a two cycle stall. 
   
2. **Resolution**:

   - In the case of a load data dependancy being detected, with a branch/jump instruction in the decode stage, the pipeline is stalled and flushed. This action is also taken if there is a data dependancy with the instruction in the execution stage. This provides enough time for the instruction in the execute/memory stage to reach the memory/writeback stage and the result of the computation to be forwarded

   - In the case of no load data dependancy, the appropriate forwarding control signals are set and output


### Raw Hazards In Other Instruction Types

1. **Detection**:

   - The module checks if the destination registers either in the memory (M) or write-back (W) stages match either of the source registers in the execute (E) stage.

2. **Resolution**:

   - If a RAW hazard is detected, the module forwards the needed data from the Memory or Write Back stage to the Execute stage, using `oForwardAluOp1E` and `oForwardAluOp2E`.

---

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



<br>

## (1.5.2) Jump Handling And Static Branch Prediction

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
---

<br>

## (1.6) Limitations





<br>

---

<br>

# (2) Co-Created Modules

## (2.1) Data Memory

>**Description :** The Data Memory module consists of a memory array `mem_array` with a size of $32 \text{ x }(2^{x} - 1)$, accommodating addresses from `0x10000` to `0x1FFFF` as specified by the reference program. In the case of loading data into memory from a file, the data memory assumes a little endian byte addressable memory architecture.

### Module Specification

**Table 2.1.1: Module Parameters and I/O**

| Parameter/IO               | Type                | Description                                                    |
|----------------------------|---------------------|----------------------------------------------------------------|
| `DATA_WIDTH`               | Parameter           | Width of the data bus, default is 32 bits.                     |
| `iClk`                     | Input               | System clock signal.                                           |
| `iWriteEn`                 | Input               | Write enable signal.                                           |
| `iInstructionType`         | Input               | Type of the current instruction.                               |
| `iMemoryInstructionType`   | Input               | Subtype of the memory instruction.                             |
| `iAddress`                 | Input               | Memory address for read/write operations.                      |
| `iMemData`                 | Input               | Data to be written to memory.                                  |
| `oMemData`                 | Output              | Data read from memory.                                         |

---

<br>

### Internal Memory Configuration

Additional internal signals are used to temporarily carry memory signals to ease process of determining what data has to be loaded/stored.

**Table 2: Internal Memory Configuration**

| Element                | Description                                                  |
|------------------------|--------------------------------------------------------------|
| `mem_array`            | An array representing RAM, where each element is 32 bits.    |
| `mem_cell`             | Data stored at the currently accessed memory location.       |
| `mem_data`             | Data to be outputted based on the read operation.            |
| `word_aligned_address` | Adjusted memory address, aligned to word boundaries.         |
| `byte_offset`          | Byte offset within the word-aligned address.                 |

---

<br>

### Operational Logic

#### Read/Write Operations

The module performs read or write operations on the rising edge of `iClk`. 

1. **Write Operation**: 
   - If `iWriteEn` is high, the data (`mem_cell`) is written to `mem_array` at the address specified by `word_aligned_address`.

2. **Read Operation**: 
   - If `iWriteEn` is low, `oMemData` is set to the value of `mem_data`, which contains the data read from the memory.

<br>

#### Address and Data Handling

The module calculates the word-aligned address and byte offset for any given memory address. It then constructs the `mem_cell` by combining bytes from `mem_array` based on this calculated address.

<br>

#### Instruction-Specific Logic

The module uses `iInstructionType` and `iMemoryInstructionType` to determine the appropriate action for LOAD and STORE instructions, handling different sizes (byte, half-word, word) and types (signed, unsigned) of data.

---

<br>

## (2.2) Instruction Memory

## (2.3) Result Mux

## (2.4) PC Register

## (2.5) Register File

## (2.6) Top Sheet

<br>

---

<br>

# (3) Reflections, Limitations and Improvements

### Pipeline Architecture Design

The decision to create a 5 stage pipeline with a $F/D_{jb}$ stage, in theory, can bring certain advantages and disadvantages. Some notable advantages include the reduction in cycles wasted for flushing the incorrectly fetched instruction during a branch or jump, due to static branch prediction and taking jumps in the fetch stage. 

With this pipeline architecture, the worst case stall can be only of two cycles, and would typically happen when a branch instruction follows a load instruction and there exists a data dependancy between the two instructions. 

Improvements are seen in jump and branch instructions given there is no data dependancy - in contrast to a pipelined architecture where branches and jumps are fully decided in the decode stage, jump instructions in this architecture don't introduce any lost cycles as they are computed in the fetch stage, furthermore, in the case of an incorrect branch, only a single clock cycle is wasted in flushing and fetching the correct instruction.

---

<br>

# (4) Acknowledgements