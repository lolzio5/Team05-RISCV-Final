module cache_controller (
    input  logic iCLK,
    input  logic  iHit,
    input logic [31:0]  iData,
    input logic  [31:0] iAddress,
    output logic [31:0] oData
    output logic 
);

always_ff @(posedge iClk) begin
    if (iHit==1)begin //hit
        oData<=iData;
    end
    else begin //miss

    end  
end
endmodule
