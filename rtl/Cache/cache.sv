module cache #(
    parameter  ADDRESS_WIDTH = 8,
               DATA_WIDTH = 32
)(
    input  logic [DATA_WIDTH-1:0]    iFill, 
    output logic [DATA_WIDTH-1:0]    oCache
);

    logic [DATA_WIDTH-1:0] ram_array [0:2**ADDRESS_WIDTH-1];

    always_comb begin
    
    end

    always_comb begin

    end

endmodule
