`include "include/ControlTypeDefs.svh"
module EPipelineRegisterM(
    input   logic               iClk,

    input   InstructionTypes    iInstructionTypeE,
    input   InstructionSubTypes iInstructionSubTypeE,
    input   logic [31:0]        iPCE,
    input   logic [31:0]        iImmExtE,

    input   logic [31:0]        iAluOutE,
    input   logic [31:0]        iMemDataInE,
    input   logic [4:0]         iDestRegE,
    input   logic [2:0]         iResultSrcE,
    input   logic               iRegWriteEnE,
    input   logic               iMemWriteEnE,

    output  reg InstructionTypes    oInstructionTypeM,
    output  reg InstructionSubTypes oInstructionSubTypeM,
    output  reg logic [31:0]        oPCM,
    output  reg logic [31:0]        oImmExtM,

    output  reg logic [31:0]        oAluOutM,
    output  reg logic [31:0]        oMemDataInM,
    output  reg logic [4:0]         oDestRegM,
    output  reg logic [2:0]         oResultSrcM,
    output  reg logic               oRegWriteEnM,
    output  reg logic               oMemWriteEnM
);

    always_ff @ (posedge iClk) begin 
        oInstructionTypeM    <= iInstructionTypeE;
        oInstructionSubTypeM <= iInstructionSubTypeE;
        oPCM                 <= iPCE;
        oImmExtM             <= iImmExtE;
        oAluOutM             <= iAluOutE;
        oMemDataInM          <= iMemDataInE;
        oDestRegM            <= iDestRegE;
        oResultSrcM          <= iResultSrcE;
        oRegWriteEnM         <= iRegWriteEnE;
        oMemWriteEnM         <= iMemWriteEnE;
    end
    
endmodule
