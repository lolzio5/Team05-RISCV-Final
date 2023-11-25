module ControlPath (
  input logic [32:1] instruction,

  output logic [4:1]  AluCtrl,
  output logic [12:1] ImmSrc,
  output logic        AluSrc,
  output logic        RegWrite,
);

logic [7:1] OpCode;
logic [3:1] funct3;
logic [7:1] funct7;


logic i_type;
logic r_type;
logic u_type;
logic s_type;
logic b_type;

logic jmp_link;
logic jmp_linkr;
logic add_pc;

logic [3:1] imm_ins_t;

always_comb begin
  funct3 = instruction[15:13];
  funct7 = instruction[32:26];
  OpCode = instruction[7:1];
end

ControlDecode ControlDecode(
  .funct3(funct3),
  .funct7(funct7),
  .OpCode(OpCode),

  .i_type(i_type),
  .r_type(r_type),

  .upper(u_type),

  .branch(b_type),

  .store(s_type),

  .jmp_link(jmp_link),
  .jmp_linkr(jmp_linkr),

  .add_u_pc(add_pc),

  .AluCtrl(AluCtrl)
);

always_comb begin
  imm_ins_t[1] = i_type;
  imm_ins_t[2] = s_type;
  imm_ins_t[3] = b_type;

  RegWrite = !(b_type || s_type); 
  AluSrc =  s_type || i_type;
end

imm_decode ImmDecoder(
  .instruction(instruction),
  .ins_type(imm_ins_t),

  .imm(ImmSrc)
);



endmodule
