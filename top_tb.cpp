#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vtop.h"
#include "Vtop_top.h"
#include "Vtop_Alu.h"
#include "Vtop_ControlUnit.h"
#include "Vtop_RegisterFile.h"
#include "Vtop_PCRegister.h"
#include "Vtop_DataMemory.h"
#include "Vtop_InstructionMemory.h"
#include "Vtop_ResultMux.h"
#include <iostream>
#include <fstream>
#include <sstream>
#include <unordered_map>
#include <string>
#include <vector>
#include <iomanip>
#include <string>
#include <cctype>

Vtop* top = new Vtop();
vluint64_t main_time = 0;

Vtop_Alu* alu = top->top->Alu;
Vtop_ControlUnit* controlUnit = top->top->ControlUnit;
Vtop_DataMemory* dataMem = top->top->DataMemory;
Vtop_InstructionMemory* insMem = controlUnit->InstructionMem;
Vtop_PCRegister* pcReg = top->top->PCRegister;
Vtop_RegisterFile* regFile = top->top->RegisterFile;

double sc_time_stamp() { 
    return main_time; 
}

const std::string green = "\033[32m";
const std::string red = "\033[31m";
const std::string rrr = "\033[0m";
const char* checkMark = "\u2713";
const char* xMark = "\u2716";

std::unordered_map<std::string, int> registerMap = {
    {"zero", 0}, {"x0", 0},
    {"ra", 1}, {"x1", 1},
    {"sp", 2}, {"x2", 2},
    {"gp", 3}, {"x3", 3},
    {"tp", 4}, {"x4", 4},
    {"t0", 5}, {"x5", 5},
    {"t1", 6}, {"x6", 6},
    {"t2", 7}, {"x7", 7},
    {"s0", 8}, {"fp", 8}, {"x8", 8},
    {"s1", 9}, {"x9", 9},
    {"a0", 10}, {"x10", 10},
    {"a1", 11}, {"x11", 11},
    {"a2", 12}, {"x12", 12},
    {"a3", 13}, {"x13", 13},
    {"a4", 14}, {"x14", 14},
    {"a5", 15}, {"x15", 15},
    {"a6", 16}, {"x16", 16},
    {"a7", 17}, {"x17", 17},
    {"s2", 18}, {"x18", 18},
    {"s3", 19}, {"x19", 19},
    {"s4", 20}, {"x20", 20},
    {"s5", 21}, {"x21", 21},
    {"s6", 22}, {"x22", 22},
    {"s7", 23}, {"x23", 23},
    {"s8", 24}, {"x24", 24},
    {"s9", 25}, {"x25", 25},
    {"s10", 26}, {"x26", 26},
    {"s11", 27}, {"x27", 27},
    {"t3", 28}, {"x28", 28},
    {"t4", 29}, {"x29", 29},
    {"t5", 30}, {"x30", 30},
    {"t6", 31}, {"x31", 31}
};


std::unordered_map<std::string, int> labelMap;
std::vector<std::string> instructions;
int programCounter = 0;
int successfulCycles = 0;
int failedCycles = 0;


int getRegisterAddress(const std::string& regName) {
    std::string cleanedRegName = regName;
    if (!cleanedRegName.empty() && cleanedRegName.back() == ',') {
        cleanedRegName.pop_back();
    }

    auto it = registerMap.find(cleanedRegName);
    if (it != registerMap.end()) {
        return it->second;
    }

    std::cerr << "Unknown register: " << regName << std::endl;
    exit(1);
}

void tick() {
    top->iClk = 1;
    top->eval();
    top->iClk = 0;
    top->eval();
    main_time++;
}

void reset() {
    top->iRst = 1;
    tick();
    top->iRst = 0;
}

void printSuccess(const std::string& instruction, const std::string& succMsg) {
    std::cout << std::left << std::setw(45) << instruction 
              << green << " [ " << checkMark << " ] " << rrr << succMsg << std::endl;
    successfulCycles++;
}

void printFail(const std::string& instruction, const std::string& failMsg) {
    std::cout << std::left << std::setw(40) << instruction 
              << red << " [ " << xMark << " ] " << rrr << failMsg << std::endl;
    failedCycles++;
}

bool testLI(int loadAddr , int dataIn, const std::string& instruction) {
    if (regFile->iDataIn != dataIn) {
        printFail(instruction, "LIfail : Data Input Different");
        return false;
    }

    if (regFile->iWriteAddress != loadAddr) {
        printFail(instruction, "LIfail : Load Address Different");
        return false;
    }

    if (regFile->iWriteEn != 1) {
        printFail(instruction, "LIfail : WriteEnable != 1");
        return false;
    }

    printSuccess(instruction, "LI SUCCESS");
    return true;
}

bool testLBU(int rs1Addr, int offset, int rdAddr, const std::string& instruction) { // LBU rd, offset(rs1)
    int memAddr = regFile->ram_array[rs1Addr] + offset;
    if(regFile->iWriteEn != 1) {
        printFail(instruction, "LBUfail : WriteEn != 1");
        return false;
    }

    if(regFile->iWriteAddress != rdAddr) {
        printFail(instruction, "LBUfail : rdAddr incorrect");
        return false;
    }

    if(regFile->iDataIn != dataMem->mem_array[memAddr]) {
        std::cout << "regFile->iDataIn: " << regFile->iDataIn << std::endl;
        std::cout << "dataMem->mem_array[memAddr]: " << dataMem->mem_array[memAddr] << " " <<  memAddr << std::endl;

        printFail(instruction, "LBUfail : Load data incorrect");
        return false;
    }
    printSuccess(instruction, "LBU SUCCESS");
    return true;
}

bool testADDI(int aluOp1Addr, int aluOp2, int writeAddress, const std::string& instruction) {
    int addiResult = static_cast<int>(regFile->ram_array[aluOp1Addr]) + aluOp2;
    if (alu->iAluControl != 0) {
        printFail(instruction, "ADDIfail : ALUcontrol != 0");
        return false;
    }

    if(alu->iAluOp1 != regFile->ram_array[aluOp1Addr]) {
        printFail(instruction, "ADDIfail : ALUop1 Address different");
        return false;
    }

    if(alu->iAluOp2 != aluOp2) {
        printFail(instruction, "ADDIfail : ALUop2 different");
        return false;
    }

    if(alu->oAluResult != addiResult) {
        printFail(instruction, "ADDIfail : ALUresult different");
        return false;
    }

    if(regFile->iWriteAddress != writeAddress) {
        printFail(instruction, "ADDIfail: WriteAddress different");
        return false;
    }

    if(regFile->iWriteEn != 1) {
        printFail(instruction, "ADDIfail: WriteEnable != 1");
        return false;
    }

    printSuccess(instruction, "ADDI PASS");
    return true;
}

bool testSLL(int readAddress, int shiftBy, int writeAddress, const std::string& instruction) {
    if(regFile->iReadAddress1 != readAddress) {
        printFail(instruction, "SLLfail: readAddress incorrect");
        return false;
    }
    if(alu->iAluOp1 != regFile->ram_array[readAddress]) {
        printFail(instruction, "SLLfail: ALUop1 incorrect load");
        return false;
    }
    if(alu->iAluOp2 != shiftBy) {
        printFail(instruction, "SLLfail: Shift factor incorrect");
        return false;
    }
    if(alu->oAluResult != (regFile->ram_array[readAddress] << shiftBy)) {
        printFail(instruction, "SLLfail: Shift calculation incorrect");
        return false;
    }
    printSuccess(instruction, "SLL PASS");
    return true;
}

bool testXOR(int rs1Addr, int rs2Addr, int WriteAddr , const std::string& instruction) {
    if(regFile->iReadAddress1 != rs1Addr) {
        printFail(instruction, "XORfail: rs1Addr incorrect");
        return false;
    }
    if(regFile->iReadAddress2 != rs2Addr) {
        printFail(instruction, "XORfail: rs2Addr incorrect");
        return false;
    }
    if(alu->iAluOp1 != regFile->ram_array[rs1Addr]) {
        printFail(instruction, "XORfail: ALUop1 incorrect load");
        return false;
    }
    if(alu->iAluOp2 != regFile->ram_array[rs2Addr]) {
        printFail(instruction, "XORfail: ALUop2 incorrect load");
        return false;
    }
    if(alu->oAluResult != (regFile->ram_array[rs1Addr] ^ regFile->ram_array[rs2Addr])) {
        printFail(instruction, "XORfail: XOR calculation incorrect");
        return false;
    }
    if(regFile->iWriteAddress != WriteAddr || regFile->iWriteEn != 1) {
        printFail(instruction, "XORfail: Didnt write properly");
        return false;
    }
    printSuccess(instruction, "XOR PASS");
    return true;
}

bool testBNE(int rs1Addr, int rs2Addr, int branchAddress, const std::string& instruction) {
    if (regFile->iReadAddress1 != rs1Addr) {
        printFail(instruction, "BNEfail : rs1Addr incorrect");
        return false;
    }
    if (regFile->iReadAddress2 != rs2Addr) {
        printFail(instruction, "BNEfail : rs2Addr incorrect");
        return false;
    }
    bool shouldBranch = regFile->ram_array[rs1Addr] != regFile->ram_array[rs2Addr];

    if(static_cast<int>(shouldBranch) != pcReg->iPCSrc) {
        printFail(instruction, "BNEfail : PCSrc incorrect");
        return false;
    }
    int expectedPc = shouldBranch ? branchAddress : pcReg->oPC + 4;

    if (pcReg->PCNext != expectedPc) {
        printFail(instruction, "BNEfail : Next PC incorrect");
        return false;
    }
    
    printSuccess(instruction, "BNE PASS");

    if(shouldBranch) {
        return true;
    }

    return false;
    
}

bool testBEQ(int rs1Addr, int rs2Addr, int branchAddress, const std::string& instruction) {
    if (regFile->iReadAddress1 != rs1Addr) {
        printFail(instruction, "BEQfail : rs1Addr incorrect");
        return false;
    }
    if (regFile->iReadAddress2 != rs2Addr) {
        printFail(instruction, "BEQfail : rs2Addr incorrect");
        return false;
    }
    bool shouldBranch = regFile->ram_array[rs1Addr] == regFile->ram_array[rs2Addr];

    if(static_cast<int>(shouldBranch) != pcReg->iPCSrc) {
        printFail(instruction, "BEQfail : PCSrc incorrect");
        return false;
    }
    int expectedPc = shouldBranch ? branchAddress : pcReg->oPC + 4;

    if (pcReg->PCNext != expectedPc) {
        printFail(instruction, "BEQfail : Next PC incorrect");
        return false;
    }
    
    printSuccess(instruction, "BEQ PASS");

    if(shouldBranch) {
        return true;
    }

    return false;
    
}

bool testJAL(int destinationRegisterAddr, int nextPC, const std::string& instruction) {
    if (pcReg->iPCSrc != 1) {
        printFail(instruction, "JALfail : PCSrc != 1");
        return false;
    }

    if (regFile->iWriteAddress != destinationRegisterAddr) {
        printFail(instruction, "JALfail : destinationRegisterAddr incorrect");
        return false;
    }

    if (regFile->iWriteEn != 1) {
        printFail(instruction, "JALfail : WriteEn != 1");
        return false;
    }

    if ((static_cast<int>(pcReg->oPC) + 4) != regFile->iDataIn) {
        printFail(instruction, "JALfail : data to be stored in destinationRegister incorrect");
        return false;
    }

    if (pcReg->PCNext != nextPC) {
        printFail(instruction, "JALfail : JUMP Target address incorrect");
        return false;
    }
    printSuccess(instruction, "JAL PASS");
    return true;
}

bool testJALR(int destinationRegisterAddr, int baseRegisterAddr, int offset , const std::string& instruction) {
    
    if (pcReg->iPCSrc != 1) {
        printFail(instruction, "JALRfail : PCSrc != 1");
        return false;
    }

    if (regFile->iWriteEn != 1) {
        printFail(instruction, "JALRfail : iWriteEn != 1");
        return false;
    }

    if (regFile->iWriteAddress != destinationRegisterAddr) {
        printFail(instruction, "JALRfail : destinationRegisterAddr incorrect");
        return false;
    }

    if (regFile->iReadAddress1 != baseRegisterAddr) {
        printFail(instruction, "JALRfail : baseRegisterAddr incorrect");
        return false;
    }

    if (regFile->iDataIn != static_cast<int>(pcReg->oPC) + 4) {
        printFail(instruction, "JALRfail : Data being stored incorrect");
        return false;
    }

    if (pcReg->PCNext != (static_cast<int>(regFile->oRegData1) + offset)) {
        printFail(instruction, "JALRfail : JUMP Target address incorrect");
        return false;
    }
    printSuccess(instruction, "JALR PASS");
    return true;

}

bool testADD(int rs1Addr, int rs2Addr, int destAddr, const std::string& instruction) {
    int expectedResult = static_cast<int>(regFile->ram_array[rs1Addr]) + static_cast<int>(regFile->ram_array[rs2Addr]);

    if(alu->iAluOp1 != regFile->ram_array[rs1Addr]) {
        printFail(instruction, "ADDfail: ALUop1 incorrect");
        return false;
    }

    if(alu->iAluOp2 != regFile->ram_array[rs2Addr]) {
        printFail(instruction, "ADDfail: ALUop2 incorrect");
        return false;
    }

    if(alu->oAluResult != expectedResult) {
        printFail(instruction, "ADDfail: Result incorrect");
        return false;
    }

    if(regFile->iWriteAddress != destAddr) {
        printFail(instruction, "ADDfail: Destination Register incorrect");
        return false;
    }

    if(regFile->iWriteEn != 1) {
        printFail(instruction, "ADDfail: Write Enable not set");
        return false;
    }

    printSuccess(instruction, "ADD PASS");
    return true;
}

bool testSB(int srcAddr, int baseAddr, int offset, const std::string& instruction) {
    int memAddr = regFile->ram_array[baseAddr] + offset;
    int expectedByte = regFile->ram_array[srcAddr];

    if(dataMem->iWriteEn != 1) {
        printFail(instruction, "SBfail: WriteEn != 1");
        return false;
    }

    if(dataMem->iMemData != expectedByte) {
        std::cout << "dataMem: " << dataMem->iMemData << std::endl;
        std::cout << "expectedByte: " << expectedByte << std::endl;

        printFail(instruction, "SBfail: iMemData incorrect");
        return false;
    }

    if(dataMem->iAddress != memAddr) {
        printFail(instruction, "SBfail: iAddress incorrect");
        return false;
    }

    printSuccess(instruction, "SB PASS");
    return true;
}

void printSuccessEnding(const std::string& succMsg) {
        std::cout << green << " \n [ " << checkMark << " ] " << rrr << succMsg << std::endl;
}



int getJumpAddress(const std::string& name) {
    // Remove trailing comma, if any, for uniformity
    std::string cleanedName = name;
    if (!cleanedName.empty() && cleanedName.back() == ',') {
        cleanedName.pop_back();
    }

    // First, check in the labelMap
    auto labelIt = labelMap.find(cleanedName);
    if (labelIt != labelMap.end()) {
        return labelIt->second;  // Found in labelMap, return the address
    }

    // If not found in labelMap, check in the registerMap
    auto registerIt = registerMap.find(cleanedName);
    if (registerIt != registerMap.end()) {
        return registerIt->second;  // Found in registerMap, return the register address
    }

    // If not found in both maps
    std::cerr << "Unknown label or register: " << name << std::endl;
    exit(1);
}
std::unordered_map<std::string, int> constant_map;


int parseStringToInt(const std::string& str) {
    try {
        size_t pos = 0;
        int base = (str.size() > 2 && (str.substr(0, 2) == "0x" || str.substr(0, 2) == "0X")) ? 16 : 10;
        return std::stoi(str, &pos, base);
    } catch (const std::invalid_argument& e) {
        // If parsing as number fails, look it up in the constant map
        auto it = constant_map.find(str);
        if (it != constant_map.end()) {
            return it->second;
        } else {
            std::cerr << "Invalid argument: " << e.what() << std::endl;
            return 0; // Or use a more appropriate error handling
        }
    } catch (const std::out_of_range& e) {
        std::cerr << "Out of range: " << e.what() << std::endl;
        return 0; // Or use a more appropriate error handling
    }
}


std::string rtrim(const std::string &s) {
    size_t end = s.find_last_not_of(" \t");
    return (end == std::string::npos) ? "" : s.substr(0, end + 1);
}
void parseAndAddConstant(const std::string& line) {
    // Check if the line starts with .equ directive
    if (line.rfind(".equ", 0) == 0) {
        std::istringstream iss(line.substr(4)); // Skip the .equ part
        std::string constantName;
        std::string constantValue;

        // Extract constant name and value
        if (std::getline(iss >> std::ws, constantName, ',') && std::getline(iss >> std::ws, constantValue)) {
            try {
                // Convert constant value to integer
                int value = std::stoi(constantValue, nullptr, 0); // 0 as base to auto-detect hex/dec
                constant_map[constantName] = value;
            } catch (const std::exception& e) {
                std::cerr << "Error parsing constant value: " << e.what() << std::endl;
            }
        }
    }
}

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

    else if (instr == "addi") {
        if (args.size() != 3) {
            std::cerr << "Error: Invalid arguments for 'addi'" << std::endl;
            return;
        }

        int rd = getRegisterAddress(args[0]);
        int rs1 = getRegisterAddress(args[1]);
        int immVal = parseStringToInt(args[2]);
        testADDI(rs1, immVal, rd, line);

        programCounter++;
    }

    else if (instr == "add") {
        if (args.size() != 3) {
            std::cerr << "Error: Invalid arguments for 'add'" << std::endl;
            return;
        }

        int rd = getRegisterAddress(args[0]);
        int rs1 = getRegisterAddress(args[1]);
        int rs2 = getRegisterAddress(args[2]);

        testADD(rs1, rs2, rd, line);

        programCounter++;
    }


    else if (instr == "jal") {
        if (args.size() != 2) {
            std::cerr << "Error: Invalid arguments for 'jal'" << std::endl;
            return;
        }

        int rd = getRegisterAddress(args[0]);
        int jumpAddr = getJumpAddress(args[1]) * 4;

        if (testJAL(rd, jumpAddr, line)) {
            programCounter = jumpAddr / 4;
        }
        else {
            programCounter++;
        }

        std::cout << "\n    Jumping JAL .. \n" << std::endl;
    }

    else if (instr == "jalr") {
        if (args.size() != 3) {
            std::cerr << "Error: Invalid arguments for 'jalr'" << std::endl;
            return;
        }

        int rd = getRegisterAddress(args[0]);
        int rs1 = getRegisterAddress(args[1]);
        int offset = parseStringToInt(args[2]);
        int jumpAddr = regFile->ram_array[rs1] / 4;
      
        if (testJALR(rd, rs1, offset, line)) {
            programCounter = jumpAddr + offset; // Assuming offset is added to rs1
        }
        else {
            programCounter++;
        }
        std::cout << "\n    Jumping JALR .. \n" << std::endl;
    }

    else if (instr == "ret") {
    if (args.size() != 0) {
        std::cerr << "Error: 'ret' should not have any arguments" << std::endl;
        return;
    }

    // In the RISC-V ISA, 'ret' is a pseudoinstruction for 'jalr x0, x1, 0'.
    // x0 is always 0 (zero register), x1 is the link register, and the offset is 0.
    int rd = 0; // x0, the zero register
    int rs1 = 1; // x1, the link register (return address)
    int offset = 0; // The offset for 'ret' is always 0

    if (testJALR(rd, rs1, offset, line)) {
        programCounter = (regFile->ram_array[rs1] + offset) / 4; // Assuming PC is in word addresses
    }
    else {
        programCounter++;
    }
}
    else if (instr == "lbu") {
        if (args.size() != 2) {
            std::cerr << "Error: Invalid arguments for 'lbu'" << std::endl;
            return;
        }
        int rd = getRegisterAddress(args[0]);
        std::size_t paren_pos = args[1].find('(');
        if (paren_pos == std::string::npos || args[1].back() != ')') {
            std::cerr << "Error: Invalid memory address format in 'lbu'" << std::endl;
            return;
        }
        int offset = parseStringToInt(args[1].substr(0, paren_pos));
        int rs1 = getRegisterAddress(args[1].substr(paren_pos + 1, args[1].length() - paren_pos - 2));
        std::cout << rs1 << " " << offset << " " << rd << " " << std::endl;
        testLBU(rs1, offset, rd, line);
        programCounter++;
    }



    else if (instr == "sb") {
        if (args.size() != 2) {
            std::cerr << "Error: Invalid arguments for 'sb'" << std::endl;
            return;
        }
        int rs2 = getRegisterAddress(args[0]);
        std::size_t paren_pos = args[1].find('(');
        if (paren_pos == std::string::npos || args[1].back() != ')') {
            std::cerr << "Error: Invalid memory address format in 'sb'" << std::endl;
            return;
        }
        int offset = parseStringToInt(args[1].substr(0, paren_pos));
        int rs1 = getRegisterAddress(args[1].substr(paren_pos + 1, args[1].length() - paren_pos - 2));
        std::cout << rs2 << ", " << rs1 << ", " << offset << std::endl;
        testSB(rs2, rs1, offset, line);
        programCounter++;
    }


    else if (instr == "sll") {
        if (args.size() != 3) {
            std::cerr << "Error: Invalid arguments for 'sll'" << std::endl;
            return;
        }

        int rd = getRegisterAddress(args[0]);
        int rs1 = getRegisterAddress(args[1]);
        int shamt = parseStringToInt(args[2]);
        testSLL(rs1, shamt, rd, line);

        programCounter++;
    }


    else if (instr == "xor") {
        if (args.size() != 3) {
            std::cerr << "Error: Invalid arguments for 'xor'" << std::endl;
            return;
        }

        int rd = getRegisterAddress(args[0]);
        int rs1 = getRegisterAddress(args[1]);
        int rs2 = getRegisterAddress(args[2]);

        testXOR(rs1, rs2, rd, line);

        programCounter++;
    }

}

void checkAndPrintLabel(const std::unordered_map<std::string, int>& labelMap, int programCounter) {
    for (const auto& label : labelMap) {
        if (label.second == programCounter) {
            std::cout << label.first << ": " << std::endl;
            return;
        }
    }
}

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


int main(int argc, char **argv, char **env) {
    printf("\n \nWelcome to Single Cycle CPU Testbench, \n \n");
    Verilated::commandArgs(argc, argv);
    
    std::string filename = "/Users/songmeric/Desktop/riscv/Team05-RISCV-Final/test/TestPrograms/insTests/test.s";
    readAssemblyFile(filename);
    parseAssembly();
    

    printSuccessEnding("All instructions ran successfully and correctly.");

    delete top;
    printf("\nTested CPU for %llu cycles.\nSuccessful Cycles: %d \nFailed Cycles: %d \nEnd of testbench, exiting.\n \n", main_time, successfulCycles, failedCycles);
    exit(0);
}