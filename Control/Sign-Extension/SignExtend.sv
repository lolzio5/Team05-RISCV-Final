module SignExtend(
  input logic [12:1] imm_12,
  output logic[32:1] imm_32ext
);

assign imm_32ext = {20'b{imm_12[12]}, imm_12};


endmodule;
