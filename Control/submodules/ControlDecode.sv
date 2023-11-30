`include "include/ControlTypeDefs.svh"

module ControlDecode(
  input InstructionTypes    iInstructionType,
  input InstructionSubTypes iInstructionSubType,
  input  logic              iZero,
  output logic    [4:1]     oMemControl,
  output logic              oResultSrc,
  output logic              oPCSrc,
  output logic              oAluSrc,
  output logic              oRegWrite,
  output logic              oMemWrite
);



  /* TO DO : 

    -Check if the branch case makes sense with the team
    -Check is this kind of case by case structure is acceptable and makes sense
    -Add a default case if needed
    
  */

initial begin
  assign oRegWrite   = 1'b0;
  assign oAluSrc     = 1'b0;
  assign oPCSrc      = 1'b0;
  assign oResultSrc  = 1'b0;
  assign oMemWrite   = 1'b0;
  assign oMemControl = 4'b1000;
end

//Signals determined by Instruction type only
always_comb begin

  case(iInstructionType)

    REG_COMMPUTATION : oRegWrite = 1'b1;


    IMM_COMPUTATION  : begin
      oRegWrite = 1'b1;
      oAluSrc   = 1'b1;
    end


    LOAD   : begin
      oRegWrite  = 1'b1;
      oResultSrc = 1'b1;
    end


    UPPER  : begin
      if (iInstructionSubType == LOAD_UPPER_IMM) begin
        oRegWrite = 1'b1;
        oAluSrc   = 1'b1;
      end

/*
TO DO : 
  - Change the logic here as add upper pc adds the upper immediate to PC and stores it in Rd
*/

      else begin
        oPCSrc = 1'b1;
      end
    end


    STORE  : begin
      oMemWrite = 1'b1;
      oAluSrc = 1'b1;
    end


    JUMP   : begin
      oPCSrc = 1'b1;
      oRegWrite = 1'b1; //Since we write PC+4 to destination for JAL
    end


    BRANCH : begin
      case(iInstructionSubType) //May need to add cases for other branch instructions
        BNE : oPCSrc = ~iZero; //iZero = 1 -> regs are equal -> thus branch if iZero = 0 (not equal) 
        BEQ : oPCSrc = iZero;
        default oPCSrc = 1'b0;
      endcase
    end

    default : begin
      oRegWrite   = 1'b0;
      oAluSrc     = 1'b0;
      oPCSrc      = 1'b0;
      oResultSrc  = 1'b0;
      oMemWrite   = 1'b0;
      oMemControl = 4'b1000;
    end
  endcase
end

//for memory addressing control
always_comb begin

  case(iInstructionSubType)

    LOAD_WORD  : oMemControl = 4'b0000;
    LOAD_HALF  : oMemControl = 4'b0001;
    LOAD_BYTE  : oMemControl = 4'b0010;
  
    ULOAD_HALF : oMemControl = 4'b0011;
    ULOAD_BYTE : oMemControl = 4'b0100;

    STORE_WORD : oMemControl = 4'b0101;
    STORE_HALF : oMemControl = 4'b0110;
    STORE_BYTE : oMemControl = 4'b0111;

    default    : oMemControl = 4'b1000;
  endcase
end

endmodule
