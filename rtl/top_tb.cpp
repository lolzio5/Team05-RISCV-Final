#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vtop.h"
#include "vbuddy.cpp"
#include <string>

int main(int argc, char **argv, char **env) {
    int simcyc;     // simulation clock count
    int tick;       // each clk cycle has two ticks for two edges

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vtop* top = new Vtop;

    // Retrieve and load the program to be loaded into instruction memory
    std::string programFileName = argv[1];
    top->iFileName = programFileName;

    // init Vbuddy
    if (vbdOpen()!=1) return(-1);

    // Display the name of the program
    std::string programName;
    size_t lastDot = programFileName.find_last_of(".");
    programName = programFileName.substr(0,lastDot);
    vbdHeader(programName.c_str());
    
    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace (tfp, 99);
    tfp->open ("top.vcd");

    // initialize simulation input 
    top->iClk = 1;
    top->iRst = 0;

    // run simulation for MAX_SIM_CYC clock cycles
    for (simcyc=0; simcyc<1000000; simcyc++) 
    {
        // dump variables into VCD file and toggle clock
        for (tick=0; tick<2; tick++) 
        {
            tfp->dump (2*simcyc+tick);
            top->iClk = !top->iClk;
            top->eval ();
        }

        vbdBar(top->oRega0);
        vbdCycle(simcyc);

        if (Verilated::gotFinish() || vbdGetkey()=='q') exit(0);
    }
    vbdClose();
    tfp->close(); 
    printf("Exiting\n");
    exit(0);
}