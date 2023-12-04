module register #(
    parameter  ADDRESS_WIDTH = 5,
               DATA_WIDTH = 32
)(
    input logic iCLK,
    input logic iWE3,
    input logic [ADDRESS_WIDTH-1:0] iAD1,
    input logic [ADDRESS_WIDTH-1:0] iAD2,
    input logic [ADDRESS_WIDTH-1:0] iAD3,
    input logic [DATA_WIDTH-1:0] iWD3,  
    output logic [DATA_WIDTH-1:0] oRD1,
    output logic [DATA_WIDTH-1:0] oRD2 
);

logic [DATA_WIDTH-1:0] ram_array [0:2**ADDRESS_WIDTH-1];

initial begin
    ram_array[0] = {DATA_WIDTH{1'b0}};
end

always_ff @ (posedge iCLK ) begin
    if(iWE3==1'b1) begin
        ram_array[iAD3] <= iWD3;
    end
    else begin
        oRD1<=ram_array[iAD1];
        oRD2<=ram_array[iAD2];
    end
end

endmodule
