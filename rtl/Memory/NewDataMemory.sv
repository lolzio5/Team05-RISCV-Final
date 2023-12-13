`include "include/ControlTypeDefs.svh"
module DataMemoryM #(
    parameter DATA_WIDTH = 32
 )(
    input  logic                     iClk,             // clock
    input  logic                     iWriteEn,        // write enable
    input  logic [31:0]              word_aligned_address,        // Write Address
    input  logic [DATA_WIDTH-1:0]    iMemData,        // Write Data
    input  logic [7:0] byte1,
    input  logic [7:0] byte2,
    input  logic [7:0] byte3,
    input  logic [7:0] byte4,
    output logic [DATA_WIDTH-1:0]    oMemData         // output
);



//////////////////////////////////////////////
////  Internal Memory, Data and Addresses  ///
//////////////////////////////////////////////

    //RAM Array : Accomodate for Address starting at : 0x10000 to 0x1FFFF
    logic [31:0] mem_array [2**17 - 1  : 0]; 


    //Holds the data out of memory cell 
    logic [31:0] mem_data;

    //Memory Bytes - Data stored in memory location we want to access


    initial begin
        $readmemh("sine.hex", mem_array, 20'h10000);
        
    end

////////////////////////////////////////
////     Read/Write Data Flip Flop  ////
////////////////////////////////////////

    //Write or Read data on rising edge of clk
    always_ff @(negedge iClk) begin

        if (iWriteEn) begin
            mem_array[word_aligned_address + 32'd3][7:0] <= byte4;
            mem_array[word_aligned_address + 32'd2][7:0] <= byte3;
            mem_array[word_aligned_address + 32'd1][7:0] <= byte2;
            mem_array[word_aligned_address][7:0]         <= byte1;
        end

        else             oMemData                        <= mem_data;
    
    end


//////////////////////////////////////////////
////      Internal Signal Initialisation  ///
/////////////////////////////////////////////



