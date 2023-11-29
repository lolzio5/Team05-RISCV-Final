module ControlUnit(
  input logic [32:1]  iPC,
  input logic         iZero,


  output logic [32:1] oImmExt,
  output logic        oRegWrite,
  output logic        oMemWrite,
  output logic [4:1]  oMemControl

  output logic [4:1]  oAluControl,
  output logic        oAlusrc,
  output logic        oPCsrc,
  output logic        oResultSrc,

  output logic [5:1]  oRs1,
  output logic [5:1]  oRs2,
  output logic [5:1]  oRd,
);


////////////////////////////////
////      Internal Logic    ////
////////////////////////////////

  logic [32:1] current_instruction;



////////////////////////////////
//// Instruction Memory ROM ////
////////////////////////////////

  ROM InstrMem(
    .iPC(iPC),
    .oInstr(current_instruction)
  );



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
    .oMemControl(oMemControl),
    .oMemWrite(oMemWrite),
    .oRegWrite(oRegWrite),
    .oRs1(oRs1),
    .oRs2(oRs2),
    .oRd(oRd)
  );

endmodule

