module JumpBranchHandlerF(
  input  logic [31:0] iInstructionF,
  output logic [31:0] oJBTarget,
  output logic        oTakeJBF
);

  always_comb begin
    if (iInstructionF[6:0] == 7'd99 & iInstructionF[31] == 1'b1) begin
      oTakeJBF   = 1'b1;
      oJBTarget  = {21{iInstructionF[31]}, iInstructionF[7], iInstructionF[30:25], iInstructionF[11:8], 1'b0}; 
    end

    else if (iInstructionF[6:0] == 7'd103) begin
      oTakeJBF  = 1'b1;
      oJBTarget = {13{iInstructionF[31]}, iInstructionF[19:12], iInstructionF[20], iInstructionF[30:21], 1'b0};
    end

    else begin
      oTakeJBF   = 1'b0;    
      oJBTarget  = 32'b0;
    end
  end

endmodule