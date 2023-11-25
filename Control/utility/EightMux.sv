module EightMux #(
  parameter width = 12
)(
    input logic [width:1] d0,  
    input logic [width:1] d1,
    input logic [width:1] d2,
    input logic [width:1] d3,
    input logic [width:1] d4,
    input logic [width:1] d5,
    input logic [width:1] d6,
    input logic [width:1] d7,

    input  logic [3:1]         select,   // 3-bit select signal
    output logic [width:1]     data_out  // Single output
);

    // Select the appropriate input based on the select signal
    always @(*) begin
        case (select)
            3'b000: data_out = d0;
            3'b001: data_out = d1;
            3'b010: data_out = d2;
            3'b011: data_out = d3;
            3'b100: data_out = d4;
            3'b101: data_out = d5;
            3'b110: data_out = d6;
            3'b111: data_out = d7;
        endcase
    end

endmodule
