module FPipelineRegister (
    input  logic        iCLk,
    input  logic [31:0] iRDF,
    input  logic [31:0] iPCF,
    input  logic [31:0] iPCPlus4F,

    output logic [31:0] oInstrD,
    output logic [31:0] oPCD,
    output logic [31:0] oPCPlus4D,
);
  
    always_ff @ (posedge iClk) begin 
        oInstrD <= iRDF;
        oPCD <= iPCF;
        oPCPlus4D <= iPCPlus4F;
    end

endmodule
