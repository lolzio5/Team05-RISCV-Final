module Funct3Decode(

  input  logic [3:1] iFunct3,
  input  logic       iLoad,
  input  logic       iStore,
  input  logic       iTypeR,
  input  logic       iRegImmComputation,

  output logic [8:1] oComputationType
  output logic [3:1] oLoadTypeBHW,
  output logic [2:1] oULoadTypeBH,
  output logic [3:1] oStoreTypeBHW,

);

logic computation_ins;
assign computation_ins = iTypeR | iRegImmComputation ;


  /*
  oLoadType  = {load byte, load half, load word}
  oULoadType = {load unsigned byte, load unsigned half}
  oStoreType = {store byte, store half, store word}
  */

SLTypeDecode StoreLoadDecoder(
  .Load(iLoad),
  .Store(iStore),
  .iFunct3(iFunct3),

  .LoadTypes(oLoadBHW),
  .ULoadTypes(oULoadBH),

  .StoreTypes(oStoreBHW)
);


  /*
  oComputationType = {arithmetic, 
                      left shift, 
                      set less, 
                      unsigned set less, 
                      xor, 
                      right shift, 
                      or, 
                      and}
  */
  
ComputationDecode ComputationDecoder(
  .iComputationIns(computational_ins),
  .iFunct3(iFunct3),

  .oComputationType(oComputationType)
);

endmodule
