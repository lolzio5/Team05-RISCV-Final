module FPipelineRegister (
    input  logic        iCLk,
    input  logic        iStallD,
    input  logic [31:0] iRDF,
    input  logic [31:0] iPCPlus4F,

    output logic [31:0] oInstrD,
    output logic [31:0] oPCPlus4D
);
    always_ff @ (posedge iClk) begin 
        if(iStallD==0) begin
                oInstrD <= iRDF;
                oPCPlus4D <= iPCPlus4F;
            end
    end

    always_comb begin
        if(iStallD) begin
            oInstrD = iRDF;
            oPCPlus4D = iPCPlus4F;
        end
    end
endmodule
