module pcmux (
    input  logic [31:0]  ImmExt,
    input  logic [31:0]  PC,
    input  logic         PCSrc,
    output logic [31:0]  PCNext
);

always_comb begin
    if (PCSrc)
        PCNext = ImmExt + PC;
    else
        PCNext = PC + 32'b00000000000000000000000000000100;
end

endmodule
