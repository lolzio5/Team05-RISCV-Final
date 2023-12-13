module Cache #(
    parameter  INDEX_WIDTH = 4,
               DATA_WIDTH =32
)(
    input logic iCLK,
    input logic [INDEX_WIDTH-1:0] iIndex,
    input logic  iFlush,
    input logic  [31:0] iAddress,
    input logic iHit,
    input logic  [INDEX_WIDTH-1:0] iFlushAddress,
    output logic [25:0] oTag,
    output logic oV,
    output logic [DATA_WIDTH-1:0]    oData
);
//////////////////////////////////////////////
////           Cache memory               ////
//////////////////////////////////////////////

    //Ram arrays
    logic [31:0] data_cache_array [0:2**INDEX_WIDTH-1];
    logic valid_cache_array [0:2**INDEX_WIDTH-1];
    logic [25:0] tag_cache_array [0:2**INDEX_WIDTH-1];

    always_comb begin

        oTag = tag_cache_array[iIndex];
        oV = valid_cache_array[iIndex];
        oData = data_cache_array[iIndex];
        
    end
//////////////////////////////////////////////
////         Logic to flush cache         ////
//////////////////////////////////////////////
    always_comb begin
        if (iFlush==1) begin
            valid_cache_array[iFlushAddress] <= 0;
        end
    end
//////////////////////////////////////////////
////         hit/miss handling            ////
//////////////////////////////////////////////
    always_ff @(negedge iCLK) begin
        if (iHit==1)begin 
            oData = data_cache_array[iIndex];   

        end
    end
endmodule
