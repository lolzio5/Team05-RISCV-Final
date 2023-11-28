module EightDeMux(
    input  logic       data_in,   // Single input
    input  logic [2:0] select,    // 3-bit select signal
    output logic [7:0] data_out   // 8-bit output, each bit representing one of the outputs
);

    always @(*) begin
        // Initialize all outputs to 0
        data_out = 8'b0;

        // Based on the select value, set the corresponding output to data_in
        case (select)
            3'b000: data_out[0] = data_in;
            3'b001: data_out[1] = data_in;
            3'b010: data_out[2] = data_in;
            3'b011: data_out[3] = data_in;
            3'b100: data_out[4] = data_in;
            3'b101: data_out[5] = data_in;
            3'b110: data_out[6] = data_in;
            3'b111: data_out[7] = data_in;
        endcase
    end
endmodule
