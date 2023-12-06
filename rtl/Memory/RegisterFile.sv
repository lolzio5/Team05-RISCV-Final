module RegisterFile #(
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


//////////////////////////////////////////////
////     Asynchronous Read Operation      ////
//////////////////////////////////////////////

    //Read Register Operation -> Async
    always_comb begin 
        ram_array[0] = {DATA_WIDTH{1'b0}}; // Wire register 0 to constant 0

        oRegData1 = ram_array[iReadAddress1];
        oRegData2 = ram_array[iReadAddress2];

        oRega0    = ram_array[5'd10];      // Output Register a0
    end


//////////////////////////////////////////////
////     Synchronous Write Operation      ////
//////////////////////////////////////////////

    //Write to register on falling edge of clk
    always_ff @ (negedge iClk) begin
        if(iWriteEn == 1'b1) ram_array[iWriteAddress] <= iDataIn;
    end


endmodule
