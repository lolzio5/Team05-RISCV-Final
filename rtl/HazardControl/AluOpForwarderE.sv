module AluOpForwarderE(
  input  logic [1:0]  iForwardAluOp1,
  input  logic [1:0]  iForwardAluOp2,
  input  logic [31:0] iResultDataW,
  input  logic [31:0] iAluResultOutM,
  input  logic [31:0] iRegData1E,
  input  logic [31:0] iRegData2E,

  output logic [31:0] oAluOp1,
  output logic [31:0] oAluOp2,
);

  always_comb begin

    case (iForwardAluOp1)
      2'b00   : oAluOp1 = iRegData1E ;
      2'b01   : oAluOp1 = iAluResultOutM;
      2'b10   : oAluOp1 = iResultDataW;
      default : oAluOp1 = iRegData1E,;
    endcase

    case (iForwardAluOp2)
      2'b00   : oAluOp2 = iRegData2E ;
      2'b01   : oAluOp2 = iAluResultOutM;
      2'b10   : oAluOp2 = iResultDataW;
      default : oAluOp2 = iRegData2E,;
    endcase

  end
endmodule