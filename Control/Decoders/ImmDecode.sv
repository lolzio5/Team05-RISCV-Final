module ImmDecode(
  input  InstructionTypes iInstructionType,
  input  logic [32:1]     iInstruction,

  output logic [20:1]     oImm20,
  output logic            oExtendType
);

always_comb begin
  case(iInstructionType)
  
    IMM_COMPUTATION : begin
      oImm20[12:1]  = iInstruction[32:21];
      oImm20[20:12] = 8{oImm20[12]};
    end

    LOAD : begin
      oImm20[12:1]  = iInstruction[32:21];
      oImm20[20:12] = 8{oImm20[12]};
    end

    UPPER : begin
      oExtendType = 1'b1;
      oImm20      = iInstruction[32:12];
    end
 
    STORE : begin
      oImm20[12:6]  = iInstruction[32:26];
      oImm20[5:1]   = iInstruction[12:8];
      oImm20[20:12] = 8{oImm20[12]};
    end

    JUMP : begin
      oExtendType    = 1'b1;
      oImm20[20]     = iInstruction[32];
      oImm20[19:12]  = iInstruction[20:13];
      oImm20[11]     = iInstruction[21];
      oImm20[10:1]   = iInstruction[31:22];
    end

    BRANCH : begin 
      oImm20[12:1]  = {iInstruction[32], iInstruction[8], iInstruction[31:26], iInstruction[12:9]};
      oImm20[20:12] = 8{oImm20[12]};
    end

  endcase
end

endmodule
