module DataMux (
    input  logic [31:0]  A,
    input  logic [31:0]  RD,
    input  logic         ResultSrc,
    output logic [31:0]  Result
);
always_comb begin
    if (ResultSrc) Result = RD;
    else Result = A;
end 

endmodule
