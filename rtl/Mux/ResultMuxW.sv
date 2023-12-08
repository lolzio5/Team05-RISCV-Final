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
      3'b000   : oRegDataIn = iAluResult;       // Alu Operation
      3'b001   : oRegDataIn = iMemDataOut;      // Memory Read Operation (Load)
      3'b010   : oRegDataIn = iPC + 32'd4;      // Jumps 
      3'b011   : oRegDataIn = iUpperImm;        // Load Upper Immediate
      3'b100   : oRegDataIn = iPC + iUpperImm;  // Add Upper Immediate To PC
      default  : oRegDataIn = iAluResult;       // Default - Alu Operation
    endcase
  end

endmodule
