
module alu #(
    parameter  OP_WIDTH = 4,
               DATA_WIDTH =32
)(
    input logic [OPERATION_WIDTH-1:0] ALUControl,
    input logic [DATA_WIDTH-1:0]      SrcA,
    input logic [DATA_WIDTH-1:0]      SrcB,
    output logic [DATA_WIDTH-1:0]     ALUResult,
    output logic                      Zero
);
    logic out [DATA_WIDTH-1:0];
    always_comb begin
        localparam int ALUOP_NOP = OPERATION_WIDTH'd0;
        case (ALUControl)
            OP_WIDTH'b0000: out = SrcA+SrcB; //Addition
            OP_WIDTH'b0001: out = SrcA-SrcB; //Subtraction
            OP_WIDTH'b0010: out = SrcA<<SrcB; //Left shift
            OP_WIDTH'b0011: out = 1'b1; //Set less then
            OP_WIDTH'b0100: out = 1'b1; //Unsigned set less than
            OP_WIDTH'b0101: out = SrcA ^ SrcB; //XOR
            OP_WIDTH'b0110: out = SrcA>>SrcB; //Right shift logical
            OP_WIDTH'b0111: out = SrcA>>>SrcB; //Right shift arithmetic
            OP_WIDTH'b1000: out = SrcA | SrcA; //OR
            OP_WIDTH'b1001: out = SrcA & SrcB; //AND
        endcase
        if(out==DATA_WIDTH'b0) begin
            Zero <=1'b1;
            ALUResult <= 1'b0;
        end
        else begin
            ALUResult <=out;
        end
    end
endmodule
