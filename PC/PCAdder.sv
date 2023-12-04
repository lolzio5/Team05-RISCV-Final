module PCAdder(  
  input InstructionSubTypes iInstructionSubType,
  input  logic [31:0] iPC,
  input  logic [31:0] iImmExt,
  input  logic [31:0] iRegOffset,
  output logic [31:0] oPCTarget
);
//add condition to check instruction type first - if only subtype is checked could lead to error as certain subtype instructions have same enum value : ex. load and add
always_comb begin
  case(iInstructionSubType)

    JUMP_LINK_REG : begin
      oPCTarget      = iImmExt + iRegOffset;
      oPCTarget[1:0] = 2'b00;
    end

    JUMP_LINK : oPCTarget = iPC + iImmExt; //No need to worry about alignment as iImmExt is a multiple of 4 for JAL and Branch instructions (from immdecode)
    default   : oPCTarget = iPC + iImmExt; //default case covers branch instructions (iImmExt is multiple of 4 for branch) - cant use BEQ case since it has same enum value as JAL

  endcase
end

endmodule
