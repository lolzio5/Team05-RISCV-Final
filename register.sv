module register #(
    parameter  ADDRESS_WIDTH = 5,
               DATA_WIDTH = 32
)(
    input logic clk,
    input logic WE3, //Write Enable
    input logic [ADDRESS_WIDTH-1:0] AD1, //Operand 1 register select (register read)
    input logic [ADDRESS_WIDTH-1:0] AD2, //Operand 2 register select (register read)
    input logic [ADDRESS_WIDTH-1:0] AD3, //Writeback register select (register write)
    input logic [DATA_WIDTH-1:0] WD3,   // Value to be written to register [AD3] if WE3
    output logic [DATA_WIDTH-1:0] RD1,  // Driven with value in register [AD1]
    output logic [DATA_WIDTH-1:0] RD2,  // Driven with value in register [AD2]
    output logic [DATA_WIDTH-1:0] a0 // what is this??
);

logic [DATA_WIDTH-1:0] ram_array [0:2**ADDRESS_WIDTH-1];

always_ff @( posedge clk ) begin
    if(WE3==1'b1)
        ram_array[AD3] <= WD3;
        
    RD1<=ram_array[AD1]
    RD2<=ram_array[AD2]
end

endmodule