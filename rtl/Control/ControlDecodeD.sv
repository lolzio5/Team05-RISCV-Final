`include "include/ControlTypeDefs.svh"
module ControlDecodeD(
  input  InstructionTypes    iInstructionType,
  input  InstructionSubTypes iInstructionSubType,
  input  logic               iZero,

  output logic    [2:0]      oResultSrc,
  output logic               oPCSrc,
  output logic               oAluSrc,
  output logic               oRegWrite,
  output logic               oMemWrite
);

////////////////////////////////////////////////////////////////////////////////////////////////
//// Logic to Determine Src Signals Given Current Instruction executing and Zero Flag Value ////
////////////////////////////////////////////////////////////////////////////////////////////////

  always_comb begin

    //Initialise Output Signals
    oRegWrite   = 1'b0;
    oAluSrc     = 1'b0;
    oPCSrc      = 1'b0;
    oResultSrc  = 3'b000;
    oMemWrite   = 1'b0;

    case(iInstructionType)

      REG_COMMPUTATION : oRegWrite = 1'b1;


      IMM_COMPUTATION  : begin
        oRegWrite = 1'b1;
        oAluSrc   = 1'b1;
      end


      LOAD   : begin
        oRegWrite  = 1'b1;
        oResultSrc = 3'b001;
      end


      UPPER  : begin
        if (iInstructionSubType == LOAD_UPPER_IMM) begin
          oRegWrite  = 1'b1;
          oAluSrc    = 1'b1;
          oResultSrc = 3'b011;
        end

        else begin
          oResultSrc = 3'b100; //Data written to register will come from the PC adder
          oPCSrc     = 1'b0;  //PC increments by 4
        end
      end


      STORE  : begin
        oMemWrite = 1'b1;
        oAluSrc   = 1'b1;
      end


      JUMP   : begin
        oPCSrc     = 1'b1;
        oResultSrc = 3'b010;  //Store PC + 4 to destination reg
        oRegWrite  = 1'b1;    //Since we write PC+4 to destination for JAL
      end


      BRANCH : begin
        case(iInstructionSubType)
          BNE     : oPCSrc   = ~iZero;  //iZero = 1 -> regs are equal -> thus branch if iZero = 0 (not equal) 
          BEQ     : oPCSrc   = iZero;
          default : oPCSrc   = 1'b0;
        endcase
      end

      default : begin
        oRegWrite   = 1'b0;
        oAluSrc     = 1'b0;
        oPCSrc      = 1'b0;
        oResultSrc  = 3'b000;
        oMemWrite   = 1'b0;
      end

    endcase
  end

endmodule
