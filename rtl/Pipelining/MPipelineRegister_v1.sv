module MPipelineRegisterW(
    input   logic        iClk,
    input   logic [31:0] iPCM,
    input   logic [31:0] iImmExtM,
    input   logic [31:0] iMemDataOutM,
    input   logic [31:0] iAluOutM,
    input   logic [4:0]  iDestRegM,

    output  reg logic [31:0] oPCW,
    output  reg logic [31:0] oImmExtW,
    output  reg logic [31:0] oMemDataOutW,
    output  reg logic [31:0] oAluOutW,
    output  reg logic [4:0]  oDestRegW
);
  
    always_ff @ (posedge iClk) begin 
        oPCW         <= iPCM;
        oImmExtW     <= iImmExtM;
        oMemDataOutW <= iMemDataOutM;
        oAluOutW     <= iAluOutM;
        oDestRegW    <= iDestRegM;
    end
    
endmodule
