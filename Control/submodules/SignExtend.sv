module SignExtend(
  input  logic [19:0] iImm20,
  input  logic        iExtendType,

  output logic [31:0] oImmExt
);


always_comb begin
  oImmExt = iExtendType ? {iImm20, {12{1'b0}}} : {{12{iImm20[19]}}, iImm20}; //if we have Upper or jump then iExtendType = 1
end


endmodule;
