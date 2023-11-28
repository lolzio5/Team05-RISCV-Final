module FourDeMux(
    input logic       data_in,   // Single input
    input logic [1:0] select,    // 2-bit select signal
    output logic [3:0] data_out   // 4-bit output, each bit representing one of the outputs
);

    always @(*) begin
        // Initialize all outputs to 0
        data_out = 4'b0;

        // Based on the select value, set the corresponding output to data_in
        case (select)
            2'b00: data_out[0] = data_in;
            2'b01: data_out[1] = data_in;
            2'b10: data_out[2] = data_in;
            2'b11: data_out[3] = data_in;
        endcase
    end
endmodule
