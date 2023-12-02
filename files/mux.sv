module mux #(
    parameter  DATA_WIDTH =32
)(
    input logic iselect,
    input logic [DATA_WIDTH-1:0] iSrcA,
    input logic [DATA_WIDTH-1:0] iSrcB,
    output logic [DATA_WIDTH-1:0] oselected
);

always_comb begin
    if(iselect==1'b1)
        oselected=iSrcA;
    else
        oselected=iSrcB;
end

endmodule
