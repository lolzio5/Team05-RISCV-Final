module ControlDecode(
  input InstructionTypes    iInstructionType,
  input InstructionSubTypes iInstructionSubType,

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
end


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

    // TO DO : add control logic to check if PC src is 1 for branch instruction given the iZero input

  endcase
end


endmodule
