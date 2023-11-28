module ROM #(

  parameter ADDR_WIDTH = 32,
            DATA_WIDTH = 32 

)(
  input  logic [ADDR_WIDTH-1:0] iPC,
  output logic [DATA_WIDTH-1:0] oInstruction
);

logic [DATA_WIDTH-1:0] rom_array [2**ADDR_WIDTH-1:0];

initial begin
        $display("Loading ROM");
        $readmemh("Instructions.mem", rom_array);
end;

always_comb

  oInstruction = rom_array[PC];

endmodule
