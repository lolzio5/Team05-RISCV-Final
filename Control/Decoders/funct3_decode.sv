module funct3_decode(

  input logic [3:1] funct3,
  input logic       ldr,
  input logic       str,
  input logic       R_INS,
  input logic       IMM_MANIP_INS,

  output logic      LDR_BYTE,
  output logic      LDR_HALF,
  output logic      LDR_WORD,

  output logic      ULDR_BYTE,
  output logic      ULDR_HALF,

  output logic      STR_BYTE,
  output logic      STR_HALF,
  output logic      STR_WORD,

  output logic      ARITH,
  output logic      SHIFT_L,
  output logic      SET_LESS,
  output logic      U_SET_LESS,
  output logic      SHIFT_R,
  output logic      XOR,
  output logic      OR,
  output logic      AND

);

logic R_en;

assign R_en = R_INS | IMM_MANIP_INS ;

iFunct_decode I_Type_Decode(
  .load(ldr),
  .store(str),
  .funct3(funct3),

  .LDR_BYTE(LDR_BYTE),
  .LDR_HALF(LDR_HALF),
  .LDR_WORD(LDR_WORD),

  .ULDR_BYTE(ULDR_BYTE),
  .ULDR_HALF(ULDR_HALF),

  .STR_BYTE(STR_BYTE),
  .STR_HALF(STR_HALF),
  .STR_WORD(STR_WORD),
);

rFunct_decode R_Type_Decode(

  .INS_R_t(R_en),
  .funct3(funct3),
  
  .ARITH(ARITH),  
  .SHIFT_L(SHIFT_L),    
  .SET_LESS(SET_LESS),   
  .U_SET_LESS(U_SET_LESS),
  .XOR(XOR),   
  .SHIFT_R(SHIFT_R),     
  .OR(OR),         
  .AND(AND)    

);

endmodule
