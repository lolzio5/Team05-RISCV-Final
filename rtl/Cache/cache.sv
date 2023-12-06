module cache #(
    parameter  ADDRESS_WIDTH = 8,
               DATA_WIDTH = 32
)(
    input logic iCLK,
    input logic [DATA_WIDTH-1:0] iAddress,
    input logic [DATA_WIDTH-1:0] iInput,
    input logic iRead,
    output logic [DATA_WIDTH-1:0]    oData,
    output logic oHit
);

    logic [DATA_WIDTH-1:0] cache_array [0:2**ADDRESS_WIDTH-1];

    always_ff @(negedge iClk) begin
        if (iHit==1) oReadCache=1;
        else    oReadCache=0;   
    end

endmodule
