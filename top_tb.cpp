#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vtop.h"
#include "Vpcreg.h"
#include "Vpcmux.h"
#include "Vdatamem.h"
#include "Vdatamux.h"
#include "Valu.h"
#include "Valu_top.h"
#include "Vmux.h"
#include "Vregister.h"
#include "VControlUnit.h"
#include "VControlPath.h"
#include "VSignExtend.h"
#include "VROM.h"
#include "VAluEncode.h"
#include "VControlDecode.h"
#include "VImmDecode.h"
#include "VInstructionDecode.h"


int main(int argc, char **argv, char **env) {
    int simcyc;     // simulation clock count
    int tick;       // each clk cycle has two ticks for two edges

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vtop* top = new Vtop;
    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("top.vcd");
 
    // init Vbuddy
    if (vbdOpen()!=1) return(-1);
    vbdHeader("Single Cycle CPU");
    vbdSetMode(1);

    // initialize simulation input 
    top->clk = 1;
    top->rst = 1;
    top->trigger = 1;

    // run simulation for MAX_SIM_CYC clock cycles
    for (simcyc=0; simcyc<300; simcyc++) {
        // dump variables into VCD file and toggle clock
        for (tick=0; tick<2; tick++) {
            tfp->dump (2*simcyc+tick);
            top->clk = !top->clk;
            top->eval ();
        }
        top->rst=0;

        vbdBar(top->data_out);
    
        vbdCycle(simcyc);

        if (Verilated::gotFinish()) exit(0);
    }

    vbdClose();
    tfp->close(); 
    printf("Exiting\n");
    exit(0);
}