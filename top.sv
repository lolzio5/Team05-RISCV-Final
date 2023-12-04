`include "Control/ControlTypeDefs.svh"


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
    logic [31:0] ALUResult;

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

    alu myALU(
        .iALUControl (ALUctrl),
        .iSrcA (rs1),
        .iSrcB (rs2),
        .oALUResult (ALUResult),
        .oZero (Zero)
    );

    mux myMux1(
        .iselect (ALUsrc),
        .iSrcA (RD2),
        .iSrcB (ImmExt),
        .oselected (SrcB)
    );
    mux myMux2(
        .iselect (ResultSrc),
        .iSrcA (ALUResult),
        .iSrcB (WD3),
        .oselected (Result)
    );

    register myRegister(
        .iCLK (clk),
        .iWE3 (RegWrite),
        .iA1 (rs1),
        .iA2 (rs2),
        .iA3 (rd),
        .iWD3 (Result),
        .oRD1 (SrcA),
        .oRD2 (SrcB)
    );

    ControlMain myControlMain(
        .iPC (PC),
        .iZero (Zero), 
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
