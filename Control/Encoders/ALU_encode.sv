module ALU_encode(
  input  logic [9:1] alu_ins,
  input logic branch,
  input logic store,
  output logic [4:1] AluCtrl,
);

logic setless;
logic usetless;

logic add;
logic sub;

logic xor;
logic and;

logic shiftl;
logic shiftr_logical;
logic shiftr_arith;


always_comb begin

 setless              = alu_ins[1];
 usetless             = alu_ins[2];
 add                  = alu_ins[3] || store;
 sub                  = alu_ins[4] || branch;
 xor                  = alu_ins[5];
 and                  = alu_ins[6];
 shiftl               = alu_ins[7];
 shiftr_logical       = alu_ins[8];
 shiftr_arith         = alu_ins[9];

  if (setless || usetless || add || sub) begin
    AluCtrl[4:3] = 2'b00 ;
    AluCtrl[2] = ~add & ~sub ;
    AluCtrl[1] = ~setless & (usetless ^ add);
  end

  else if (xor || and || shiftl || shiftr_logical) begin
    AluCtrl[4:3] = 2'b01 ;
    AluCtrl[2] = ~shiftl & ~shiftr_logical ;
    AluCtrl[1] = ~xor & (and ^ shiftl);
  end

  else begin
   AluCtrl[4:2] = 3'b100;
   AluCtrl[1] = shiftr_arith
  end

end

endmodule
