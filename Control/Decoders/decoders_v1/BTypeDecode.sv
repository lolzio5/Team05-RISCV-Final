module BTypeDecode(
  input  logic [3:1] iFunct3,
  input  logic       iTypeB,

  output logic [8:1] oBranchType
);

EightDeMux DeMux8(
  .data_in(iTypeB),
  .select(iFunct3),

  .data_out(oBranchType)
)
endmodule