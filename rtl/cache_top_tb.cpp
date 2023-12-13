#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vcache_top.h"

int main(int argc, char **argv, char **env) {
    int simcyc;     // simulation clock count
    int tick;       // each clk cycle has two ticks for two edges

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vcache_top* top = new Vcache_top;

    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("cache_top.vcd");

    // initialize simulation input 
    top->iClk = 1;
    top->iRst = 0;
    top->iWriteEn = 0;
    top->iFlushAddress =0;
    top->iAddress =0;
    // run simulation for MAX_SIM_CYC clock cycles
    for (simcyc=0; simcyc<3000; simcyc++) 
    {
        // dump variables into VCD file and toggle clock
        for (tick=0; tick<2; tick++) 
        {
            tfp->dump (2*simcyc+tick);
            top->iClk = !top->iClk;
            top->eval ();
        }

        if (Verilated::gotFinish()) exit(0);
    }

    tfp->close(); 
    printf("Exiting\n");
    exit(0);
}