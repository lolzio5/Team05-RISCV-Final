`include "include/ControlTypeDefs.svh"
module DataMemory #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32
)(
    input  logic                     iClk,             // clock
    input  logic                     iWriteEn,        // write enable
    input  InstructionTypes          iInstructionType,
    input  InstructionSubTypes       iMemoryInstructionType,
    input  logic [31:0]              iAddress,        // Write Address
    input  logic [DATA_WIDTH-1:0]    iMemData,        // Write Data

    output logic [DATA_WIDTH-1:0]    oMemData         // output
);

//////////////////////////////////////////////
////  Internal Memory, Data and Addresses  ////
//////////////////////////////////////////////

    //RAM Array
    logic [31:0] mem_array [2**ADDRESS_WIDTH - 1 : 0]; 

    //Memory Cell - Data stored in memory location we want to access
    logic [31:0] mem_cell; 

    //Holds the data out of memory cell 
    logic [31:0] mem_data;

    //Word address and byte offset within the address
    logic [31:0] word_aligned_address;
    logic [1:0]  byte_offset;


////////////////////////////////////////
////     Read/Write Data Flip Flop  ////
////////////////////////////////////////

    //Write or Read data on falling edge of clk
    always_ff @(negedge iClk) begin
        if (iWriteEn) mem_array[word_aligned_address] <= mem_cell;
        else          oMemData                        <= mem_data;
    
    end


//////////////////////////////////////////////
////      Internal Signal Initialisation  ///
/////////////////////////////////////////////

    always_comb begin
        word_aligned_address = {{iAddress[31:2]}, {2'b00}};     //Word aligned address -> multiple of 4
        byte_offset          = iAddress[1:0];                   //2 LSBs of iAddress define byte offset within the word
        mem_cell             = mem_array[word_aligned_address]; //Init accessed memory cell with data at the word aligned address
    end


endmodule
