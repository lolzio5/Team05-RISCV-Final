module PCAdder(  
  input  InstructionTypes iInstructionType,
  input  InstructionSubTypes iInstructionSubType,
  input  logic [31:0] iPC,
  input  logic [31:0] iImmExt,
  input  logic [31:0] iRegOffset,
  output logic [31:0] oPCTarget
);

always_comb begin
  case(iInstructionType)

    JUMP : begin

      if (iInstructionSubType == JUMP_LINK_REG) begin
      
        oPCTarget      = iImmExt + iRegOffset;
        oPCTarget[1:0] = 2'b00;
      
      end

      else oPCTarget = iPC + iImmExt;  //No need to worry about alignment as iImmExt is a multiple of 4 for JAL and Branch instructions (from immdecode)
      
    end

    BRANCH : begin
      oPCTarget = iPC + iImmExt;
    end

    default : oPCTarget = iPC + iImmExt;
  endcase
end

endmodule
