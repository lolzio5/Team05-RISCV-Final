module OpDecode(
  input  logic [7:1] iOpCode,
  output logic [9:1] oInstructionType 
);

initial assign oInstructionType = 9'b0_0000_0000; //might need to change placement of this

always_comb

  case(OpCode)
  
    7'd99  : oInstructionType[9] = 1'b1; //branch
    7'd103 : oInstructionType[8] = 1'b1; //jmp_link
    7'd111 : oInstructionType[7] = 1'b1; //jmp_link_reg
    7'd51  : oInstructionType[6] = 1'b1; //r_type
    7'd23  : oInstructionType[5] = 1'b1; //add_upper_imm_pc
    7'd55  : oInstructionType[4] = 1'b1; //load_upper_imm
    7'd19  : oInstructionType[3] = 1'b1; //reg_imm_computation
    7'd3   : oInstructionType[2] = 1'b1; //load
    7'd35  : oInstructionType[1] = 1'b1; //store
    default: oInstructionType = 9'b0_0000_0000;

  endcase

endmodule
