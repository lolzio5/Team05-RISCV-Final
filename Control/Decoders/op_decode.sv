module op_decode(

  input logic [7:1] OpCode,

  output logic branch,
  output logic jmp_link,
  output logic jmp_linkr,
  output logic upper,
  output logic r,
  output logic add_u_pc,
  output logic imm_manip,
  output logic load,
  output logic store

);

always_comb

  branch, jmp_link, jmp_linkr, upper, r, add_u_pc, load, store = 1'b0 ;

  case(OpCode)
    7'd99  : branch     = 1'b1;
    7'd51  : r          = 1'b1;
    7'd55  : upper      = 1'b1;
    7'd103 : jmp_link   = 1'b1;
    7'd111 : jmp_linkr  = 1'b1;
    7'd23  : add_u_pc   = 1'b1;
    7'd19  : imm_manip  = 1'b1;
    7'd3   : load       = 1'b1;
    7'd35  : store      = 1'b1;
    default: branch, jmp_link, jmp_linkr, upper, r, add_u_pc, load, store = 1'b0 ;
  endcase

endmodule
