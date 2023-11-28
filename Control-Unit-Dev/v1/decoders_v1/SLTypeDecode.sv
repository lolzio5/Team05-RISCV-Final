module SLTypeDecode(
  input  logic [3:1] iFunct3,
  input  logic       iLoad,
  input  logic       iStore,

  output logic [3:1] oLoadTypes;
  output logic [2:1] oULoadTypes;
  output logic [3:1] oStoreTypes;
);

  logic [2:1] funct3_lsbs;
  logic [8:1] buff_load_types;
  logic [4:1] buff_store_types;

  assign funct3_lsbs = funct3[2:1];

  EightDeMux demux8(
    .data_in(iLoad),
    .select(funct3),
    .data_out(buff_load_types)
  );

  FourDeMux demux4(
    .data_in(iStore),
    .select(funct3_lsbs),
    .data_out(buff_store_types)
  );

  always_comb begin
    oLoadTypes  = buff_load_types[3:1];
    oULoadTypes = buff_load_types[4:3];
    oStoreTypes = buff_store_types[3:1];
  end

endmodule
