## Control Unit For Extremely Reduced RISC-V

### **Objective :**  

Create a single-cycle CPU unit that is able to execute the addi and bne RISC-V instructions.

### Step 1: Design

Before writing the Verilog specifications for the control unit, a visual model was constructed in Issie software to help visualize the logic operations and play around with potential design implementations. This also reduced the room for errors when implementing it in system verilog.


### Step 2: Implementation

##### Control Unit

The control unit is responsible for decoding the current instruction and generating control signals to control PC incrementation and ALU operation accordingly. Thus the main control unit was made up of a pipeline of decoders and encoders.

The only thing about the control unit is that currently, many of the outputs from the decoders are 1 hot, and with many possible outputs (ie. add, sub, branch), the design can get messy and hard to interface with due to a having to manipulate single bit objects. In the future, this could be changed so that a given decoder would output a bus whose bits represent the outputs rather than having individual outputs. Furthermore, this design of the control unit uses a lot of combinational logic components which may be troublesome when trying to create it practically, perhaps there is a more efficient design of the control unit.


