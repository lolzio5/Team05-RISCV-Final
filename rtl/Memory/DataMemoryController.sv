`include "include/ControlTypeDefs.svh"

module cache_top(
    input  logic         iClk,
    input logic          iWriteEn,
    input logic          iInstructionType,
    input InstructionTypes  iMemoryInstructionType, 
    input  InstructionTypes          iInstructionType,   
    input logic [31:0]   iAddress,
    input  logic [DATA_WIDTH-1:0]    iMemData,        // Write Data
    output logic [31:0]  oMemData  
    
);

logic [25:0] ATag;
logic [25:0] CTag;
logic [3:0]  AIndex;
logic [3:0]  FlushIndex;
logic [31:0] CData;
logic CValid;
logic hit;
logic [31:0] MainMemoryData;
logic [31:0] MainMemoryAdress;
logic ReadMainMemory;
logic [31:0] iFlushAddress;
logic [31:0] cData; 
logic [31:0] mData;
logic [31:0] word_aligned_address;
logic [1:0] byte_offset;

always_comb begin

    if (iWriteEn==1) begin
        iFlushAddress <= iAddress;
    end
        
end

always_comb begin
    if (hit==1&&iWriteEn==0) begin
        word_aligned_address = {{iAddress[31:2]}, {2'b00}};                 //Word aligned address -> multiple of 4
        byte_offset          = iAddress[1:0];                               //2 LSBs of iAddress define byte offset within the word
        
        byte4 =   cData[24:31];
        byte3 =   cData[16:23];
        byte2 =   cData[8:15];
        byte1 =   cData[0:7];
        case (iInstructionType) 
            LOAD : begin  
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

                    LOAD_WORD  : oMemData = {byte4, byte3, byte2, byte1};               

                    default    : oMemData = {byte4, byte3, byte2, byte1};
                endcase
            end

            default : oMemData = {byte4, byte3, byte2, byte1};
        endcase
    end
    else (iWriteEn==0) begin
        oMemData<=mData;
    end
        
end

cache_decode cache_decode(
    .iAddress(iAddress),
    .iFlushAddress(iFlushAddress),
    .oIndexFlush(FlushIndex),
    .oTag(ATag),
    .oIndex(AIndex)
);

cache cache(
    .iCLK(iClk),
    .iIndex(AIndex),
    .iFlush(iWriteEn),
    .iAddress(iAddress),
    .iHit(hit),
    .iFlushAddress(FlushIndex),
    .iMainMemoryData(MainMemoryData),
    .oMainMemoryAdress(MainMemoryAdress),
    .oReadMainMemory(ReadMainMemory),
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
    .iMemData(iM),
    .oMemData(mData)
);


findhit findhit(
    .iV(CValid),
    .iTagCache(CTag),
    .iTagTarget(ATag),
    .iWriteEn(iWriteEn),
    .oHit(hit)
);
endmodule
