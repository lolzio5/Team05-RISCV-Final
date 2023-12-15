`include "include/ControlTypeDefs.svh"
module NewMem #(
    parameter DATA_WIDTH = 32,
              INDEX_WIDTH = 4
 )(
    /* verilator lint_off UNUSED */
    input logic         iClk,
    input logic          iWriteEn,
    input InstructionTypes  iMemoryInstructionType, 
    input  InstructionTypes          iInstructionType,   
    input logic [DATA_WIDTH-1:0]   iAddress,
    input  logic [DATA_WIDTH-1:0]    iMemData,        
    output logic [DATA_WIDTH-1:0]  ooMemData
);
    logic [25:0] iTag;
    logic [3:0] iIndex;
    logic [25:0] cTag;
    logic [3:0] cIndex;
    logic [DATA_WIDTH-1:0] cData; 
    logic [DATA_WIDTH-1:0] oMemData; 
    logic [DATA_WIDTH-1:0] data_cache_array [0:2**INDEX_WIDTH-1];
    logic valid_cache_array [0:2**INDEX_WIDTH-1];
    logic [25:0] tag_cache_array [0:2**INDEX_WIDTH-1];
    logic [7:0] byte1;
    logic [7:0] byte2;
    logic [7:0] byte3;
    logic [7:0] byte4;
    logic [31:0] mem_array [2**17 - 1  : 0]; 
    logic cV;
    logic [31:0] word_aligned_address;
    logic [1:0] byte_offset;
    /* verilator lint_on UNUSED */
    
    initial begin
        $readmemh("sine.hex", mem_array, 20'h10000);
    end

    always_comb begin
        iTag =iAddress[31:6];
        iIndex = iAddress[5:2];
        cTag = tag_cache_array[iIndex];
        cV = valid_cache_array[iIndex];
        cData = data_cache_array[iIndex];
        word_aligned_address = {{iAddress[31:2]}, {2'b00}};
        byte_offset          = iAddress[1:0];     
    end

    always_comb begin
        if(iWriteEn==0&&(cTag==iTag)&&cV==1)begin //Hit
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
                end
                default    : begin 
                    oMemData = {byte4, byte3, byte2, byte1};
                end
            endcase
        end
        else if (iWriteEn==0) begin//Miss
            byte4 =   mem_array[word_aligned_address + 32'd3 ][7:0];
            byte3 =   mem_array[word_aligned_address + 32'd2][7:0];
            byte2 =   mem_array[word_aligned_address + 32'd1][7:0];
            byte1 =   mem_array[word_aligned_address][7:0];
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
                end
                default    : begin 
                    oMemData = {byte4, byte3, byte2, byte1};
                end
            endcase
            tag_cache_array[iIndex]=iTag;
            valid_cache_array[iIndex]=1;
            data_cache_array[iIndex]={byte4, byte3, byte2, byte1};
        end
        else begin //Write
            case (iMemoryInstructionType)
                STORE_BYTE : begin
                    case (byte_offset) 
                        2'b00 : byte1 = iMemData[7:0];
                        2'b01 : byte2 = iMemData[7:0];
                        2'b10 : byte3 = iMemData[7:0];
                        2'b11 : byte4 = iMemData[7:0];
                    endcase
                end
                
                
                STORE_HALF : begin
                    case (byte_offset) 
                        2'b00 : begin 
                            byte1 = iMemData[7:0];
                            byte2 = iMemData[15:8];
                        end

                        2'b01 : begin
                            byte2 = iMemData[7:0];
                            byte3 = iMemData[15:8];
                        end
                        2'b10 : begin
                            byte3 = iMemData[7:0];
                            byte4 = iMemData[15:8];
                        end
                        2'b11 : begin
                            byte3 = iMemData[7:0];
                            byte4 = iMemData[15:8];
                        end
                    endcase
                end
                
                STORE_WORD : begin
                    byte4 = iMemData[31:24];
                    byte3 = iMemData[23:16];
                    byte2 = iMemData[15:8];
                    byte1 = iMemData[7:0];
                end

                default    : begin
                    byte4 = iMemData[31:24];
                    byte3 = iMemData[23:16];
                    byte2 = iMemData[15:8];
                    byte1 = iMemData[7:0];
                end
            endcase
        end
    end

    always_ff @(posedge iClk) begin
        if (iWriteEn) begin
            mem_array[word_aligned_address + 32'd3][7:0] <= byte4;
            mem_array[word_aligned_address + 32'd2][7:0] <= byte3;
            mem_array[word_aligned_address + 32'd1][7:0] <= byte2;
            mem_array[word_aligned_address][7:0]         <= byte1;
            valid_cache_array[iIndex]<=0;
        end
        else             ooMemData                        <= oMemData;
    end

endmodule

