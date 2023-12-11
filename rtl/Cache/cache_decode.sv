module cache_decode (
    input  logic [31:0] iAddress,
    input logic [31:0] iFlushAddress,
    output logic [3:0] oIndexFlush,
    output logic [25:0] oTag,
    output logic [3:0] oIndex
);
always_comb begin
    oTag <=iAddress[31:6];
    oIndex <= iAddress[5:2];
    oIndexFlush <= iFlushAddress[5:2];
end
endmodule
