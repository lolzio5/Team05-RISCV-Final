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
      case(iInstructionSubType)
        BNE : oPCSrc = ~iZero; //iZero = 1 -> regs are equal -> thus branch if iZero = 0 (not equal) 
        BEQ : oPCSrc = iZero;
        default oPCSrc = 1'b0;
      endcase
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
