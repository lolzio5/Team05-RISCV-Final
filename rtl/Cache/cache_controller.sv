module cache_controller (
    input  logic iCLK,
    input  logic [26:0]  iHit,
    output logic  oReadCache
);
always_ff @(negedge iClk) begin
    if (iHit==1) oReadCache=1;
    else    oReadCache=0;   
end
endmodule
