module imm_decode(

  input logic [32:1] instruction,
  input logic [3:1] ins_type,

  output logic [12:1] imm

);

logic [12:1] i_type;
logic [12:1] s_type;
logic [12:1] b_type;

logic [12:1] zero;

assign zero = 12'b0;

EightMux mux8(
  .d0(zero),
  .d1(i_type),
  .d2(s_type),
  .d3(zero),
  .d4(b_type),
  .d5(zero),
  .d6(zero),
  .d7(zero),
  .select(ins_type),
  .data_out(imm)
);

always_comb begin
  i_type = instruction[32:21];

  s_type[12:6] = instruction[32:26];
  s_type[5:1] = instruction[12:8];

  b_type = {instruction[32], instruction[8], instruction[31:26], instruction[12:9]};

end

 

endmodule
