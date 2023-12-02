module PCMux (
    input  logic [31:0]  iImmExt,
    input  logic [31:0]  iPC,
    input  logic         iPCSrc,
    output logic [31:0]  oPCNext
);

always_comb begin
    if (iPCSrc)
        oPCNext = iImmExt + iPC;
    else
        oPCNext = iPC + 32'b00000000000000000000000000000100;
end

endmodule
