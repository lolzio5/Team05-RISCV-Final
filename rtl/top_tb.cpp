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
#include <iomanip>
#include <string>

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


void tick() {
    top->iClk = 0;
    top->eval();
    top->iClk = 1;
    top->eval();
    main_time++;
}

void reset() {
    top->iRst = 1;
    tick();
    top->iRst = 0;
}

void printSuccess(const std::string& instruction, const std::string& succMsg) {
    std::cout << std::left << std::setw(40) << instruction 
              << green << " [ " << checkMark << " ] " << rrr << succMsg << std::endl;
}

void printFail(const std::string& instruction, const std::string& failMsg) {
    std::cout << std::left << std::setw(40) << instruction 
              << red << " [ " << xMark << " ] " << rrr << failMsg << std::endl;
}

void testLI(int loadAddr , int dataIn, const std::string& instruction) {
    if (regFile->iDataIn != dataIn) {
        printFail(instruction, "LIfail : Data Input Different");
        return;
    }

    if (regFile->iWriteAddress != loadAddr) {
        printFail(instruction, "LIfail : Load Address Different");
        return;
    }

    if (regFile->iWriteEn != 1) {
        printFail(instruction, "LIfail : WriteEnable != 1");
        return;
    }

    if (regFile->ram_array[regFile->iWriteAddress] != regFile->iDataIn) {
        printFail(instruction, "LIfail : Loaded Value Not Equal to iDataIn");
        return;
    }
    printSuccess(instruction, "LI SUCCESS");
}

void testLBU(int rs1Addr, int offset, int rdAddr, const std::string& instruction) { // LBU rd, offset(rs1)
    int memAddr = rs1Addr + offset;
    if(regFile->iWriteEn != 1) {
        printFail(instruction, "LBUfail : WriteEn != 1");
        return;
    }

    if(regFile->iWriteAddress != rdAddr) {
        printFail(instruction, "LBUfail : rdAddr incorrect");
        return;
    }

    if(regFile->iDataIn != dataMem->mem_array[memAddr]) {
        printFail(instruction, "LBUfail : Load data incorrect");
        return;
    }
    printSuccess(instruction, "LBU SUCCESS");
}

void testADDI(int aluOp1Addr, int aluOp2, int writeAddress, const std::string& instruction) {
    int addiResult = static_cast<int>(regFile->ram_array[aluOp1Addr]) + aluOp2;
    if (alu->iAluControl != 0) {
        printFail(instruction, "ADDIfail : ALUcontrol != 0");
        return;
    }

    if(alu->iAluOp1 != regFile->ram_array[aluOp1Addr]) {
        printFail(instruction, "ADDIfail : ALUop1 Address different");
        return;
    }

    if(alu->iAluOp2 != aluOp2) {
        printFail(instruction, "ADDIfail : ALUop2 different");
        return;
    }

    if(alu->oAluResult != addiResult) {
        printFail(instruction, "ADDIfail : ALUresult different");
        return;
    }

    if(regFile->iWriteAddress != writeAddress) {
        printFail(instruction, "ADDIfail: WriteAddress different");
        return;
    }

    if(regFile->iWriteEn != 1) {
        printFail(instruction, "ADDIfail: WriteEnable != 1");
        return;
    }

    printSuccess(instruction, "ADDI PASS");
}

void testSLL(int readAddress, int shiftBy, int writeAddress, const std::string& instruction) {
    if(regFile->iReadAddress1 != readAddress) {
        printFail(instruction, "SLLfail: readAddress incorrect");
        return;
    }
    if(alu->iAluOp1 != regFile->ram_array[readAddress]) {
        printFail(instruction, "SLLfail: ALUop1 incorrect load");
        return;
    }
    if(alu->iAluOp2 != shiftBy) {
        printFail(instruction, "SLLfail: Shift factor incorrect");
        return;
    }
    if(alu->oAluResult != (regFile->ram_array[readAddress] << shiftBy)) {
        printFail(instruction, "SLLfail: Shift calculation incorrect");
        return;
    }
    printSuccess(instruction, "SLL PASS");
}

void testXOR(int rs1Addr, int rs2Addr, int WriteAddr , const std::string& instruction) {
    if(regFile->iReadAddress1 != rs1Addr) {
        printFail(instruction, "XORfail: rs1Addr incorrect");
        return;
    }
    if(regFile->iReadAddress2 != rs2Addr) {
        printFail(instruction, "XORfail: rs2Addr incorrect");
        return;
    }
    if(alu->iAluOp1 != regFile->ram_array[rs1Addr]) {
        printFail(instruction, "XORfail: ALUop1 incorrect load");
        return;
    }
    if(alu->iAluOp2 != regFile->ram_array[rs2Addr]) {
        printFail(instruction, "XORfail: ALUop2 incorrect load");
        return;
    }
    if(alu->oAluResult != (regFile->ram_array[rs1Addr] ^ regFile->ram_array[rs2Addr])) {
        printFail(instruction, "XORfail: XOR calculation incorrect");
        return;
    }
    if(regFile->iWriteAddress != WriteAddr || regFile->iWriteEn != 1) {
        printFail(instruction, "XORfail: Didnt write properly");
        return;
    }
    printSuccess(instruction, "XOR PASS");
}

void testBNE(int rs1Addr, int rs2Addr, int branchAddress, const std::string& instruction) {
    if (regFile->iReadAddress1 != rs1Addr) {
        printFail(instruction, "BNEfail : rs1Addr incorrect");
        return;
    }
    if (regFile->iReadAddress2 != rs2Addr) {
        printFail(instruction, "BNEfail : rs2Addr incorrect");
        return;
    }
    bool shouldBranch = regFile->ram_array[rs1Addr] != regFile->ram_array[rs2Addr];

    if(static_cast<int>(shouldBranch) != pcReg->iPCSrc) {
        printFail(instruction, "BNEfail : PCSrc incorrect");
        return;
    }
    int expectedPc = shouldBranch ? branchAddress : pcReg->oPC + 4;

    if (pcReg->PCNext != expectedPc) {
        printFail(instruction, "BNEfail : Next PC incorrect");
        return;
    }
    
    printSuccess(instruction, "BNE PASS");
}

void testJAL(int destinationRegisterAddr, int nextPC, const std::string& instruction) {
    if (pcReg->iPCSrc != 1) {
        printFail(instruction, "JALfail : PCSrc != 1");
        return;
    }

    if (regFile->iWriteAddress != destinationRegisterAddr) {
        printFail(instruction, "JALfail : destinationRegisterAddr incorrect");
        return;
    }

    if (regFile->iWriteEn != 1) {
        printFail(instruction, "JALfail : WriteEn != 1");
        return;
    }

    if ((static_cast<int>(pcReg->oPC) + 4) != regFile->iDataIn) {
        printFail(instruction, "JALfail : data to be stored in destinationRegister incorrect");
        return;
    }

    if (pcReg->PCNext != nextPC) {
        printFail(instruction, "JALfail : JUMP Target address incorrect");
        return;
    }
    printSuccess(instruction, "JAL PASS");
}

void testJALR(int destinationRegisterAddr, int baseRegisterAddr, int offset , const std::string& instruction) {
    
    if (pcReg->iPCSrc != 1) {
        printFail(instruction, "JALRfail : PCSrc != 1");
        return;
    }

    if (regFile->iWriteEn != 1) {
        printFail(instruction, "JALRfail : iWriteEn != 1");
        return;
    }

    if (regFile->iWriteAddress != destinationRegisterAddr) {
        printFail(instruction, "JALRfail : destinationRegisterAddr incorrect");
        return;
    }

    if (regFile->iReadAddress1 != baseRegisterAddr) {
        printFail(instruction, "JALRfail : baseRegisterAddr incorrect");
        return;
    }

    if (regFile->iDataIn != static_cast<int>(pcReg->oPC) + 4) {
        printFail(instruction, "JALRfail : Data being stored incorrect");
        return;
    }

    if (pcReg->PCNext != (static_cast<int>(regFile->oRegData1) + offset)) {
        printFail(instruction, "JALRfail : JUMP Target address incorrect");
        return;
    }
    printSuccess(instruction, "JALR PASS");

}

void testADD(int rs1Addr, int rs2Addr, int destAddr, const std::string& instruction) {
    int expectedResult = static_cast<int>(regFile->ram_array[rs1Addr]) + static_cast<int>(regFile->ram_array[rs2Addr]);

    if(alu->iAluOp1 != regFile->ram_array[rs1Addr]) {
        printFail(instruction, "ADDfail: ALUop1 incorrect");
        return;
    }

    if(alu->iAluOp2 != regFile->ram_array[rs2Addr]) {
        printFail(instruction, "ADDfail: ALUop2 incorrect");
        return;
    }

    if(alu->oAluResult != expectedResult) {
        printFail(instruction, "ADDfail: Result incorrect");
        return;
    }

    if(regFile->iWriteAddress != destAddr) {
        printFail(instruction, "ADDfail: Destination Register incorrect");
        return;
    }

    if(regFile->iWriteEn != 1) {
        printFail(instruction, "ADDfail: Write Enable not set");
        return;
    }

    printSuccess(instruction, "ADD PASS");
}

void testSB(int srcAddr, int baseAddr, int offset, const std::string& instruction) {
    int memAddr = baseAddr + offset;

    if(dataMem->iWriteEn != 1) {
        printFail(instruction, "SBfail: WriteEn != 1");
        return;
    }

    if(dataMem->iMemData != regFile->ram_array[srcAddr]) {
        printFail(instruction, "SBfail: iMemData incorrect");
        return;
    }

    if(dataMem->iAddress != memAddr) {
        printFail(instruction, "SBfail: iAddress incorrect");
        return;
    }

    printSuccess(instruction, "SB PASS");
}



void printSuccessEnding(const std::string& succMsg) {
        std::cout << green << " \n [ " << checkMark << " ] " << rrr << succMsg << std::endl;
}

int main(int argc, char **argv, char **env) {
    printf("\n \nWelcome to Single Cycle CPU Testbench, \n \n");
    Verilated::commandArgs(argc, argv);

    const int alignAt = 50; // Position at which the test markers should start
    
    reset();
    std::cout << "main:\n";
    testLI(
        5, //load addr (t0)
        4, //load value
        "    li    t0, 10" //insn
    );
    tick();
    testADDI(
        0, //aluop1addr
        2, //aluop2
        6, //write addr
        "    addi    t1, zero, 2" //insn
    );
    std::cout << "\n";

    tick();
    std::cout << "loop:\n";
    testADDI(
        6,
        1,
        6,
        "    addi    t1, t1, 1"
    );

    tick();
    testSLL(
        6, //rs1addr
        1, //shiftby
        7, //writeaddr
        "    sll     t2, t1, 1" //insn
    );

    tick();
    testXOR(
        7,
        6,
        28, //t3 = x28
        "    xor     t3, t2, t1"
    );

    tick();
    testBNE(
        6, //t1 addr
        5, //t0 addr
        8, //branch addr
        "    bne     t1, t0, loop" //insn
    );

    tick();
    std::cout << "\n";

    std::cout << "loop:\n";
    testADDI(
        6,
        1,
        6,
        "    addi    t1, t1, 1"
    );

    tick();
    testSLL(
        6, //rs1addr
        1, //shiftby
        7, //writeaddr
        "    sll     t2, t1, 1" //insn
    );

    tick();
    testXOR(
        7,
        6,
        28, //t3 = x28
        "    xor     t3, t2, t1"
    );

    tick();
    testBNE(
        6, //t1 addr
        5, //t0 addr
        8, //branch addr
        "    bne     t1, t0, loop" //insn
    );

    tick();
    testJAL(
        1,
        32,
        "    jal     x1, func"
    );

    std::cout << "\n";

    std::cout << "func:\n";
    tick();
    testADDI(
        0,
        5,
        29,
        "    addi    t4, zero, 5"
    );

    tick();
    testJALR(
        0,
        1,
        0,
        "    jalr    zero, x1, 0"
    );

    tick();
    testADDI(
        6,
        100,
        6,
        "\n    addi t1, t1, 100"
    );

    printSuccessEnding("All instructions ran successfully and correctly.");

    delete top;
    printf("\nTested CPU for %llu cycles.\nEnd of testbench, exiting.\n \n", main_time);
    exit(0);
}
