module MPipelineRegister (
    input   logic        iCLk,
    input   logic        iRegWriteM,
    input   logic        iMemToRegM,
    input   logic [31:0] iReadDataM,
    input   logic [31:0] iALUOutM,
    input   logic [4:0]  iWriteRegM,

    output  logic        oRegWriteW,
    output  logic        oMemToRegW,
    output  logic [31:0] oReadDataW,
    output  logic [31:0] oALUOutW,
    output  logic [4:0]  oWriteRegW
);
  
    always_ff @ (posedge iClk) begin 
        oRegWriteW <= iRegWriteM;
        oMemToRegW <= iMemToRegM;
        oALUOutW <= iALUOutM;
        oReadDataW <= iReadDataM;
        oWriteRegW <= iWriteRegM;
    end
    
endmodule
