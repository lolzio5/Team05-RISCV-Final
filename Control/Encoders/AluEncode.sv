module AluEncode(
  input InstructionTypes iInstructionType,
  input InstructionSubTypes iInstructionSubType

  output AluOp oAluCtrl
);

  always_comb begin

    case(iInstructionType)

      REG_COMMPUTATION : oAluCtrl.REG_COMPUTATION  = iInstructionSubType.R;
      IMM_COMPUTATION  : oAluCtrl.IMM_COMPUTATION  = iInstructionSubType.I;
      STORE            : oAluCtrl.IMM_COMPUTATION  = IMM_ADD; 
      LOAD             : oAluCtrl.IMM_COMPUTATION  = IMM_ADD;
      BRANCH           : oAluCtrl.REG_COMMPUTATION = SUB;
      JUMP             : oAluCtrl.IMM_COMPUTATION  = IMM_ADD;

      UPPER : begin
        if (iInstructionSubType == LOAD_UPPER_IMM) oAluCtrl.IMM_COMPUTATION = IMM_ADD;
        else                                       oAluCtrl.IMM_COMPUTATION = NULL_I;
      end

    endcase
  end

endmodule
