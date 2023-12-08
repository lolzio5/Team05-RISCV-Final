module EPipelineRegister (
    input   logic        iCLk,
    input   logic        iRegWriteE,
    input   logic        iMemToRegE,
    input   logic        iMemWriteE,
    input   logic [31:0] iALUOutE,
    input   logic [31:0] iWriteDataE,
    input   logic [4:0]  iWriteRegE,

    output  logic        oRegWriteM,
    output  logic        oMemToRegM,
    output  logic        oMemWriteM,
    output  logic [31:0] oALUOutM,
    output  logic [31:0] oWriteDataM,
    output  logic [4:0]  oWriteRegM
);
  
    always_ff @ (posedge iClk) begin 
        oRegWriteM <= iRegWriteE;
        oMemToRegM <= iMemToRegE;
        oMemWriteM <= iMemWriteE;
        oALUOutM <= iALUOutE;
        oWriteDataM <= iWriteDataE;
        oWriteRegM <= iWriteRegE;
    end
    
endmodule
