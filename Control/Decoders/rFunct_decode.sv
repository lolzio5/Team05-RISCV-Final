module rFunct_decode(

  input logic       INS_R_t,
  input logic [3:1] funct3,

  output logic      ARITH,
  output logic      SHIFT_L,
  output logic      SET_LESS,
  output logic      U_SET_LESS,
  output logic      SHIFT_R,
  output logic      XOR,
  output logic      OR,
  output logic      AND

);

logic [7:0] out_temp;

EightDeMux demux8(
  .data_in(INS_R_t),
  .select(funct3),
  .data_out(out_temp)
);

always_comb

  ARITH       = out_temp[0];
  SHIFT_L     = out_temp[1];
  SET_LESS    = out_temp[2];
  U_SET_LESS  = out_temp[3];
  XOR         = out_temp[4];
  SHIFT_R     = out_temp[5];
  OR          = out_temp[6];
  AND         = out_temp[7];

endmodule
