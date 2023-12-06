module findhit (
    input  logic iV,
    input  logic [3:0]  itag1,
    input  logic [3:0]  itag2,
    output logic  oHit
);
always_comb begin
    oHit=0;
    if (itag1==itag2&&iV==1) begin
        oHit=1;
    end
end 

endmodule
