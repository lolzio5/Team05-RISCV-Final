`include "include/ControlTypeDefs.svh"
module ControlUnit(
  input  logic [31:0]        iPC,
  input  logic               iZero,
  input  string              iFileName,

  output InstructionTypes    oInstructionType,
  output InstructionSubTypes oInstructionSubType,

  output logic [31:0]        oImmExt,
  output logic               oRegWrite,
  output logic               oMemWrite,

  output logic [ 3:0]        oAluControl,  
  output logic [ 2:0]        oResultSrc,
  output logic               oAluSrc,
  output logic               oPCSrc,

  output logic [ 4:0]        oRs1,
  output logic [ 4:0]        oRs2,
  output logic [ 4:0]        oRd
);

////////////////////////////////
////      Internal Logic    ////
////////////////////////////////

  logic [31:0] current_instruction;


////////////////////////////////
//// Instruction Memory ROM ////
////////////////////////////////

  InstructionMemory InstructionMem(
    .iPC(iPC),
    .oInstruction(current_instruction)
  );

initial begin
    InstructionMem.load_program(iFileName);
end
////////////////////////////////
////      Control Path      ////
////////////////////////////////

  ControlPath ControlPath(
    .iInstruction(current_instruction),
    .iZero(iZero),
    .oAluControl(oAluControl),
    .oImmExt(oImmExt),
    .oAluSrc(oAluSrc),
    .oPCSrc(oPCSrc),
    .oResultSrc(oResultSrc),
    .oMemWrite(oMemWrite),
    .oRegWrite(oRegWrite),
    .oRs1(oRs1),
    .oRs2(oRs2),
    .oRd(oRd),
    .oInstructionType(oInstructionType),
    .oInstructionSubType(oInstructionSubType)
  );

endmodule

