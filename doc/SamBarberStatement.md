## Statement of Personal Contributions

Sam Barber - Team 5: Risk V 32i Processor Project


1. [ALU](#alu)
2. [Register](#register)
3. [Processor Diagram](#diagram)
4. [Top File](#top)
5. [Assembly](#assembly)
6. [Cache](#cache)
     - [Hit decetion](#hit)
     - [Miss handling](#miss)
     - [Decode Module](#decode)
     - [Flushing](#flushing)
8. [Conclusion and Reflection](#conclusion)



## ALU <a name="alu"></a>

The ALU module is module designed to perform various arithmetic and logical operations on two input operands based on a control signal. It supports a variety of operations including addition, subtraction, left shift, right shift (logical and arithmetic), set less than, set less than (unsigned), XOR, OR, and AND. The module is parameterized to allow customisation of the operation and data width.


Dima and I worked together to determind what instuctions where required and how they would be impliamented by the ALU and Control Path. Below is a table showing the various control inputs for the ALU from the Control unit:

<br>

| Control Signal | Operation                | Description                                      |
| --------------- | ------------------------ | ------------------------------------------------ |
| `4'b0000`       | Addition (`iAluOp1 + iAluOp2`)      | Adds the two input operands.                     |
| `4'b0001`       | Subtraction (`iAluOp1 - iAluOp2`)   | Subtracts the second operand from the first.     |
| `4'b0010`       | Left Shift (`iAluOp1 << iAluOp2`)   | Left-shifts the first operand by the second operand number of bits. |
| `4'b0011`       | Set Less Than (`iAluOp1 < iAluOp2`) | Sets `oAluResult` to 32'b0 if the first operand is less than the second, otherwise 32'b1. |
| `4'b0100`       | Unsigned Set Less Than (`iAluOp1 < iAluOp2`) | Sets `oAluResult` to 32'b0 if the first operand is less than the second (unsigned), otherwise 32'b1. |
| `4'b0101`       | XOR (`iAluOp1 ^ iAluOp2`)          | Performs bitwise XOR on the two operands.       |
| `4'b0110`       | Right Shift Logical (`iAluOp1 >> iAluOp2`) | Right-shifts the first operand by the second operand number of bits (logical shift). |
| `4'b0111`       | Right Shift Arithmetic (`iAluOp1 >>> iAluOp2`) | Right-shifts the first operand by the second operand number of bits (arithmetic shift). |
| `4'b1000`       | OR (`iAluOp1 \| iAluOp2`)         | Performs bitwise OR on the two operands.        |
| `4'b1001`       | AND (`iAluOp1 & iAluOp2`)         | Performs bitwise AND on the two operands.       |

<br>
The ALU also has a zero output which indicates if the result is zero. High when result is zero.

### Parameters
OP_WIDTH: The width of the control signal (iAluControl). Defaults to 4 bits.
<br>
DATA_WIDTH: The width of the input and output data (iAluOp1, iAluOp2, oAluResult).
Defaults to 32 bits.

### Inputs
iAluControl: Control signal specifying the operation to be performed.
<br>
iAluOp1: First input operand.
<br>
iAluOp2: Second input operand.
<br>
### Outputs
oAluResult: Result of the operation.
<br>
oZero: Indicates whether the result is zero.

## Register <a name="register"></a>

## Processor Diagram <a name="diagram"></a>
As the processor got more complicated and we deviated from the supplied diagram it became much more difficult to understand how each of our modules linked together. To help with this I created this diagram to show how the modules interfaced with each other on a high level. This diagram shows how individual modules of the single cycle processor before the addition of pipelining and cache should be connected.


![](HLv0.6.png)
## Top File <a name="top"></a>

My contribution to the top file was to impliament all the modules I wrote into the top file. Along with altering the top file to resolve errors found after I created the high level diagram above.

## Assembly <a name="assembly"></a>

## Cache <a name="cache"></a>

## Conculsion and Reflection <a name="conclusion"></a>


