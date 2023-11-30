`include "include/ControlTypeDefs.svh"

module ImmDecode(
  input  InstructionTypes iInstructionType,
  /* verilator lint_off UNUSED */
  input  logic [31:0]     iInstruction,
  /* verilator lint_on UNUSED */
  output logic [19:0]     oImm20,
  output logic            oExtendType
);

always_comb begin

    oExtendType = 1'b0;
    oImm20 = {20{1'b0}};

  case(iInstructionType)
  
    IMM_COMPUTATION : begin
      oExtendType    = 1'b0;
      oImm20[11:0]  = iInstruction[31:20];
      oImm20[19:12] = {8{oImm20[11]}};
    end

    LOAD : begin
      oExtendType    = 1'b0;
      oImm20[11:0]  = iInstruction[31:20];
      oImm20[19:12] = {8{oImm20[11]}};
    end

    UPPER : begin
      oExtendType = 1'b1;
      oImm20      = iInstruction[31:12];
    end
 
    STORE : begin
      oExtendType    = 1'b0;
      oImm20[11:5]  = iInstruction[31:25];
      oImm20[4:0]   = iInstruction[11:7];
      oImm20[19:12] = {8{oImm20[11]}};
    end

    JUMP : begin
      oExtendType    = 1'b1;
      oImm20[19]     = iInstruction[31];
      oImm20[19:12]  = iInstruction[19:12];
      oImm20[11]     = iInstruction[20];
      oImm20[10:1]   = iInstruction[30:21];
      oImm20[0]      = 1'b0;
    end

    BRANCH : begin 
      oImm20[11:0]  = {iInstruction[31], iInstruction[7], iInstruction[30:25], iInstruction[11:8]};
      oImm20[19:12] = {8{oImm20[11]}};
    end

    default : begin
      oExtendType = 1'b0;
      oImm20 = {20{1'b0}}; //set imm20 to 0 by default
    end
  endcase
end

endmodule
