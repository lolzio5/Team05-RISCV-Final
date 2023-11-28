module Funct7Decode(
  input  logic       iArithmeticIns,  
  input  logic       iShiftRightIns,
  input  logic [7:1] iFunct7,

  output logic [2:1] oArithmeticType,
  output logic [2:1] oRightShiftType
);

////////////////////////////
///Internal Logic Signals///
////////////////////////////
logic type_select;

always_comb begin
  if (funct7 == 7'b01000000) type_select = 1'b1; 
  else                       type_select = 1'b0; 
end

/////////////////////////////////////////////
///2Demux : Determine arithmetic operation///
/////////////////////////////////////////////

  /*
  type_select = 1 : oArithmeticType = {sub}{add} = 10
  type_select = 0 : oArithmeticType = {sub}{add} = 01
  */

TwoDeMux demux_addsub(
  .select(type_select),
  .data_in(iArithmeticIns),
  .data_out(oArithmeticType)
);


//////////////////////////////////////////////
///2Demux : Determine Right Shift operation///
//////////////////////////////////////////////

  /*
  type_select = 1 : oRightShiftType = {arithmetic}{logical} = 10
  type_select = 0 : oRightShiftType = {arithmetic}{logical} = 01
  */

TwoDeMux demux_shift(
  .select(type_select),
  .data_in(iShiftRightIns),
  .data_out(oRightShiftType)
);

endmodule
