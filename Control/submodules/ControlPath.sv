`include "include/ControlTypeDefs.svh"
module ControlPath (
  input  logic [31:0] iInstruction,
  input  logic        iZero,

  output logic [3:0]  oAluControl,
  output logic [31:0] oImmExt,
  output logic        oAluSrc,
  output logic        oPCSrc,
  output logic        oResultSrc,
  output logic [3:0]  oMemControl, //added for controlling memory addressing
  output logic        oMemWrite,
  output logic        oRegWrite,  
  
  output logic [4:0]  oRs1,
  output logic [4:0]  oRs2,
  output logic [4:0]  oRd
  
);


logic [6:0] op_code;
logic [6:0] funct7;
logic [2:0] funct3;

always_comb begin
  op_code = iInstruction[6:0];
  funct7  = iInstruction[31:25];
  funct3  = iInstruction[14:12];

  oRs1 = iInstruction[19:15];
  oRs2 = iInstruction[24:20];
  oRd  = iInstruction[11:7];
end


InstructionTypes instruction_type;
InstructionSubTypes instruction_sub_type;

////////////////////////////////
////  Instruction Decoder   ////
////////////////////////////////

InstructionDecode InstructionDecoder(
  .iOpCode(op_code),
  .iFunct3(funct3),
  .iFunct7(funct7),

  .oInstructionType(instruction_type),
  .oInstructionSubType(instruction_sub_type)
);


/////////////////////////////////
/// Immediate Operand Decoder ///
/////////////////////////////////


ImmDecode ImmediateOperandDecoder(
  .iInstructionType(instruction_type),
  .iInstructionSubType(instruction_sub_type),
  .iInstruction(iInstruction),

  .oImmExt(oImmExt)
);


/////////////////////////////////
///   Control Signal Decoder  ///
/////////////////////////////////

  /*
    This decoder is used to generate the various Src signals
    as well as the memory control signal which is a 4-bit control signal
    that tells the data memory unit how to interpret the immediate offset
    given the current instruction executing, in order to make the address
    byte addressing compatible
  */

ControlDecode ControlSignalDecoder(
  .iInstructionType(instruction_type),
  .iInstructionSubType(instruction_sub_type),
  .iZero(iZero),

  .oResultSrc(oResultSrc),
  .oPCSrc(oPCSrc),
  .oAluSrc(oAluSrc),
  .oMemControl(oMemControl),
  .oRegWrite(oRegWrite),
  .oMemWrite(oMemWrite)
);


/////////////////////////////////
///   Alu Operation Encoder   ///
/////////////////////////////////

  /*
    This component is used to generate a 4-bit control signal
    that tells the ALU what operation to perform
  */

AluEncode AluControlEncoder(
  .iInstructionType(instruction_type),
  .iInstructionSubType(instruction_sub_type),

  .oAluCtrl(oAluControl)
);


endmodule
