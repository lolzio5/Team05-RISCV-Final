module ControlMain(
  input logic [32:1]  iPC,
  input logic         iZero,

  output logic [32:1] oImmOpp,
  output logic        oRegWrite,
  output logic        oMemWrite,

  output logic [4:1]  oAluctrl,
  output logic        oAlusrc,
  output logic        oImmSrc,
  output logic        oPCsrc

  output logic [5:1]  ors1,
  output logic [5:1]  ors2,
  output logic [5:1]  ord,
);

  logic [32:1] current_instruction;

  logic [20:1] imm20;
  logic [32:1] imm32;

  ROM InstrMem(
    .iPC(iPC),
    .oInstr(current_instruction)
  );

  ControlPath ControlPath(
    .oInstruction(current_instruction),

    .oAluCtrl(oAluctrl),
    .oImmSrc(imm20),
    .oAluSrc(oAlusrc),
    .oRegWrite(oRegWrite)
  );

  SignExtend SignExtender(
    .iImm20(imm20),
    .oImm32(oImmOp)
  );

  always_comb begin

    //TO DO : Add logic to determine PC src

    rs1 = curr_ins[20:16];
    rs2 = curr_ins[25:21];
    rd  = curr_ins[12:8];
  end

endmodule

