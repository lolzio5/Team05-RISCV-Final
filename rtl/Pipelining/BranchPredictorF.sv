module BranchPredictorF(
  input  logic [31:0] iInstructionF,
  output logic        oTakeBranch,
  output logic        oBranchTarget
);

  always_comb begin
    if (iInstructionF[6:0] == 7'd99 & iInstructionF[31] == 1'b1) begin
      oTakeBranch   = 1'b1;
      oBranchTarget = {21{instruction_d[31]}, instruction_d[7], instruction_d[30:25], instruction_d[11:8], 1'b0}; 
    end

    else begin
      oTakeBranch   = 1'b0;
      oBranchTarget = 31'b0;
    end
  end

endmodule