module cache #(
    parameter  INDEX_WIDTH = 4,
               DATA_WIDTH =32
)(
    input logic iCLK,
    input logic [INDEX_WIDTH-1:0] iIndex,
    input logic  iFlush,
    input logic  iAddress,
    input logic  [INDEX_WIDTH-1:0] iFlushAddress,
    input logic [DATA_WIDTH-1:0] iMainMemoryData,
    output logic [31:0] oMainMemoryAdress,
    output logic oReadMainMemory,
    output logic [25:0] oTag,
    output logic oV,
    output logic [DATA_WIDTH-1:0]    oData
);
//////////////////////////////////////////////
////           Cache memory               ////
//////////////////////////////////////////////

    //Ram arrays
    logic [31:0] data_cache_array [0:2**INDEX_WIDTH-1];
    logic [0:0] valid_cache_array [0:2**INDEX_WIDTH-1];
    logic [25:0] tag_cache_array [0:2**INDEX_WIDTH-1];

    always_comb begin

        oTag <= tag_cache_array[iIndex];
        oV <= valid_cache_array[iIndex];
        oData <= data_cache_array[iIndex];
        
    end
//////////////////////////////////////////////
////         Logic to flush cache         ////
//////////////////////////////////////////////
    always_comb begin
        if (iFlush==1) begin

            valid_cache_array[iFlushAddress] = 0;
        end
    end
//////////////////////////////////////////////
////         hit/miss handling            ////
//////////////////////////////////////////////
    always_comb begin
        oReadMainMemory <= 0;
        if (iHit==1)begin
            oData<=data_cache_array[iIndex];
            //always_ff @(posedge iClk) begin
                
            //end

        end

        else begin
            oMainMemoryAdress <= iAddress;
            oReadMainMemory <= 1;
            //always_ff @(posedge iClk) begin

            oData<=iMainMemoryData;
            tag_cache_array[iIndex]<=iAddress[31:6];
            valid_cache_array[iIndex]<=1;
            data_cache_array[iIndex]<=iMainMemoryData;

            //end
        end  
    end
endmodule
