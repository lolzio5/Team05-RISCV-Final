module InstructionMemory #(

  parameter ADDR_WIDTH = 32,
            DATA_WIDTH = 32 

)(
  input  logic [31:0] iPC,
  output logic [DATA_WIDTH-1:0] oInstruction
);

  logic [DATA_WIDTH-1:0] rom_array [2**ADDR_WIDTH-1:0];

  initial begin
          $display("Loading ROM");
          $readmemb("InstructionsBin.mem", rom_array);
  end;

  always_comb begin
    oInstruction = rom_array[iPC];
  end

endmodule
