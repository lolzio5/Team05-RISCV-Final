#include "VControlUnit.h" //header for the counter module
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char **argv, char **env)
{
  int i; //number of clock cycles to simulate
  int clk; //module clk signal

  Verilated::commandArgs(argc, argv);
  VControlUnit* cu = new VControlUnit;

  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;

  gen->trace (tfp, 99);
  tfp->open ("ControlUnit.vcd");

  for( i = 0 ; i < 10000000 ; i++)
  {

    //dump variables into VCD file and toggle clock
      for(clk = 0 ; clk < 2 ; clk++)
      {
        tfp->dump (2*i + clk); //unit is in pico seconds
        ControlUnit->clk = !gen->clk;
        gen->eval ();
      }

    vbdPlot(int(gen->dout), 0, 255);
    vbdCycle(i+1);

    gen->en = vbdFlag();
    gen->incr = vbdValue();
    
    // either sim is done or q is pressed 
    if((Verilated::gotFinish()) || (vbdGetkey()=='q')) 
      exit(0);

  }
}