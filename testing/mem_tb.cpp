#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vdatamem.h"
#include "Vdatamux.h"

#include <iostream>
int main(int argc, char **argv, char **env) {
  int simcyc;     // simulation clock count
  int tick;       // each clk cycle has two ticks for two edges

  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Vdatamem* top = new Vdatamem;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("datamem.vcd");
 

  // initialize simulation input 
  top->clk = 1;
  top->ResultSrc=0;       
  //top->WE=0;         
  top->A=0;
  top->WD=0;

  // run simulation for MAX_SIM_CYC clock cycles
  for (simcyc=0; simcyc<300; simcyc++) {
    // dump variables into VCD file and toggle clock
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->clk = !top->clk;
      top->eval ();
    }

    top->WE=1;
    top->A=43;
    top->WD=30;
    if(simcyc>5){
        top->WE=0;
    }
    

    // either simulation finished, or 'q' is pressed
    if (Verilated::gotFinish()) 
      exit(0);
  }

  tfp->close(); 
  printf("Exiting\n");
  exit(0);
}
