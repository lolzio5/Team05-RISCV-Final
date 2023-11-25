module ControlMain(
  input logic [32:1]  PC,
  input logic         EQ,

  output logic [32:1] ImmOpp,
  output logic        RegWrite,
  output logic [4:1]  Aluctrl,
  output logic        Alusrc,
  output logic [5:1]  rs1,
  output logic [5:1]  rs2,
  output logic [5:1]  rd,
  output logic        ImmSrc,
  output logic        PCsrc
);

logic [32:1] curr_ins;

logic [12:1] imm12;
logic [32:1] imm32;

ROM InstrMem(
  .PC(PC),
  .Instr(curr_ins)
);

ControlPath ControlPath(
  .instruction(curr_ins),

  .AluCtrl(Aluctrl),
  .ImmSrc(imm12),
  .AluSrc(Alusrc),
  .RegWrite(RegWrite)
);

SignExtend SignExtender(
  .imm_12(imm12),
  .imm_32ext(imm32)
);

always_comb begin
  ImmOpp = imm32;
  PCsrc = EQ ;
  rs1 = curr_ins[20:16];
  rs2 = curr_ins[25:21];
  rd  = curr_ins[12:8];
end

endmodule

