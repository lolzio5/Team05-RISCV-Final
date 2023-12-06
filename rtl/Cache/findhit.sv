module findhit (
    input  logic iV,
    input  logic [26:0]  iTagCache,
    input  logic [26:0]  iTagTarget,
    output logic  oHit
);
always_comb begin
    oHit=0;
    if (iTagCache==iTagTarget&&iV==1) begin
        oHit=1;
    end
end 
endmodule
