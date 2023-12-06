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

  output logic [1:0]     oForwardAluOp1,
  output logic [1:0]     oForwardAluOp2,
  output logic           oStallF,
  output logic           oStallD,
  output logic           oFlushE
);

  logic stall_d;
  logic stall_f;
  logic stall_e;
  logic flush_e;

  always_comb begin
    
    if (iInstructionTypeE == LOAD) begin
      if (iDestRegE == iSrcReg1D | iDestRegE == iSrcReg2D) begin
        stall_d = 1'b1;
        stall_e = 1'b1;
        flush_e = 1'b1;
      end

      else begin
        stall_d = 1'b0;
        stall_e = 1'b0;
        flush_e = 1'b0;
      end
    end


    //If destination register in memory stage is the same as source1 register in execution stage
    if      (iSrcReg1E != 5'b0 & iRegWriteEnM & iDestRegM == iSrcReg1E) oForwardAluOp1 = 2'b01;     //Forward data in memory stage to execution stage

    //If destinatino register in writeback stage is the same as source1 register in execution stage
    else if (iSrcReg1E != 5'b0 & iRegWriteEnW & iDestRegW == iSrcReg1E) oForwardAluOp1 = 2'b10;     //Forward writeback value to execution stage

    //If there is no data dependancy hazard for source register 1
    else                                                                oForwardAluOp1 = 2'b00;

    //If destination register in memory stage is the same as source2 register in execution stage
    if      (iSrcReg2E != 5'b0 & iRegWriteEnM & iDestRegM == iSrcReg2E) oForwardAluOp2 = 2'b01;     //Forward data in memory stage to execution stage

    //If destinatino register in writeback stage is the same as source2 register in execution stage
    else if (iSrcReg2E != 5'b0 & iRegWriteEnW & iDestRegW == iSrcReg2E) oForwardAluOp2 = 2'b10;     //Forward writeback value to execution stage

    //If there is no data dependancy hazard for source register 2
    else                                                                oForwardAluOp2 = 2'b00;

  end


endmodule
