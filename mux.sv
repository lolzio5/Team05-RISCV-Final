module mux #(
    parameter  ADDRESS_WIDTH = 5,
               DATA_WIDTH =32
)(
    input logic ALUsrc,
    input logic [DATA_WIDTH-1:0] regOp2,
    input logic [DATA_WIDTH-1:0] ImmOp,
    output logic [DATA_WIDTH-1:0] ALUop2
);

always_comb begin
    if(ALUsrc==1'b1)
        ALUop2<=ImmOp;
    else
        ALUop2<=regOp2;
end

endmodule
