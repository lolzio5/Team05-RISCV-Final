module PCRegisterF (
    input  logic         iClk,
    input  logic         iRst,
    input  logic         iStallF,
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
    //Must first check that the branch outcome in decode stage 
    //If we didnt branch when we needed to and the instruction in fetch is a backward branch, we should not execute the backward branch
    if (iPCSrcD == 1'b0) PCNext = iPCSrcF ? iBranchTarget : oPC + 32'd4;
    else                 PCNext = iTargetPC;
  end


//////////////////////////////////////////////////
////          PC Flip Flop Register           ////
//////////////////////////////////////////////////

  always_ff @ (posedge iClk or posedge iRst) begin 
    if      (iRst)       oPC <= {32{1'b0}};
<<<<<<< Updated upstream:rtl/PC/PCRegisterF.sv
    else if (!iStallF)    oPC <= PCNext;
=======
    else if (!StallF)    oPC <= PCNext;
>>>>>>> Stashed changes:rtl/PC/PCRegister.sv
  end


endmodule
