module alu #(
    parameter  OPERATION_WIDTH = 6,
               DATA_WIDTH =32
)(
    input logic [OPERATION_WIDTH-1:0] ALUctrl,
    input logic [DATA_WIDTH-1:0]      ALUop1,
    input logic [DATA_WIDTH-1:0]      ALUop2,
    output logic [DATA_WIDTH-1:0]     ALUout,
    output logic                      EQ
);
    localparam int ALUOP_NOP = OPERATION_WIDTH'd0;
    localparam int ALUOP_ADD = OPERATION_WIDTH'd1;
    localparam int ALUOP_ISNE = OPERATION_WIDTH'd2;

    logic [DATA_WIDTH-1:0] sum;
    logic [DATA_WIDTH-1:0] is_eq;
    assign sum = ALUop1 + ALUop2;
    assign is_eq = ALUop1 == ALUop2;
    
    always_comb begin
        
        case (ALUctrl)
            ALUOP_NOP: ALUout <= DATA_WIDTH'b0;
            ALUOP_ADD: ALUout <= sum;
            ALUOP_ISNE: ALUout <= DATA_WIDTH{ALUop1 != ALUop2};
        endcase
        
    end
endmodule
