module InstructionMemory #(

  parameter DATA_WIDTH = 32

)(
   /* verilator lint_off UNUSED */
  input  logic [31:0] iPC,
   /* verilator lint_on UNUSED */
  output logic [DATA_WIDTH-1:0] oInstruction
);

  logic [DATA_WIDTH - 1 : 0] rom_array [0 : 2**12  - 1];

  initial begin
          $display("Loading ROM");
          //$readmemb("InstructionsBin.mem", rom_array, 32'hBFC00000, 32'hBFC00FFF);
          $readmemh("F1.hex", rom_array);
  end;

  always_comb begin

    oInstruction = {rom_array[iPC + 32'd3][7:0], rom_array[iPC + 32'd2][7:0], rom_array[iPC + 32'd1][7:0], rom_array[iPC][7:0] };
  end

endmodule
