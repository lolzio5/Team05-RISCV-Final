`include "include/ControlTypeDefs.svh"
module HazardUnit (
  input  InstructionType iInstructionTypeE,
  input  logic [4:0]     iDestRegE,
  input  logic [4:0]     iDestRegM,
  input  logic [4:0]     iDestRegW,
  input  logic           iRegWriteEnM,
  input  logic           iRegWriteEnW,

  input  logic [4:0]     iSrcReg1D,
  input  logic [4:0]     iSrcReg2D,

  input  logic [4:0]     iSrcReg1E,
  input  logic [4:0]     iSrcReg2E,

  output logic [1:0]     oForwardAluOp1E,
  output logic [1:0]     oForwardAluOp2E,
  output logic           oForwardCompOp1D,
  output logic           oForwardCompOp2D,
  output logic           oStallF,
  output logic           oStallD,
  output logic           oFlushE
);


  always_comb begin
    
    oForwardAluOp1 = 2'b00;
    oForwardAluOp2 = 2'b00;
    oStallF = 1'b0;
    oStallE = 1'b0;
    oFlushE = 1'b0;

    //---------------------------------Check For Load Data Dependancy------------------------
    if (iInstructionTypeE == LOAD) begin 
      if (iDestRegE == iSrcReg1D | iDestRegE == iSrcReg2D) begin //Load Dependancy Detected
        oStallF = 1'b1;
        oStallE = 1'b1;
        oFlushE = 1'b1; //If flush is high iSrcReg1E and iSrcReg2E would be both 0 in the next clock cycle
      end  // Important for forwarding load value to execution stage - if reg wasnt flushed, there may be a chance that the statements following this (that compute what to forward) may end up forwarding the wrong thing since decode and fetch are stalled and execution stage holds values for the load instruction
    end


    //-------------------- Handle RAW Data Hazard Due To Branch Instructions-----------------
    if (iSrcReg1D != 5'b0 & iRegWriteEnM & iDestRegM == iSrcReg1D)      oForwardCompOp1D = 1'b1;
    else                                                                oForwardCompOp1D = 1'b0;

    if (iSrcReg2D != 5'b0 & iRegWriteEnM & iDestRegM == iSrcReg2D)      oForwardCompOp2D = 1'b1;
    else                                                                oForwardCompOp2D = 1'b0;


    //-------------------- Handle RAW Data Hazard Due To Other Instructions-----------------

    //If destination register in memory stage is the same as source1 register in execution stage
    if      (iSrcReg1E != 5'b0 & iRegWriteEnM & iDestRegM == iSrcReg1E) oForwardAluOp1 = 2'b01;    //Forward data in memory stage to execution stage
    else if (iSrcReg1E != 5'b0 & iRegWriteEnW & iDestRegW == iSrcReg1E) oForwardAluOp1 = 2'b10;    //Forward writeback value to execution stage
    else                                                                oForwardAluOp1 = 2'b00;    //If there is no data dependancy hazard for source register 1

    //If destination register in memory stage is the same as source2 register in execution stage
    if      (iSrcReg2E != 5'b0 & iRegWriteEnM & iDestRegM == iSrcReg2E) oForwardAluOp2 = 2'b01;     //Forward data in memory stage to execution stage
    else if (iSrcReg2E != 5'b0 & iRegWriteEnW & iDestRegW == iSrcReg2E) oForwardAluOp2 = 2'b10;     //Forward writeback value to execution stage
    else                                                                oForwardAluOp2 = 2'b00;     //If there is no data dependancy hazard for source register 2



  end


endmodule
