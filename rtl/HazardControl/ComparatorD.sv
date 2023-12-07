`include "include/ControlTypeDefs.svh"
module ComparatorD(
  input  InstructionTypes    iInstructionTypeD,
  input  InstructionSubTypes iBranchTypeD,
  input  logic [31:0]        iRegData1D,
  input  logic [31:0]        iRegData2D,
  input  logic [31:0]        iImmExtD,
  output logic               oPCSrcD
);

always_comb begin

  case(iInstructionTypeD) :

    BRANCH : begin
      case(iBranchTypeD)

        BEQ : begin
          if (iRegData1D == iRegData2D)
        end

        BNE : begin

        end

      endcase
    end

    default : oPCSrcD = 1'b0;
  endcase
end

endmodule
