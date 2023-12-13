module RegisterFileD #(
    parameter  ADDRESS_WIDTH = 5,
               DATA_WIDTH = 32
)(
    input  logic                     iClk,
    input  logic                     iWriteEn,
    input  logic [ADDRESS_WIDTH-1:0] iReadAddress1,
    input  logic [ADDRESS_WIDTH-1:0] iReadAddress2,
    input  logic [ADDRESS_WIDTH-1:0] iWriteAddress,
    input  logic [DATA_WIDTH-1:0]    iDataIn,  
    
    output logic [DATA_WIDTH-1:0]    oRegData1,
    output logic [DATA_WIDTH-1:0]    oRegData2,
    output logic [DATA_WIDTH-1:0]    oRega0
);

//////////////////////////////////////////////
////        Register File 32x32           ////
//////////////////////////////////////////////

    logic [DATA_WIDTH-1:0] ram_array [0:2**ADDRESS_WIDTH-1];
    logic [31:0] data_out1;
    logic [31:0] data_out2;

//////////////////////////////////////////////
////     Synchronous Read Operation      ////
//////////////////////////////////////////////

    always_comb begin
        ram_array[0] = {32{1'b0}}; // Wire register 0 to constant 0 

        data_out1 = ram_array[iReadAddress1];
        
        data_out2 = ram_array[iReadAddress2];

        if (iWriteAddress == iReadAddress1 & iWriteAddress != 5'b0 & iWriteEn) data_out1 = iDataIn;
        else if (iWriteAddress == iReadAddress2 & iWriteAddress != 5'b0 & iWriteEn) data_out2 = iDataIn;
    end

    always_ff@ (posedge iClk, posedge iWriteEn) begin
        if(iWriteEn & iWriteAddress != 5'b0) ram_array[iWriteAddress] <= iDataIn;
    end

    always_ff @ (negedge iClk) begin 
        oRega0 <= ram_array[5'd10];
        oRegData1 <= data_out1;
        oRegData2 <= data_out2;
    end



    //Read on negative edge to allow data in writeback stage to be written
   /* always_ff @ (negedge iClk) begin
        if (iReadAddress1 != 5'b0 ) oRegData1 <= ram_array[iReadAddress1];
        else                         oRegData1 <= 32'b0;

        if (iReadAddress2 != 5'b0)  oRegData2 <= ram_array[iReadAddress2];
        else                         oRegData2 <= 32'b0;

        oRega0    <= ram_array[5'd10];      // Output Register a0
    end*/


//////////////////////////////////////////////
////     Synchronous Write Operation      ////
//////////////////////////////////////////////

    //Write to register on positive edge of clk - needec for pipeline architecture when data dependancies occur
    /*always_latch begin
        if(iWriteEn & iWriteAddress != 5'b0) ram_array[iWriteAddress] = iDataIn;
    end*/



endmodule
