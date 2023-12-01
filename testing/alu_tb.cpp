#include "Valu.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv, char **env){
    Verilated::commandArgs(argc, argv);
    Valu* top = new Valu;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("alu.vcd");

    top->ALUControl =0;
    top->SrcA =1;
    top->SrcB =1;

}
