module TwoDeMux(
    input logic      data_in,   // Single input
    input logic      select,    // 1-bit select signal
    output logic [1:0] data_out  // 2-bit output, each bit representing one of the outputs
);

    always @(*) begin
        // Initialize all outputs to 0
        data_out = 2'b0;

        // Based on the select value, set the corresponding output to data_in
        case (select)
            1'b0: data_out[0] = data_in;
            1'b1: data_out[1] = data_in;
        endcase
    end
endmodule
