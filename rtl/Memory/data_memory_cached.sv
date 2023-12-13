`include "include/ControlTypeDefs.svh"

module cache_top(
    input  logic         iClk,
    input logic          iWriteEn,
    input logic          iInstructionType,
    input InstructionTypes  iMemoryInstructionType, 
    input  InstructionTypes          iInstructionType,
    input logic [31:0]   ,    
    input logic [31:0]   iAddress,
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
logic [31:0] tData;

always_comb begin
    word_aligned_address = {{iAddress[31:2]}, {2'b00}};     //Word aligned address -> multiple of 4
    byte_offset          = iAddress[1:0];                   //2 LSBs of iAddress define byte offset within the word
    mem_cell             = mem_array[word_aligned_address]; //Init accessed memory cell with data at the word aligned address
end

always_comb begin
        case (iInstructionType) 

            //Write Operation
            STORE : begin
                case (iMemoryInstructionType)

                    STORE_BYTE : mem_cell[byte_offset*8 +: 8]  = iMemData[7:0];   // Byte
                    
                    STORE_HALF : begin
                        if (byte_offset == 2'b11) mem_cell[31:16]               = iMemData[15:0];
                        else                      mem_cell[byte_offset*8 +: 16] = iMemData[15:0];  // Half-word
                    end
                    
                    STORE_WORD : mem_cell                      = iMemData;        // Word

                    default    : mem_cell                      = iMemData;        // Word
                endcase
            end

            //Read Operation
            LOAD : begin  
                case(iMemoryInstructionType)

                    LOAD_BYTE  : begin
                        mem_data[7:0]  = mem_cell[byte_offset*8 +: 8]; 
                        mem_data[31:8] = {24{mem_data[7]}}; //sign extend
                    end

                    LOAD_HALF  : begin
                        if (byte_offset == 2'b11) mem_data[15:0] = mem_cell[31:16];  
                        else                      mem_data[15:0] = mem_cell[byte_offset*8 +: 16];
                        
                        mem_data[31:16] = {16{mem_data[15]}}; //sign extend
                    end

                    ULOAD_BYTE : mem_data = {{24{1'b0}}, mem_cell[byte_offset*8 +: 8]}; //Zero extend
                    
                    ULOAD_HALF : begin
                        if (byte_offset == 2'b11) mem_data[15:0] = mem_cell[31:16];  
                        else                      mem_data[15:0] = mem_cell[byte_offset*8 +: 16];

                        mem_data[31:16] = {16{1'b0}}; //Zero extend
                    end

                    LOAD_WORD  : mem_data = mem_cell;               

                    default    : mem_data = mem_cell; 
                endcase
            end

            default : mem_data = mem_cell;

        endcase
    end

endmodule

always_comb begin

    if (iWriteEn==1) begin
        iFlushAddress <= iAddress;
    end
        
end

always_ff @(negedge iClk) begin
    oData=tData;
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
    .oData(tData)
);

DataMemory DataMemory(
    .iClk(iClk),
    .iWriteEn(iWriteEn),
    .iInstructionType(iInstructionType),
    .iMemoryInstructionType(iMemoryInstructionType), 
    .iAddress(iAddress),
    .iMemData(iMemData),
    .oMemData(mem_data_out)
);

findhit findhit(
    .iV(CValid),
    .iTagCache(CTag),
    .iTagTarget(ATag),
    .oHit(hit)
);
endmodule
