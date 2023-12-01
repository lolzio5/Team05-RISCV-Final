module pcreg (
    input  logic         clk,
    input  logic         rst,
    input  logic         PCSrc,
    input  logic [31:0]  ImmExt,
    output logic [31:0]  PC
);

logic [31:0] PCNext;

always_ff @ (posedge clk or posedge rst) begin 
  if (rst) begin
        PC <= 32'b00000000000000000000000000000000;
  end
  else begin
      PC <= PCNext;
  end
    
end

pcmux myPcmux (
  .PC (PC),
  .ImmExt (ImmExt),
  .PCSrc (PCSrc), // 1 means use immediate
  .PCNext (PCNext)
);

endmodule
