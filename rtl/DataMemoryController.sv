`include "include/ControlTypeDefs.svh"

module DataMemoryController #(
    parameter DATA_WIDTH = 32
 )(
    input  logic         iClk,
    input logic          iWriteEn,
    input InstructionTypes  iMemoryInstructionType, 
    input  InstructionTypes          iInstructionType,   
    input logic [DATA_WIDTH-1:0]   iAddress,
    input  logic [DATA_WIDTH-1:0]    iMemData,        // Write Data
    output logic [DATA_WIDTH-1:0]  oMemData, 
    output logic [DATA_WIDTH-1:0]  oMemDatat,  
    output logic memt

);

logic [25:0] ATag;
logic [25:0] CTag;
logic [3:0]  AIndex;
logic [3:0]  FlushIndex;
logic [DATA_WIDTH-1:0] CData;
logic CValid;
logic hit;
logic dhit;
logic [DATA_WIDTH-1:0] MainMemoryData;
logic [DATA_WIDTH-1:0] MainMemoryAdress;
logic ReadMainMemory;
logic [DATA_WIDTH-1:0] iFlushAddress;
logic [DATA_WIDTH-1:0] cData; 
logic [DATA_WIDTH-1:0] mData;
logic [DATA_WIDTH-1:0] word_aligned_address;
logic [1:0] byte_offset;
logic [7:0] byte1;
logic [7:0] byte2;
logic [7:0] byte3;
logic [7:0] byte4;
logic [DATA_WIDTH-1:0] writeCache;

CacheDecode CacheDecode(
    .iAddress(iAddress),
    .iFlushAddress(iFlushAddress),
    .oIndexFlush(FlushIndex),
    .oTag(ATag),
    .oIndex(AIndex)
);

Cache Cache(
    .iCLK(iClk),
    .iIndex(AIndex),
    .iFlush(iWriteEn),
    .iAddress(iAddress),
    .iHit(hit),
    .iFlushAddress(FlushIndex),
    .iWriteCacheData(writeCache),
    .oTag(CTag),
    .oV(CValid),
    .oData(cData)
);

DataMemoryM DataMemoryM(
    .iClk(iClk),
    .iWriteEn(iWriteEn),
    .iInstructionType(iInstructionType),
    .iMemoryInstructionType(iMemoryInstructionType), 
    .iAddress(iAddress),
    .iMemData(iMemData),
    .oMemData(mData),
    .oWriteCache(writeCache)
);


FindHit FindHit(
    .iClk(iClk),
    .iV(CValid),
    .iTagCache(CTag),
    .iTagTarget(ATag),
    .iWriteEn(iWriteEn),
    .oHit(hit)
);

always_comb begin

    if (iWriteEn==1) begin
        iFlushAddress = iAddress;
    end
        
end

always_ff @(negedge iClk) begin
    if (hit==1 && iWriteEn==0) begin
        word_aligned_address = {{iAddress[31:2]}, {2'b00}};                 //Word aligned address -> multiple of 4
        byte_offset          = iAddress[1:0];                               //2 LSBs of iAddress define byte offset within the word
        oMemDatat=cData;
        byte4 =   cData[31:24];
        byte3 =   cData[23:16];
        byte2 =   cData[15:8];
        byte1 =   cData[7:0];
        case(iMemoryInstructionType)
            LOAD_BYTE  : begin

                case (byte_offset) 
                    2'b00 : oMemData[7:0] = byte1;
                    2'b01 : oMemData[7:0] = byte2;
                    2'b10 : oMemData[7:0] = byte3;
                    2'b11 : oMemData[7:0] = byte4;
                endcase

                oMemData[31:8] = {24{oMemData[7]}}; //sign extend
            end

            LOAD_HALF  : begin

                case (byte_offset) 
                    2'b00 : oMemData[15:0] = {byte2, byte1};
                    2'b01 : oMemData[15:0] = {byte3, byte2};
                    2'b10 : oMemData[15:0] = {byte4, byte3};
                    2'b11 : oMemData[15:0] = {byte4, byte3};
                endcase
                        
                oMemData[31:16] = {16{oMemData[15]}}; //sign extend
            end

            ULOAD_BYTE : begin            

                case (byte_offset) 
                    2'b00 : oMemData[7:0] = byte1;
                    2'b01 : oMemData[7:0] = byte2;
                    2'b10 : oMemData[7:0] = byte3;
                    2'b11 : oMemData[7:0] = byte4;
                endcase

                oMemData[31:8] = {24{1'b0}}; //zero extend

            end

            ULOAD_HALF : begin

                case (byte_offset) 
                    2'b00 : oMemData[15:0] = {byte2, byte1};
                    2'b01 : oMemData[15:0] = {byte3, byte2};
                    2'b10 : oMemData[15:0] = {byte4, byte3};
                    2'b11 : oMemData[15:0] = {byte4, byte3};
                endcase

                oMemData[31:16] = {16{1'b0}}; //Zero extend

            end

            LOAD_WORD  : begin
                oMemData = {byte4, byte3, byte2, byte1};     
                memt=1;          
            end
            default    : begin 
                oMemData = {byte4, byte3, byte2, byte1};

                memt=1;
            end
        endcase
    end
        //dhit=1;
    else begin
        oMemData = mData;
        //oMemDatat = mData;
        //memt=0;
    end   
end
endmodule

