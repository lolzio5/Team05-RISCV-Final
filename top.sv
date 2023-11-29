module top(
    input  logic         clk,         // Clock input
    input  logic         rst, 
    input  logic         trigger,
    output logic [31:0]  data_out  // Output data
);
    logic [31:0] MemWrite;
    logic [31:0] rd;
    logic [31:0] rs1;
    logic [31:0] rs2;
    logic [31:0] ALUctrl;
    logic [31:0] ALUsrc;
    logic [31:0] rs1;
    logic [31:0] rs2;
    logic [31:0] ImmExt;
    logic [31:0] PC;
    logic [31:0] ResultSrc;
    logic [31:0] WriteData;

    pcreg myPcreg(
        .clk (clk),
        .rst (rst),
        .PCsrc (PCSrc)
        .ImmExt (ImmExt),
        .PC (PC)
    );

    datamem myDatamem(
        .clk (clk),
        .ResultSrc (ResultSrc),
        .WE (MemWrite),
        .A (ALUResult),
        .WD (WriteData),
        .Result (WD3)
    );

    alu_top myALU_Top(
        .clk (clk),
        .rs1 (rs1),
        .rs2 (rs2),
        .rd (rd),
        .RegWrite (RegWrite),
        .ALUsrc (ALUsrc),
        .ALUctrl (ALUctrl),
        .ImmOp (ImmExt),
        .EQ (EQ),
        .a0 (data_out)
    );

    ControlMain myControlMain(
        .iPC (PC),
        .iZero (Zero), //missing from the ALU
        .oImmOpp (ImmExt),
        .oRegWrite (RegWrite),
        .oMemWrite (MemWrite)
        .oAluctrl (ALUctrl),
        .oAlusrc (ALUsrc),
        .ors1 (rs1),
        .ors2 (rs2),
        .ord (rd),
    );


endmodule
