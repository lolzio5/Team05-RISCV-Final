`include "./Control/include/ControlTypeDefs.svh"

module top(
    input  logic         clk,         // Clock input
    input  logic         rst, 
    //input  logic         trigger,
    output logic [7:0]  data_out  // Output data
);
    logic        MemWrite;
    logic [4:0] rd;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [3:0]  ALUCtrl;
    logic        ALUSrc;
    logic [31:0] ImmExt;
    logic [31:0] PC;
    logic        ResultSrc;
    logic [31:0] ALUResult;
    logic [31:0] WD3;
    logic        Zero;
    logic [31:0] RD2;
    logic [31:0] SrcB;
    logic [31:0] Result;
    logic        RegWrite;
    logic [31:0] SrcA;
    logic        PCSrc;
    logic [3:0]  oMemControl;

    initial begin
        data_out=ALUResult[7:0];
    end

    pcreg myPcreg(
        .clk (clk),
        .rst (rst),
        .PCSrc (PCSrc),
        .ImmExt (ImmExt),
        .PC (PC)
    );

    datamem myDatamem(
        .clk (clk),
        .ResultSrc (ResultSrc),
        .WE (MemWrite),
        .A (ALUResult),
        .WD (RD2),
        .Result (WD3)
    );

    alu myALU(
        .ALUControl (ALUCtrl),
        .SrcA (SrcA),
        .SrcB (SrcB),
        .ALUResult (ALUResult),
        .Zero (Zero)
    );

    mux myMux1(
        .iselect (ALUSrc),
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
        .CLK (clk),
        .WE3 (RegWrite),
        .AD1 (rs1),
        .AD2 (rs2),
        .AD3 (rd),
        .WD3 (Result),
        .RD1 (SrcA),
        .RD2 (RD2)
    );

    ControlUnit myControlUnit(
        .iPC (PC),
        .iZero (Zero), 
        .oImmExt (ImmExt),
        .oRegWrite (RegWrite),
        .oMemWrite (MemWrite),
        .oMemControl (oMemControl),
        .oAluControl (ALUCtrl),
        .oAluSrc (ALUSrc),
        .oRs1 (rs1),
        .oRs2 (rs2),
        .oRd (rd),
        .oResultSrc (ResultSrc),
        .oPCSrc (PCSrc)
    );


endmodule
