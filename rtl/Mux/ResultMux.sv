module ResultMux(
  input  logic [2:0]  iResultSrc,
  input  logic [31:0] iMemDataOut,
  input  logic [31:0] iAluResult,
  input  logic [31:0] iPC,
  input  logic [31:0] iUpperImm,

  output logic [31:0] oRegDataIn
);

always_comb begin
  case(iResultSrc)
    3'b000   : oRegDataIn = iAluResult;
    3'b001   : oRegDataIn = iMemDataOut;
    3'b010   : oRegDataIn = iPC + 32'd4;
    3'b011   : oRegDataIn = iUpperImm;
    3'b100   : oRegDataIn = iPC + iUpperImm;
    default  : oRegDataIn = iAluResult; 
  endcase
end

endmodule
