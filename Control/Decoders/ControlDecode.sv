module ControlDecode(
  input  logic [7:1] iOpCode,
  input  logic [3:1] iFunct3,
  input  logic [7:1] iFunct7,

  output logic [4:1] oAluCtrl
  output logic [2:1] oTypeI,
  output logic [2:1] oTypeU,
  output logic [2:1] oTypeJ,
  output logic       oTypeS,
  output logic       oTypeR,
  output logic       oTypeB,
);

/*
TO DO : 


*/

////////////////////////////
///Internal Logic Signals///
////////////////////////////

  logic [9:1] instruction_types;

  logic flag_ldr;
  logic flag_str;
  logic flag_r_type;
  logic flag_reg_imm_comp;
  logic flag_shift_right;
  logic flag_arithmetic;

  logic [3:1] load_types;
  logic [2:1] uload_types;
  logic [3:1] store_types;
  logic [8:1] computation_types;
  logic [2:1] arithemetic_types;
  logic [2:1] right_shift_types;


////////////////////////////////////////
///First Stage of Decoders : OpDecode///
////////////////////////////////////////

  op_decode OpDecode(
    .OpCode(OpCode),
    .oInstructionType(instruction_types)
  );

  always_comb begin
    TypeB = instruction_types[9];
    TypeJ = instruction_types[8:7];
    TypeR = instruction_types[6];
    TypeU = instruction_types[5:4];
    TypeI = instruction_types[3:2];
    TypeS = instruction_types[1];

    flag_reg_imm_comp = instruction_types[3];
    flag_r_type       = instruction_types[6];
    flag_ldr          = instruction_types[2];
    flag_str          = instruction_types[1];
  end


//////////////////////////////////////////////////////////
///Second Stage of Decoders : Funct3 and Func7 Decoders///
//////////////////////////////////////////////////////////

  Funct3Decode Funct3Decoder(
    .iFunct3(iFunct3),
    .iLoad(flag_ldr),
    .iStore(flag_str),
    .iTypeR(flag_r_type),
    .iRegImmComputation(flag_reg_imm_comp),

    .oLoadBHW(load_types),
    .oULoadBH(uload_types),
    .oStoreBHW(store_types),
    .oComputationType(computation_types)
  );

  Funct7Decode Funct7Decoder(
  
    .iArithmeticIns(flag_arithmetic),
    .iShiftRightIns(flag_shift_right),
    .iFunct7(iFunct7),

    .oArithmeticType(arithemetic_types),
    .oRightShiftType(right_shift_types)
  );


////////////////////////////////////////////////
///ALU Control Encoder - Generates AluControl///
////////////////////////////////////////////////

  logic [9:1] alu_message;

  //Fill in the alu message you want to encode
  always_comb begin
    alu_message[9:8] = right_shift_types;     //{arithmetic, logical}
    alu_message[7]   = computation_types[1];  //left shift
    alu_message[6]   = computation_types[8];  //and
    alu_message[5]   = computation_types[5];  //xor
    alu_message[4:3] = arithemetic_types;     //{sub, add}
    alu_message[2:1] = computation_types[4:3] //{usetless, setless}
  end

  ALU_encode AluEncoder(
    .iAluOps(AluMessage),
    .iTypeB(instruction_types[9]),
    .iTypeS(instruction_types[1]),

    .oAluCtrl(AluCtrl)
  );

endmodule
