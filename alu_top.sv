module alu_top(
    input logic  clk,
    input logic  rs1,
    input logic  rs2,
    input logic  rd,
    input logic  RegWrite,
    input logic  ALUsrc,
    input logic  ALUctrl,
    input logic  ImmOp,
    output logic EQ,
    output logic a0
);

    alu myALU(
        .ALUctrl (ALUctrl),
        .ALUop1 (ALUop1),
        .ALUop2 (ALUop2),
        .ALUout (ALUout)
    );

    mux myMux(
        .ALUsrc (ALUsrc),
        .regOp2 (regOp2),
        .ImmOp (ImmOp),
        .ALUop2 (ALUop2)
    );

    register myRegister(
        .clk (clk),
        .WE3 (RegWrite),
        .WD3 (ALUout),
        .AD3 (rd),
        .AD1 (rs1),
        .AD2 (rs2),
        .RD1 (RD1),
        .RD2 (RD2),
        .a0 (a0)
        .EQ (EQ)
    );

endmodule
