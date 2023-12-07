module PCRegister (
    input  logic         iClk,
    input  logic         iRst,
    input  logic         iPCSrcF,
    input  logic         iPCSrcD,
    input  logic [31:0]  iTargetPC,
    input  logic [31:0]  iBranchTarget,
    
    output logic [31:0]  oPC
);

////////////////////////////////////
////     Initialize Output       ///
////////////////////////////////////

  initial oPC = {32{1'b0}};


////////////////////////////////////
////     Internal Logic       //////
////////////////////////////////////

  logic [31:0] PCNext;


//////////////////////////////////////////////////
////   PC Mux - Select PCNext given PCSrc   //////
//////////////////////////////////////////////////

  always_comb begin
    if (iPCSrcF == 1'b0) PCNext = iPCSrcD ? iTargetPC : oPC + 32'd4;
    else                 PCNext = iBranchTarget ;
  end


//////////////////////////////////////////////////
////          PC Flip Flop Register           ////
//////////////////////////////////////////////////

  always_ff @ (posedge iClk or posedge iRst) begin 
    if (iRst) oPC <= {32{1'b0}};
    else      oPC <= PCNext;
  end


endmodule
