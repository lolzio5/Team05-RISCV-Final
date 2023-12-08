module cache #(
    parameter  ADDRESS_WIDTH = 4,
               DATA_WIDTH =32,
               WIDTH = 64
)(
    input logic iCLK,
    input logic [4:0] iIndex,
    output logic [25:0] oTag,
    output logic oV,
    output logic [DATA_WIDTH-1:0]    oData
);

    logic [31:0] data_cache_array [0:2**ADDRESS_WIDTH-1];
    logic [0:0] valid_cache_array [0:2**ADDRESS_WIDTH-1];
    logic [25:0] tag_cache_array [0:2**ADDRESS_WIDTH-1];

    always_ff @(posedge iClk) begin
        oTag <= tag_cache_array[iIndex];
        oV <= valid_cache_array[iIndex];
        oData <= data_cache_array[iIndex];
    end

endmodule
