module ComputationDecode(
  input logic       iComputationIns,
  input logic [3:1] iFunct3,

  output logic [8:1] oComputationType
);


EightDeMux demux8(
  .data_in(iComputationIns),
  .select(iFunct3),

  .data_out(oComputationType)
);

endmodule
