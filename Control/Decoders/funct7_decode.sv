module funct7_decode(

  input logic addsub,
  input logic [7:1] funct7,
  input logic shift_r,

  output logic add,
  output logic sub,
  output logic imm_shiftr_logical,
  output logic imm_shiftr_arith

);

logic comp_out ;
logic [2:1] addsub_out;
logic [2:1] shiftr_out;

if (funct7 == 7'b01000000) comp_out = 1'b1; 
else comp_out = 1'b0; 


TwoDeMux demux_addsub(
  .select(comp_out),
  .data_in(addsub),
  .data_out(addsub_out)
);

TwoDeMux demux_shift(
  .select(comp_out),
  .data_in(shift_r),
  .data_out(shiftr_out)
);

always_comb begin

  add                = addsub_out[1];
  sub                = addsub_out[2];

  imm_shiftr_logical = shiftr_out[1];
  imm_shiftr_arith   = shiftr_out[2];

end

endmodule
