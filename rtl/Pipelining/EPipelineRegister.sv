module EPipelineRegister (
    input  logic        iCLk,
    input  logic        iRegWriteE,
    input  logic [1:0]  iResultSrcE,
    input  logic        iMemWriteE,
    input  logic [31:0] iALUResultE,
    input  logic [31:0] iWriteDataE,
    input  logic [4:0]  iRdE,
    input  logic [31:0] iPCPlus4E,

    output  logic        oRegWriteM,
    output  logic [1:0]  oResultSrcM,
    output  logic        oMemWriteM,
    output  logic [31:0] oALUResultM,
    output  logic [31:0] oWriteDataM,
    output  logic [4:0]  oRdM,
    output  logic [31:0] oPCPlus4M,
);
  
    always_ff @ (posedge iClk) begin 
        oRegWriteM <= iRegWriteE;
        oResultSrcM <= iResultSrcE;
        oMemWriteM <= iMemWriteE;
        oALUResultM <= iALUResultE;
        oWriteDataM <= iWriteDataE;
        oRdM <= iRdE;
        oPCPlus4M <= iPCPlus4E;
    end
    
endmodule
