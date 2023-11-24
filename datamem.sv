module datamem #(
    parameter ADDRESS_WIDTH = 10,
              DATA_WIDTH = 32
)(
    input  logic                     clk,             // clock
    input  logic                     ResultSrc,       // choose ALU output or data from memory
    input  logic                     WE,              // write enable
    input  logic [DATA_WIDTH-1:0]    A,               // Write Address
    input  logic [DATA_WIDTH-1:0]    WD,              // Write Data
    output logic [DATA_WIDTH-1:0]    Result           // output
);

logic [DATA_WIDTH-1:0] ram_array [2**ADDRESS_WIDTH-1:0];
logic [DATA_WIDTH-1:0] RD;

always_ff @ (posedge clk) begin
    if (WE) ram_array[A] <= WD;
    else RD <= ram_array[A];  
end

datamux myDataMux(
    .ResultSrc (ResultSrc),
    .RD (RD),
    .A (A),
    .Result (Result)
);

endmodule
