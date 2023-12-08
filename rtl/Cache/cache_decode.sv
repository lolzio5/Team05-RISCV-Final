module cache_controller (
    input logic iClk,
    input  logic [31:0] iAddress,
    output logic [25:0] oTag,
    output logic [3:0] oIndex
);
always_ff @(posedge iClk) begin
    oTag <=iAddress[31:6];
    oIndex <= iAddress[5:2];
end
endmodule
