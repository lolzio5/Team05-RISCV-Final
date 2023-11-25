module iFunct_decode(

  input logic load,
  input logic store,
  input logic [3:1] funct3,

  output logic LDR_BYTE,
  output logic LDR_HALF,
  output logic LDR_WORD,

  output logic ULDR_BYTE,
  output logic ULDR_HALF,

  output logic STR_BYTE,
  output logic STR_HALF,
  output logic STR_WORD

);

logic [7:0] output_ldr ;
logic [3:0] output_str ;
logic [1:0] funct3_lsbs ;

assign funct3_lsbs = funct3[2:1];

EightDeMux demux8(
  .data_in(load),
  .select(funct3),
  .data_out(output_ldr)
);

FourDeMux demux4(
  .data_in(store),
  .select(funct3_lsbs),
  .data_out(output_str)
);

always_comb 

  LDR_BYTE  = output_ldr[0];
  LDR_HALF  = output_ldr[1];
  LDR_WORD  = output_ldr[2];

  ULDR_BYTE = output_ldr[3];
  ULDR_HALF = output_ldr[4];

  STR_BYTE = output_str[0];
  STR_HALF = output_str[1];
  STR_WORD = output_str[2];

endmodule
