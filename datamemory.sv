module datamermory #(
    parameter DATA_ADDR =8, //not sure what size to make this?
    parameter DATA_WIDTH =32
)
(
    input logic CLK,
    input logic [DATA_ADDR-1:0] A,
    input logic                 WE,
    input logic [DATA_WIDTH-1:0] WD,
    output logic [DATA_WIDTH-1:0] RD
)

logic [DATA_WIDTH-1:0] ram_array [0:2**ADDRESS_WIDTH-1];

always_ff @( posedge clk ) begin
    if(WE==1'b1)
        ram_array[A] <= WD;
    else
        RD<=ram_array[A]
end