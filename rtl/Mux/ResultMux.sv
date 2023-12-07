module ResultMux(
  input  logic [1:0]  iResultSrcW,
  input  logic [31:0] iReadDataW,
  input  logic [31:0] iALUResultW,
  input  logic [31:0] iPCPlus4W,

  output logic [31:0] oResultW
);

  always_comb begin
    case(iResultSrcW)
      3'b00   :  oResultW  =  iALUResultW;      // Alu Operation
      3'b01   :  oResultW  =  iReadDataW;       // Memory Read Operation (Load)
      3'b10   :  oResultW  =  iPCPlus4W;        // Next instruction
      default  : oResultW  =  iALUResultW;      // Default - Alu Operation
    endcase
  end

endmodule
