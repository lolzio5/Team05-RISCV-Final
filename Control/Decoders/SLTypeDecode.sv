module SLTypeDecode(
  input  logic [3:1] iFunct3,
  input  logic       iLoad,
  input  logic       iStore,

  output logic [3:1] oLoadTypes;
  output logic [2:1] oULoadTypes;
  output logic [3:1] oStoreTypes;
);

  logic [2:1] funct3_lsbs;
  logic [8:1] output_ldr;
  logic [4:1] output_str

  assign funct3_lsbs = funct3[2:1];

  EightDeMux demux8(
    .data_in(Load),
    .select(funct3),
    .data_out(output_ldr)
  );

  FourDeMux demux4(
    .data_in(Store),
    .select(funct3_lsbs),
    .data_out(output_str)
  );

  always_comb begin
    LoadTypes = output_ldr[3:1];
    ULoadTypes = output_ldr[4:3];
    StoreTypes = output_str[3:1];
  end

endmodule
