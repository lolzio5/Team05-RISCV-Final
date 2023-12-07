module PCAdderD(  
  input  InstructionTypes    iInstructionType,
  input  InstructionSubTypes iInstructionSubType,
  input  logic [31:0]        iPC,
  input  logic [31:0]        iImmExt,
  input  logic [31:0]        iRegOffset,

  output logic [31:0]        oPCTarget
);

  always_comb begin
    case(iInstructionType)

      JUMP : begin
        if (iInstructionSubType == JUMP_LINK_REG) begin
          oPCTarget      = iImmExt + iRegOffset;
          oPCTarget[1:0] = 2'b00;
        end

        //No need to worry about alignment as iImmExt is already aligned for JAL and Branch instructions (from immdecode)
        else    oPCTarget = iPC + iImmExt;  
      end

      BRANCH  : oPCTarget = iPC + iImmExt;

      default : oPCTarget = iPC + iImmExt;
      
    endcase
  end

endmodule
