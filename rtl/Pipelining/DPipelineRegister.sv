`include "include/ControlTypeDefs.svh"

module DPipelineRegister (
    input   logic               iCLk,
    input   logic               iFlushE,
    input   InstructionTypes    iInstructionTypeD,
    input   InstructionSubTypes iInstructionSubTypeD,
    input   logic               iRegWriteD,
    input   logic [1:0]         iMemToRegD,
    input   logic               iMemWriteD,
    input   logic [2:0]         iALUControlD,
    input   logic               iALUSrcD,
    input   logic [31:0]        iRD1D,
    input   logic [31:0]        iRD2D,
    input   logic [4:0]         iRsD,
    input   logic [4:0]         iRtD,
    input   logic [4:0]         iRdD,
    input   logic [31:0]        iSignImmD,

    output  logic               oRegWriteE,
    output  InstructionTypes    oInstructionTypeE,
    output  InstructionSubTypes oInstructionSubTypeE,
    output  logic [1:0]         oMemToRegE,
    output  logic               oMemWriteE,
    output  logic [2:0]         oALUControlE,
    output  logic               oALUSrcE,
    output  logic [31:0]        oRD1E,
    output  logic [31:0]        oRD2E,
    output  logic [4:0]         oRsE,
    output  logic [4:0]         oRtE,
    output  logic [4:0]         oRdE,
    output  logic [31:0]        oSignImmE
);
    always_ff @ (posedge iClk) begin
        if(iFlushE) begin
            case(iInstructionSubTypeD) 
                r_type : oInstructionSubTypeE = NULL_R;
                i_type : oInstructionSubTypeE = NULL_I;
                u_type : oInstructionSubTypeE = NULL_U;
                s_type : oInstructionSubTypeE = NULL_S;
                j_type : oInstructionSubTypeE = NULL_J;
                b_type : oInstructionSubTypeE = NULL_B;
            endcase
            OInstructionTypeE = NULLINS;
            oRegWriteE <= 1'b0;
            oMemToRegE <= 2'b00;
            oMemWriteE <= 1'b0;
            oALUControlE <= 3'b000;
            oALUSrcE <= 1'b0;
            oRD1E <= 32'h00000000;
            oRD2E <= 32'h00000000;
            oRsE <= 5'b00000;
            oRtE <= 5'b00000;
            oRdE <= 5'b00000;
            oSignImmE <= 32'h00000000;
        end
        else begin
            oInstructionTypeE <= iInstructionTypeD;
            oInstructionSubTypeE <= iInstructionTypeD;
            oRegWriteE <= iRegWriteD;
            oMemToRegE <= iMemToRegD;
            oMemWriteE <= iMemWriteD;
            oALUControlE <= iALUControlD;
            oALUSrcE <= iALUSrcD;
            oRD1E <= iRD1D;
            oRD2E <= iRD2D;
            oRsE <= iRsD;
            oRtE <= iRtD;
            oRdE <= iRdD;
            oSignImmE <= iSignImmD;
        end
    end
    
endmodule
