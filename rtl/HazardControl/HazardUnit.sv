module HazardUnit (

  input  logic [4:0] iDestRegM,
  input  logic [4:0] iDestRegW,
  input  logic       iRegWriteEnM,
  input  logic       iRegWriteEnW,

  input  logic [4:0] iSrcReg1D,
  input  logic [4:0] iSrcReg2D,

  input  logic [4:0] iSrcReg1E,
  input  logic [4:0] iSrcReg2E,

  output logic [2:0] oForwardAluOp1,
  output logic [2:0] oForwardAluOp2,
  output logic       oStallF,
  output logic       oStallD,
  output logic       oFlushE
);



endmodule
