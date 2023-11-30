`include "include/ControlTypeDefs.svh"

module AluEncode(
  input InstructionTypes iInstructionType,
  input InstructionSubTypes iInstructionSubType,

  output AluOp oAluCtrl
);



  always_comb begin

    case(iInstructionType)

      REG_COMMPUTATION : oAluCtrl.REG_COMPUTATION  = iInstructionSubType.R;
      IMM_COMPUTATION  : oAluCtrl.IMM_COMPUTATION  = iInstructionSubType.I;
      STORE            : oAluCtrl.IMM_COMPUTATION  = IMM_ADD; //Might need to change this. Instead of ALU computing store/load/branch/jump address, use a seperate unit
      LOAD             : oAluCtrl.IMM_COMPUTATION  = IMM_ADD;
      BRANCH           : oAluCtrl.REG_COMPUTATION  = SUB;
      JUMP             : oAluCtrl.IMM_COMPUTATION  = IMM_ADD;

      UPPER : begin
        if (iInstructionSubType == LOAD_UPPER_IMM) oAluCtrl.IMM_COMPUTATION = IMM_ADD;
        else                                       oAluCtrl.IMM_COMPUTATION = NULL_I;
      end

      default : oAluCtrl.NULL = 4'b1111;
    endcase
  end

endmodule
