module ImmOpDecode(
  input  logic [32:1] iInstruction,
  input  logic [3:1]  iInsTypeISB,
  input  logic [2:1]  iInsTypeJU,

  output logic [20:1] oImm20 
);

//TODO : add U and J classification

//////////////////////
///Internal Signals///
//////////////////////

logic [20:1] i_type;
logic [20:1] s_type;
logic [20:1] b_type;
logic [20:1] zero;

assign zero = 20'b0000_0000_0000_0000_0000;


//////////////////////////////////////////////////////////////////////////////
///Logic to determine ImmOp from Instruction word for each instruction type///
//////////////////////////////////////////////////////////////////////////////

always_comb begin
  i_type[12:1]  = instruction[32:21];
  i_type[20:12] = i_type[12];

  s_type[12:6]  = instruction[32:26];
  s_type[5:1]   = instruction[12:8];
  s_type[20:12] = s_type[12];

  b_type[12:1]  = {instruction[32], instruction[8], instruction[31:26], instruction[12:9]};
  b_type[20:12] = b_type[12];
end

EightMux Mux8(
  .d0(zero),
  .d1(i_type),
  .d2(s_type),
  .d3(zero),
  .d4(b_type),
  .d5(zero),
  .d6(zero),
  .d7(zero),
  .select(iInsTypeISB),
  .data_out(oImm20)
);

endmodule
