module SignExtend(
  input  logic [20:1] iImm20,
  input  logic        iExtendType,

  output logic [32:1] oImmExt
);


always_comb begin
  oImmExt = iExtendType ? {iImm20, 12{1'b0}} : {12{iImm20[20]}, iImm20};
end


endmodule;
