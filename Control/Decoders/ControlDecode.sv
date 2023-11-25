module ControlDecode(

  input logic [7:1] OpCode,
  input logic [3:1] funct3,
  input logic [7:1] funct7,

  output logic         store,
  output logic         i_type,
  output logic         add_u_pc,
  output logic         jmp_link,
  output logic         jmp_linkr,
  output logic         upper,
  output logic         r_type,
  output logic         branch,
  output logic [4:1]   AluCtrl

);

logic I_ins_type_temp;

logic      ldr_byte;
logic      ldr_half;
logic      ldr_word;

logic      uldr_byte;
logic      uldr_half;

logic      str_byte;
logic      str_half;
logic      str_word;

logic      addsub;
logic      shiftl;
logic      set_less;
logic      uset_less;
logic      shifr;
logic      xor;
logic      or;
logic      and;

logic      add;
logic      sub;
logic      shiftr_logical;
logic      shiftr_arith;



op_decode OpDecode(

  .OpCode(OpCode),

  .imm_manip(i_type),

  .store(store),
  .load(I_ins_type_temp),

  .add_u_pc(add_u_pc),
  .r(r_type),

  .upper(upper),

  .branch(branch),
  .jmp_link(jmp_link),
  .jmp_linkr(jmp_linkr)

);

funct3_decode funct3_decode(

  .funct3(funct3),
  .ldr(I_ins_type_temp),
  .str(store),
  .R_INS(r_type),
  .IMM_MANIP_INS(i_type),

  .LDR_BYTE(ldr_byte),
  .LDR_HALF(ldr_half),
  .LDR_WORD(ldr_word),

  .ULDR_BYTE(uldr_byte),
  .ULDR_HALF(uldr_half),

  .STR_BYTE(str_byte),
  .STR_HALF(str_half),
  .STR_WORD(str_word),

  .ARITH(addsub),
  .SHIFT_L(shiftl),
  .SET_LESS(set_less),
  .U_SET_LESS(uset_less),
  .SHIFT_R(shiftr),
  .XOR(xor),
  .OR(or),
  .AND(and)

);

funct7_decode(
  
  .addsub(addsub),
  .funct7(funct7),
  .shift_r(shiftr),

  .add(add),
  .sub(sub),
  .imm_shiftr_logical(shiftr_logical),
  .imm_shiftr_arith(shiftr_arith)

);

logic [9:1] AluMessage;

always_comb begin

  AluMessage[9] = shiftr_arith;
  AluMessage[8] = shiftr_logical;
  AluMessage[7] = shiftl;
  AluMessage[6] = and;
  AluMessage[5] = xor;
  AluMessage[4] = sub;
  AluMessage[3] = add;
  AluMessage[2] = uset_less;
  AluMessage[1] = set_less;

end

ALU_encode AluEncoder(
  .alu_ins(AluMessage),
  .AluCtrl(AluCtrl)
);

endmodule
