module FPipelineRegisterD(
    input  logic        iClk,
    input  logic        iStallD,
    input  logic        iFlushD,

    input  logic [31:0] iInstructionF,
    input  logic [31:0] iPCF,
    input  logic        iTakeJBF,

    output logic [31:0] oInstructionD,
    output logic [31:0] oPCD,
    output logic        oTakeJBD
);

    initial begin
        oInstructionD = 32'b0;
        oPCD = 32'b0;
        oTakeJBD = 1'b0;
    end

    always_ff @ (posedge iClk) begin 

        if (iFlushD) begin
            // Reset the outputs when the pipeline is flushed
            oInstructionD <= 32'b0;
            oPCD          <= 32'b0;
            oTakeJBD      <= 1'b0;
        end 
        
        else if (!iStallD) begin
            // Update the outputs with new values when not stalled
            oInstructionD <= iInstructionF;
            oPCD          <= iPCF;
            oTakeJBD      <= iTakeJBF;
        end
        // When stalled, retain the current values (no else branch needed)
    end
    
endmodule
