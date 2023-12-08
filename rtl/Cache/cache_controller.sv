module cache_controller (
    input  logic iCLK,
    input  logic  iHit,
    input logic [31:0]  iData,
    input logic  [31:0] iAddress,
    output logic [31:0] oData
);
always_ff @(posedge iClk) begin
    if (iHit==1)begin
        oData<=iData;
    end
    else begin
        DataMemory DataMemory(
            .iClk(iCLK),
            .iWriteEn(0),
            .iInstructionType
        );
    end  
end
endmodule
