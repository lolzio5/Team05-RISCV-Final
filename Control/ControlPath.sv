module ControlPath (
  input  logic [32:1] iInstruction,

  output logic [ 4:1] oAluControl,

  output logic [12:1] oImmSrc,
  output logic        oAluSrc,
  output logic        oPCSrc,
  output logic        oResultSrc,

  output logic        oMemWrite,
  output logic        oRegWrite  
  
  output logic [5:1]  oRs1,
  output logic [5:1]  oRs2,
  output logic [5:1]  oRd
  
);
/*
TO DO : 

Implement logic to determine the following :

PCSrc
ResultSrc
MemWrite
Rs1
Rs2
Rd

*/
logic [7:1] op_code;
logic [3:1] funct3;
logic [7:1] funct7;


logic i_type;
logic r_type;
logic u_type;
logic s_type;
logic b_type;

logic jmp_link;
logic jmp_linkr;
logic add_pc;

logic [3:1] imm_ins_t;

always_comb begin
  funct3 = instruction[15:13];
  funct7 = instruction[32:26];
  OpCode = instruction[7:1];

end

ControlDecode ControlDecode(
  .iOpCode(op_code),
  .iFunct3(funct3),
  .iFunct7(funct7),

  .oAluControl(),
  .oTypeI(),
  .oTypeU(),
  .oTypeJ(),
  .oTypeS(s_type),
  .oTypeR(r_type),
  .oTypeB(b_type)
);

always_comb begin
  imm_ins_t[1] = i_type;
  imm_ins_t[2] = s_type;
  imm_ins_t[3] = b_type;

  RegWrite = !(b_type || s_type); 
  AluSrc =  s_type || i_type;
end

imm_decode ImmDecoder(
  .instruction(instruction),
  .ins_type(imm_ins_t),

  .imm(ImmSrc)
);



endmodule
