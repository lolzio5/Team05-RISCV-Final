
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
            OP_WIDTH'b0010: out = sum;
            OP_WIDTH'b0011: out = sum;
            OP_WIDTH'b0100: out = sum;
            OP_WIDTH'b0101: out = sum;
            OP_WIDTH'b0110: out = sum;
            OP_WIDTH'b0111: out = sum;
            OP_WIDTH'b1000: out = SrcA | SrcA; //Or
            OP_WIDTH'b1001: out = SrcA & SrcB; //And
        endcase
        if(out==DATA_WIDTH'b0)
            ALUResult, Zero <=1'b1;
        else
            ALUResult <=out;
    end
endmodule
