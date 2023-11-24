#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vpcreg.h"
#include "Vpcmux.h"

#include <iostream>
int main(int argc, char **argv, char **env) {
  int simcyc;     // simulation clock count
  int tick;       // each clk cycle has two ticks for two edges

  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Vpcreg* top = new Vpcreg;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("pcreg.vcd");
 

  // initialize simulation input 
  uint32_t imm=8;
  top->clk = 1;
  top->rst = 1;
  top->ImmExt = imm;
  top->PCSrc = 1;

  // run simulation for MAX_SIM_CYC clock cycles
  for (simcyc=0; simcyc<300; simcyc++) {
    // dump variables into VCD file and toggle clock
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->clk = !top->clk;
      top->eval ();
    }
    top->rst=0;
    if (top->PCSrc){
      top->PCSrc=0;
    }
    else{
      top->PCSrc=1;
    }

    // either simulation finished, or 'q' is pressed
    if (Verilated::gotFinish()) 
      exit(0);
  }

  std::cout<<"it worked"<<std::endl;
  

  tfp->close(); 
  printf("Exiting\n");
  exit(0);
}