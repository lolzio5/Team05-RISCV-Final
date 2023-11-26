module ALU_encode(
  input  logic [9:1] iAluOps,
  input  logic       iTypeB,
  input  logic       iTypeS,

  output logic [4:1] oAluCtrl,
);


////////////////////////////
///Internal Logic Signals///
////////////////////////////

  logic setless;
  logic usetless;

  logic add;
  logic sub;

  logic xor;
  logic and;

  logic shiftl;
  logic shiftr_logical;
  logic shiftr_arith;

/////////////////////////////
///Logic to Encode Signals///
/////////////////////////////

  always_comb begin

    setless              = iAluOps[1];
    usetless             = iAluOps[2];
    add                  = iAluOps[3] || store;
    sub                  = iAluOps[4] || branch;
    xor                  = iAluOps[5];
    and                  = iAluOps[6];
    shiftl               = iAluOps[7];
    shiftr_logical       = iAluOps[8];
    shiftr_arith         = iAluOps[9];


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
