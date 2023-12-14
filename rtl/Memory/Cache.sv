module Cache #(
    parameter  INDEX_WIDTH = 4,
               DATA_WIDTH =32
)(
    input logic iCLK,
    input logic [INDEX_WIDTH-1:0] iIndex,
    input logic  iFlush,
    input logic  [DATA_WIDTH-1:0] iAddress,
    input logic iHit,
    input logic [DATA_WIDTH-1:0] iWriteCacheData,
    input logic  [INDEX_WIDTH-1:0] iFlushAddress,
    output logic [25:0] oTag,
    output logic oV,
    output logic [DATA_WIDTH-1:0]    oData,
    output logic [DATA_WIDTH-1:0]    oDatatest
);
//////////////////////////////////////////////
////           Cache memory               ////
//////////////////////////////////////////////

    //Ram arrays
    logic [DATA_WIDTH-1:0] data_cache_array [0:2**INDEX_WIDTH-1];
    logic valid_cache_array [0:2**INDEX_WIDTH-1];
    logic [25:0] tag_cache_array [0:2**INDEX_WIDTH-1];

    always_comb begin
    //always_ff @(negedge iCLK) begin
        oTag = tag_cache_array[iIndex];
        oV = valid_cache_array[iIndex];
        oData = data_cache_array[iIndex];
        
    end
//////////////////////////////////////////////
////         Logic to flush cache         ////
//////////////////////////////////////////////
    always_comb begin
    //always_ff @(negedge iCLK) begin
        if (iFlush==1) begin
            valid_cache_array[iFlushAddress] <= 0;
        end
    end
//////////////////////////////////////////////
////         hit/miss handling            ////
//////////////////////////////////////////////
    //always_ff @(negedge iCLK) begin
    always_comb begin

        if (iHit==1)begin 
            oData = data_cache_array[iIndex];   
        end
        else begin
            tag_cache_array[iIndex] = iAddress[31:6];
            valid_cache_array[iIndex] = 1;
            data_cache_array[iIndex]= iWriteCacheData;
            oDatatest=data_cache_array[iIndex];
        end
    end
endmodule
