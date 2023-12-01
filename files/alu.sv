module alu #(
    parameter  OP_WIDTH = 4,
               DATA_WIDTH =32
)(
    input logic [OP_WIDTH-1:0] ALUControl /*verilator public*/,
    input logic [DATA_WIDTH-1:0]      SrcA /*verilator public*/,
    input logic [DATA_WIDTH-1:0]      SrcB /*verilator public*/,
    output logic [DATA_WIDTH-1:0]     ALUResult /*verilator public*/,
    output logic                      Zero 
);
    logic [DATA_WIDTH-1:0] out;
    always_comb begin
        ALUResult = {DATA_WIDTH{1'b0}};
        case (ALUControl)
            4'b0000: out = SrcA+SrcB; //Addition
            4'b0001: out = SrcA-SrcB; //Subtraction
            4'b0010: out = SrcA<<SrcB; //Left shift
            4'b0011: out = ($signed(SrcA) > $signed(SrcB)) ? 0 : 1; //Set less then
            4'b0100: out = ($unsigned(SrcA) > $unsigned(SrcB)) ? 0 : 1; //Unsigned set less than
            4'b0101: out = SrcA ^ SrcB; //XOR
            4'b0110: out = SrcA>>SrcB; //Right shift logical
            4'b0111: out = SrcA>>>SrcB; //Right shift arithmetic
            4'b1000: out = SrcA | SrcA; //OR
            4'b1001: out = SrcA & SrcB; //AND
            default: out = 32'd5;
        endcase
        if(out==32'b0) begin
            Zero =1'b1;
            ALUResult = 32'b0;
        end
        else begin
            ALUResult = out;
        end
    end
endmodule
