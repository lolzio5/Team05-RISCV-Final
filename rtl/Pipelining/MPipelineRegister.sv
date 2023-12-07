module MPipelineRegister (
    input  logic        iCLk,
    input  logic        iRegWriteM,
    input  logic [1:0]  iResultSrcM,
    input  logic [31:0] iALUResultM,
    input  logic [31:0] iReadDataM,
    input  logic [4:0]  iRdM,
    input  logic [31:0] iPCPlus4M,

    output  logic        oRegWriteW,
    output  logic [1:0]  oResultSrcW,
    output  logic [31:0] oALUResultW,
    output  logic [31:0] oReadDataW,
    output  logic [4:0]  oRdW,
    output  logic [31:0] oPCPlus4W,
);
  
    always_ff @ (posedge iClk) begin 
        oRegWriteW <= iRegWriteM;
        oResultSrcW <= iResultSrcM;
        oALUResultW <= iALUResultM;
        oReadDataW <= iReadDataM;
        oRdW <= iRdM;
        oPCPlus4W <= iPCPlus4M;
    end
    
endmodule
