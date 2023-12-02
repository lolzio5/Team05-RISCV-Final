`include "include/ControlTypeDefs.svh"

module DataMemory #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32
)(
    input  logic                     iClk,             // clock
    input  logic                     iWriteEn,        // write enable
    input  InstructionSubTypes       iMemoryInstructionType,
    input  logic [31:0]              iAddress,        // Write Address
    input  logic [DATA_WIDTH-1:0]    iMemData,        // Write Data
    output logic [DATA_WIDTH-1:0]    oMemData         // output
);

    logic [31:0] mem_array [2**ADDRESS_WIDTH - 1 : 0];
    logic [31:0] mem_cell;

    logic [31:0] mem_data;
    logic [31:0] word_aligned_address;
    logic [1:0]  byte_offset;


    always_comb begin
        word_aligned_address = {{iAddress[31:2]}, {2'b00}};
        byte_offset          = iAddress[1:0];
        mem_cell             = mem_array[word_aligned_address];
    end


    always_ff @(posedge iClk) begin
        if (iWriteEn) mem_array[word_aligned_address] <= mem_cell;
        else          oMemData                        <= mem_data;
    
    end


    always_comb begin

    //Write Operation
        if (iWriteEn == 1'b1) begin
            case (iMemoryInstructionType)
                STORE_BYTE : mem_cell[byte_offset*8 +: 8]  = iMemData[7:0];   // Byte
                STORE_HALF : mem_cell[byte_offset*8 +: 16] = iMemData[15:0];  // Half-word
                STORE_WORD : mem_cell                      = iMemData;        // Word

                default    : mem_cell                      = iMemData;        // Word
            endcase
        end

    //Read Operation
        else begin
            case(iMemoryInstructionType)
                LOAD_BYTE  : begin
                    mem_data[7:0]  = mem_cell[byte_offset*8 +: 8]; 
                    mem_data[31:8] = {24{mem_data[7]}}; //sign extend
                end

                LOAD_HALF  : begin
                    mem_data[15:0]  = mem_cell[byte_offset*8 +: 16];  
                    mem_data[31:16] = {16{mem_data[15]}}; //sign extend
                end

                ULOAD_BYTE : mem_data = {{24{1'b0}}, mem_cell[byte_offset*8 +: 8]}; //Zero extend
                ULOAD_HALF : mem_data = {{16{1'b0}}, mem_cell[byte_offset*8 +: 16]};//Zero extend
                LOAD_WORD  : mem_data = mem_cell;               

                default    : mem_data = mem_cell; 
            endcase
        end
    end
endmodule
