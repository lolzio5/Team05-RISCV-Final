module ControlPath (
  input  logic [32:1] iInstruction,
  input  logic        iZero,

  output logic [4:1]  oAluControl,
  output logic [32:1] oImmExt,
  output logic        oAluSrc,
  output logic        oPCSrc,
  output logic        oResultSrc,
  output logic [3:1]  oMemControl, //added for controlling memory addressing
  output logic        oMemWrite,
  output logic        oRegWrite  
  
  output logic [5:1]  oRs1,
  output logic [5:1]  oRs2,
  output logic [5:1]  oRd
  
);

logic [7:1] op_code;
logic [7:1] funct7;
logic [3:1] funct3;

always_comb begin
  op_code = iInstruction[7:1];
  funct7  = iInstruction[32:26];
  funct3  = iInstruction[15:13];

  oRs1 = iInstruction[20:16];
  oRs2 = iInstruction[25:21];
  oRd  = iInstruction[12:8];
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

logic [20:1] imm20;
logic imm_ext_type;

ImmDecode ImmediateOperandDecoder(
  .iInstructionType(instruction_type),
  .iInstruction(iInstruction),

  .oImm20(imm20),
  .oExtendType(imm_ext_type)
);


/////////////////////////////////
///   Sign-Extension Unit     ///
/////////////////////////////////

SignExtend SignExtender(
  .iImm20(imm20),
  .iExtendType(imm_ext_type),

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
)


endmodule
