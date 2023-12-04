module alu #(
    parameter  OP_WIDTH = 4,
               DATA_WIDTH =32
)(
    input logic [OP_WIDTH-1:0] iALUControl /*verilator public*/,
    input logic [DATA_WIDTH-1:0]      iSrcA /*verilator public*/,
    input logic [DATA_WIDTH-1:0]      iSrcB /*verilator public*/,
    output logic [DATA_WIDTH-1:0]     oALUResult /*verilator public*/,
    output logic                      oZero 
);
    logic [DATA_WIDTH-1:0] out;
    always_comb begin
        oALUResult = {DATA_WIDTH{1'b0}};
        case (iALUControl)
            4'b0000: out = iSrcA+iSrcB; //Addition
            4'b0001: out = iSrcA-iSrcB; //Subtraction
            4'b0010: out = iSrcA<<iSrcB; //Left shift
            4'b0011: out = ($signed(iSrcA) > $signed(iSrcB)) ? 0 : 1; //Set less then
            4'b0100: out = ($unsigned(iSrcA) > $unsigned(iSrcB)) ? 0 : 1; //Unsigned set less than
            4'b0101: out = iSrcA ^ iSrcB; //XOR
            4'b0110: out = iSrcA>>iSrcB; //Right shift logical
            4'b0111: out = iSrcA>>>iSrcB; //Right shift arithmetic
            4'b1000: out = iSrcA | iSrcA; //OR
            4'b1001: out = iSrcA & iSrcB; //AND
            default: out = 32'd5;
        endcase
        if(out==32'b0) begin
            oZero =1'b1;
            oALUResult = 32'b0;
        end
        else begin
            oALUResult = out;
        end
    end
endmodule
