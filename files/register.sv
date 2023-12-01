module register #(
    parameter  ADDRESS_WIDTH = 5,
               DATA_WIDTH = 32
)(
    input logic CLK,
    input logic WE3,
    input logic [ADDRESS_WIDTH-1:0] AD1,
    input logic [ADDRESS_WIDTH-1:0] AD2,
    input logic [ADDRESS_WIDTH-1:0] AD3,
    input logic [DATA_WIDTH-1:0] WD3,  
    output logic [DATA_WIDTH-1:0] RD1,
    output logic [DATA_WIDTH-1:0] RD2 
);

logic [DATA_WIDTH-1:0] ram_array [0:2**ADDRESS_WIDTH-1];

initial begin
    ram_array[0] = {DATA_WIDTH{1'b0}};
end

always_ff @ (posedge CLK ) begin
    if(WE3==1'b1) begin
        ram_array[AD3] <= WD3;
    end
    else begin
        RD1<=ram_array[AD1];
        RD2<=ram_array[AD2];
    end
end

endmodule
