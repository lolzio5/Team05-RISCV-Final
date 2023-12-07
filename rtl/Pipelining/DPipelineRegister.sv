module DPipelineRegister (
    input  logic        iCLk,
    input  logic        iRegWriteD,
    input  logic [1:0]  iResultSrcD,
    input  logic        iMemWriteD,
    input  logic        iJumpD,
    input  logic        iBranchD,
    input  logic [2:0]  iALUControlD,
    input  logic        iALUSrcD,
    input  logic [31:0] iRD1D,
    input  logic [31:0] iRD2D,
    input  logic [31:0] iPCD,
    input  logic [4:0]  iRdD,
    input  logic [31:0] iImmExtD,
    input  logic [31:0] iPCPlus4D,

    output  logic        oRegWriteE,
    output  logic [1:0]  oResultSrcE,
    output  logic        oMemWriteE,
    output  logic        oJumpE,
    output  logic        oBranchE,
    output  logic [2:0]  oALUControlE,
    output  logic        oALUSrcE,
    output  logic [31:0] oRD1E,
    output  logic [31:0] oRD2E,
    output  logic [31:0] oPCE,
    output  logic [4:0]  oRdE,
    output  logic [31:0] oImmExtE,
    output  logic [31:0] oPCPlus4E,
);
  
    always_ff @ (posedge iClk) begin 
        oRegWriteE <= iRegWriteD;
        oResultSrcE <= iResultSrcD;
        oMemWriteE <= iMemWriteD;
        oJumpE <= iJumpD;
        oBranchE <= iBranchD;
        oALUControlE <= iALUControlD;
        oALUSrcE <= iALUSrcD;
        oRD1E <= iRD1D;
        oRD2E <= iRD2D;
        oPCE <= iPCD;
        oRdE <= iRdD;
        oImmExtE <= iImmExtD;
        oPCPlus4E <= iPCPlus4D;
    end
    
endmodule
