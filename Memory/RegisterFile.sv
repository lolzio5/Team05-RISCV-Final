module RegisterFile #(
    parameter  ADDRESS_WIDTH = 5,
               DATA_WIDTH = 32
)(
    input  logic iClk,
    input  logic iWriteEn,
    input  logic [ADDRESS_WIDTH-1:0] iReadAddress1,
    input  logic [ADDRESS_WIDTH-1:0] iReadAddress2,
    input  logic [ADDRESS_WIDTH-1:0] iWriteAddress,
    input  logic [DATA_WIDTH-1:0]    iDataIn,  

    output logic [DATA_WIDTH-1:0]    oRegData1,
    output logic [DATA_WIDTH-1:0]    oRegData2 
);

    logic [DATA_WIDTH-1:0] ram_array [0:2**ADDRESS_WIDTH-1];

    always_comb begin //read register is async
        ram_array[0] = {DATA_WIDTH{1'b0}};
        oRegData1 = ram_array[iReadAddress1];
        oRegData2 = ram_array[iReadAddress2];
    end

    always_ff @ (posedge iClk) begin

        if(iWriteEn == 1'b1) begin
            ram_array[iWriteAddress] <= iDataIn;
        end

    end

endmodule
