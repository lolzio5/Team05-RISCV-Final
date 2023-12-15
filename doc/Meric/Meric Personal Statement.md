# Meric Personal Statement

# I was assigned the task of creating verification tool for our CPU. (testbench)

To get a solid grasp of how a single cycle CPU works, I created my own single cycle CPU modules separately while I wait for the modules to be completed and ready for testing.

It was intended to only be able to handle two operations “BNE” and “ADDI”, and was able to properly execute the initial test program provided by professor Cheung. 

Then, as all modules were finalized, I moved onto effective verification of the modules by accessing internal signal values and making per-instruction(cycle) verification to make sure everything was working properly inside the CPU, without having to stare at GTKwave for many hours a day.

By adding /*verilator public*/ metacomments into module systemVerilog files and adding —public flag to the compile command, Verilator will create extra header files for us to access internal signal values via testbench program, which get updated when the top module is evaluated each clock cycle. 

![Example of the metacomment; you only need to include it once per module sv files.](Meric%20Personal%20Statement%201c001db33b5e439798edf4a78d03e0b3/Screen_Shot_2023-12-14_at_11.06.58_PM.png)

Example of the metacomment; you only need to include it once per module sv files.

![Accesing modules’ internal signal values in testbench.](Meric%20Personal%20Statement%201c001db33b5e439798edf4a78d03e0b3/Screen_Shot_2023-12-14_at_10.58.58_PM.png)

Accesing modules’ internal signal values in testbench.

![Example of instruction test functions by checking internal signal values, and making early ](Meric%20Personal%20Statement%201c001db33b5e439798edf4a78d03e0b3/Screen_Shot_2023-12-14_at_11.00.39_PM.png)

Example of instruction test functions by checking internal signal values, and making early 

This testbench simulates and verifies each clock cycle of the CPU by parsing the assembly file being fed into the CPU’s instruction memory and comparing its expected behaviour to the actual behaviour.

# The parser:

The parser, meant to read and simulate any properly written risc-v assembly code in our CPU module, is mainly composed of the following functions: 

```cpp
void readAssemblyFile(const std::string& filename)
void parseAssembly()
void handleInstruction(const std::string& line)
```

Some smaller functions that take care of specific parsing operations that were written as a function for improvement in code readability and maintainability, will not be mentioned in this documentation.

### readAssemblyFile:

```cpp
void readAssemblyFile(const std::string& filename) {
    std::ifstream file(filename);
    std::string line;
    int lineNumber = 0;

    while (std::getline(file, line)) {
        std::string instruction;

        // Read only up to the '#' character
        std::istringstream iss(line);
        std::getline(iss, instruction, '#');
        instruction = rtrim(instruction);

        std::istringstream iss_instruction(instruction);
        std::string firstToken;
        iss_instruction >> firstToken;

        if (firstToken.empty() || firstToken == ".text") {
            continue; // Skip empty lines or lines that become empty after removing comments
        }

        if (firstToken == ".equ") {
            parseAndAddConstant(instruction); // Handle .equ directive
            continue;
        }

        if (firstToken.back() == ':') {
            firstToken.pop_back(); // Remove colon
            labelMap[firstToken] = lineNumber;
        } else {
            instructions.push_back(instruction);
            lineNumber++;
        }
    }
}
```

The readAssemblyFile reads each line of the assembly file stream and appropriately handles/parses each line into global variables that are defined within the testbench.

1. The parser will ignore any comments made using ‘#’ string.
2. The parser will trim any trailing whitespaces that exist due to comments.
3. The parser will ignore empty lines or comment lines, or .text label.
4. The parser will handle .equ directive and allocate constant values for the program.
5. The parser will handle labels by putting it into unordered map named labelMap. This come in handy when parsing jump instructions.
6. The parser will then consider anything else as instruction and will push it back into a string vector named instructions.
7. The index of each instruction inside the instructions vector will represent PC divided by 4 inside instruction memory, and labels will also have address associated with it.

### parseAssembly:

```cpp
void parseAssembly() {
    while (programCounter < instructions.size()) {
        if(programCounter == 0) {
            reset();
        }
        else {
            tick();
        }
        checkAndPrintLabel(labelMap, programCounter);
        handleInstruction(instructions[programCounter]);
    }
}
```

This function will run through the instructions vector and feed each instructions into the **handleInstruction()** function. It is also responsible for simulating tick and reset in the cpu clock for each instructions being ran inside the CPU.

### handleInstruction:

```cpp
void handleInstruction(const std::string& line) {
    std::istringstream iss(line);
    std::string instr;
    iss >> instr; // Extract the instruction mnemonic
    std::transform(instr.begin(), instr.end(), instr.begin(), 
                   [](unsigned char c) { return std::tolower(c); });

    std::vector<std::string> args;
    std::string arg;

    while (iss >> arg) {
        if (arg.find('#') != std::string::npos) {
            // This argument is a comment, stop processing further
            break;
        }
        args.push_back(arg); // Extract arguments
    }

    if (instr == "bne") {
        if (args.size() != 3) {
            std::cerr << "Error: Invalid arguments for 'bne'" << std::endl;
            return;
        }

        int reg1 = getRegisterAddress(args[0]);
        int reg2 = getRegisterAddress(args[1]);
        int branchAddr = getJumpAddress(args[2]) * 4;
        if (testBNE(reg1,reg2,branchAddr,line)) {
            programCounter = branchAddr / 4;
        }
        else {
            programCounter++;
        }
    } 

    else if (instr == "beq") {
        if (args.size() != 3) {
            std::cerr << "Error: Invalid arguments for 'beq'" << std::endl;
            return;
        }

        int reg1 = getRegisterAddress(args[0]);
        int reg2 = getRegisterAddress(args[1]);
        int branchAddr = getJumpAddress(args[2]) * 4;
        if (testBEQ(reg1,reg2,branchAddr,line)) {
            programCounter = branchAddr / 4;
        }
        else {
            programCounter++;
        }
    } 

    else if (instr == "li") {
        if (args.size() != 2) {
            std::cerr << "Error: Invalid arguments for 'li'" << std::endl;
            return;
        }

        int reg1 = getRegisterAddress(args[0]);
        int immVal = parseStringToInt(args[1]);

        testLI(reg1, immVal, line);

        programCounter++;
    }

		// ... more instructions handled below
}
```

Here each line of instructions will be further parsed, and handled.

Each arguments inside the instruction line is parsed into register values, or immediate values, or etc depending on context, and is fed into test function for checking if each instructions are being ran properly each cycle of the CPU.

In result, we get the verification of CPU by compiling and running the Verilator executable! 

### Below is the test assembly code for our single cycle CPU, and its result:

```nasm
main:
    addi    t0, zero, 2    # Initialize t0 with 10
    addi    t1, zero, 0      # Initialize t1 with 0 (loop counter)

loop:
    addi    t1, t1, 1        # Increment t1
    sll     t2, t1, 1        # Shift left logical t1 by 1, store in t2
    xor     t3, t2, t1       # XOR t2 and t1, store in t3
    bne     t1, t0, loop     # If t1 is not equal to t0, branch to loop

    jal     ra, func         # Jump to func, store return address in ra

    jal     ra, end

func:
    addi    t4, zero, 5      # Initialize t4 with 5
    jalr    zero, ra, 0      # Return to the address in ra

end:
    addi    t0, zero, 1000
```

![Screen Shot 2023-12-14 at 11.54.50 PM.png](Meric%20Personal%20Statement%201c001db33b5e439798edf4a78d03e0b3/Screen_Shot_2023-12-14_at_11.54.50_PM.png)

### Here is F1Single.s and its testbench result:

```nasm
main:
    addi    a0, zero, 0x0                       # load a0 with 0 (a0 is vbd_value, the output)
    addi    t1, zero, 0x0FF
    addi    a2, zero, 0x000 
    addi    a3, zero, 0x001
    addi    a4, zero, 0x000
    addi    a5, zero, 0x001
    jal     x0, loop                            # Jump to loop

loop:
    addi    t0, zero, 0x00F                     # load t0 with a large number to be counted down
    sll     a0, a0, 1                           # shift a0 by 1 so it goes up sequentially in decimal
    addi    a0, a0, 1                           # increment a0 by 1
    beq     a0, t1, random_time                 # If a0 is 255, turn off after a random time
    jal     x0, constant_time                   # Jump to constant_time

constant_time:
    addi    t0, t0, -1                          # Decrement t0
    beq     t0, zero, loop                      # If t0 is equal to zero, return to loop
    jal     x0, constant_time                   # Else continue looping

random_time:
    jal     ra, random_logic                    # Calculate the random value to be decremented
    addi    s1, s1, -1
    beq     s1, zero, end                       # If s1 is equal to zero, end the program
    jalr    x0, ra, 0                           # Else continue looping from the adding statement

random_logic:
    addi    s1, zero, 0x0
    add     s1, s1, a2
    sll     a3, a3, 0x001
    add     s1, s1, a3
    sll     a4, a4, 0x001
    add     s1, s1, a4
    sll     a5, a5, 0x001
    add     s1, s1, a5
    xor     a2, a4, a5
    jalr    x0, ra, 0                           # Return to random_time, 1 instruction later

end:
    addi    a0, zero, 0x0
```

![Screen Shot 2023-12-15 at 12.37.49 AM.png](Meric%20Personal%20Statement%201c001db33b5e439798edf4a78d03e0b3/Screen_Shot_2023-12-15_at_12.37.49_AM.png)

As seen above, the parser and test functions test the CPU line-by-line and see if it can run any assembly instructions thrown at it, and results in expected behaviour each CPU cycle. If all cycles run as expected, the CPU is “verified”.

Then, there came the Pipelined CPU. For pipelined CPU, I had to completely alter the approach by actually handling the instruction feed-in process and testing CPU for each stage per cycle.

For Pipelined CPU development, I also participated in development of modules such as AluOpForwarderE.sv and ComparatorD.sv.

Back to testbench, below is an overview of how I handled this operation in testbench.

Certain repetitive parts of the code were trimmed out to prevent pasting many hundreds of lines of code.

```cpp
struct PipelineInstruction {
    std::string mnemonic;
    std::vector<std::string> args;
    bool valid;
};

struct PipelineStages {
    PipelineInstruction IF;
    PipelineInstruction ID;
    PipelineInstruction EX;
    PipelineInstruction MEM;
    PipelineInstruction WB;
};

PipelineStages stages;

PipelineInstruction no_operation = {"", {}, false};

void initializePipeline() {
    stages.IF = no_operation;
    stages.ID = no_operation;
    stages.EX = no_operation;
    stages.MEM = no_operation;
    stages.WB = no_operation;
}

void advanceInstructions() {
    stages.WB = stages.MEM;
    stages.MEM = stages.EX;
    stages.EX = stages.ID;
    stages.ID = stages.IF;
}

PipelineInstruction parseInstructionLine(const std::string& instructionLine) {
    std::istringstream iss(instructionLine);
    std::string instr;
    iss >> instr; // Extract the instruction mnemonic
    std::transform(instr.begin(), instr.end(), instr.begin(), 
                    [](unsigned char c) { return std::tolower(c); });

    std::vector<std::string> args;
    std::string arg;

    while (iss >> arg) {
        if (arg.find('#') != std::string::npos) {
            break; // This argument is a comment, stop processing further
        }
        args.push_back(arg); // Extract arguments
    }

    return {instr, args, true};
}

void handlePipeline(const std::string& newInstruction) {

    advanceInstructions();

    // Load new instruction into the IF stage
    if (!newInstruction.empty()) {
        stages.IF = parseInstructionLine(newInstruction);
    } else {
        stages.IF = no_operation;
    }

    // Process each stage
    if (stages.WB.valid) {
        const auto& instr = stages.WB.mnemonic;
        const auto& args = stages.WB.args;

        if (instr == "li") {
            if (args.size() != 2) {
                std::cerr << "Error: Invalid arguments for 'li'" << std::endl;
                return;
            }

            int reg1 = getRegisterAddress(args[0]);
            int immVal = parseStringToInt(args[1]);

            testLI(reg1, immVal, newInstruction, "WB");

            programCounter++;

        } else if (instr == "beq") {
						//handle many more instructions in the same way...

		if (stages.MEM.valid) {
        const auto& instr = stages.MEM.mnemonic;
        const auto& args = stages.MEM.args;
        if (instr == "li") {
            if (args.size() != 2) {
                std::cerr << "Error: Invalid arguments for 'li'" << std::endl;
                return;
            }

            int reg1 = getRegisterAddress(args[0]);
            int immVal = parseStringToInt(args[1]);

            testLI(reg1, immVal, newInstruction, "MEM");

            programCounter++;

        } else if (instr == "beq") {
						//handle many more instructions in the same way...
    }
    if (stages.EX.valid) {
        const auto& instr = stages.EX.mnemonic;
        const auto& args = stages.EX.args;
				//same as above
    }
    if (stages.ID.valid) {
        const auto& instr = stages.ID.mnemonic;
        const auto& args = stages.ID.args;
				//same as above
    }
    if (stages.IF.valid) {
        const auto& instr = stages.IF.mnemonic;
        const auto& args = stages.IF.args;
				//same as above
    }
```

and test functions for each instruction at each stage was modified as below:

```cpp
bool testLI(int loadAddr , int dataIn, const std::string& instruction, const std::string& stage) {
    if (stage == "IF") {
        if (programCounter != pcReg->oPC) {
            printFail(instruction, "LIfail FETCH: PC incorrect");
            return false;
        }
        printSuccess(instruction,"LI FETCH Success");
    }

    if (stage == "ID") {
        if (controlUnit->ControlSignalDecoder__DOT__iInstructionType != InstructionTypes::LOAD) {
            printFail(instruction, "LIfail DECODE: InstructionType incorrect");
            return false;
        }
        printSuccess(instruction,"LI DECODE Success");
    }

    if (stage == "EX") {
        if (regFile->iDataIn != dataIn) {
            printFail(instruction, "LIfail EXECUTE: Data Input Different");
            return false;
        }

        if (regFile->iWriteAddress != loadAddr) {
            printFail(instruction, "LIfail EXECUTE: Load Address Different");
            return false;
        }
        printSuccess(instruction,"LI EXECUTE Success");
    }
    
    if (stage == "MEM") {
        if (regFile->iWriteEn == 1) {
            printFail(instruction, "LIfail MEM: Should be doing nothing, but writeEn = 1");
            return false;
        }
        printSuccess(instruction,"LI MEM Success");
    }

    if (stage == "WB") {
        if (regFile->iWriteEn != 1) {
            printFail(instruction, "LIfail WRITEBACK: WriteEnable != 1");
            return false;
        }

        if (regFile->ram_array[regFile->iWriteAddress] != regFile->iDataIn) {
            printFail(instruction, "LIfail WRITEBACK: Write failed");
            return false;
        }
        printSuccess(instruction,"LI WRITEBACK Success");
    }
    return true;
}
```

So the overall logic for the testbench is exactly the same as pipelining itself:

At new clock cycle, advance the stages by 1, load new instructions into the pipeline, and handle/test each stages simultaneously to make sure everything is working perfectly!

Unfortunately I ran out of time to test and check for hazard controls and cache memory functionality. Hence, these things had to be evaluated via VCD file analysis as shown in the main documentation of this project.

Overall, this project gave me an extremely clear internal view of how a CPU operates, and gave me a very strong foundation to extend my study further into the inner works of modern CPUs and modern instruction set architectures if necessary in the future.
