module FindHit (
    input  logic iV,
    input  logic [25:0]  iTagCache,
    input  logic [25:0]  iTagTarget,
    input logic iWriteEn,
    output logic  oHit
);
//////////////////////////////////////////////
////            Hit logic                 ////
//////////////////////////////////////////////
always_comb begin

    oHit=0;
    if (iTagCache==iTagTarget&&iV==1&&iWriteEn==0) begin
        oHit=1;
    end

end 
endmodule
