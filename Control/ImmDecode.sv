`include "include/ControlTypeDefs.svh"

module ImmDecode(
  input  InstructionTypes    iInstructionType,
  input  InstructionSubTypes iInstructionSubType,
  /* verilator lint_off UNUSED */
  input  logic [31:0]      iInstruction,
  /* verilator lint_on UNUSED */
  output logic [31:0]      oImmExt
);

//Change on 30th nov : Made ImmDecode output the sign extended immediate 

/*Note on jumps

The unconditional jump instructions all use PC-relative addressing to help support positionindependent code.
The JALR instruction was defined to enable a two-instruction sequence to jump anywhere in a 32-bit absolute address range.
A LUI instruction can first load rs1 with the upper 20 bits of a target address, then JALR can add in the lower bits. 
Similarly, AUIPC then JALR can jump anywhere in a 32-bit pc-relative address range

*/

/*
TO DO : 
  - change the immediate for B and J type so that LSB is = 0 (according to RISCV spec)
  - The jump type instruction encodes the immediate in multiples of 2 - bytes (implement this )
  - JALR Uses the i-type encoding of the immediate : The target address 
    is found by adding this immedaite to rs1 and setting LSB of result to 0

  
*/

always_comb begin


    oImmExt = {32{1'b0}};

  case(iInstructionType)
  
    IMM_COMPUTATION : begin      
      oImmExt[31:12] = {20{oImmExt[11]}};
      oImmExt[11:0]  = iInstruction[31:20];
    end

    LOAD : begin      
      oImmExt[31:12] = {20{oImmExt[11]}};
      oImmExt[11:0]  = iInstruction[31:20];
    end

    UPPER : begin
      oImmExt[31:12] = iInstruction[31:12];
      oImmExt[11:0]  = {12{1'b0}};
    end
 
    STORE : begin      
      oImmExt[31:12] = {20{oImmExt[11]}};
      oImmExt[11:5]  = iInstruction[31:25];
      oImmExt[4:0]   = iInstruction[11:7];
    end

    JUMP : begin
      if(iInstructionSubType == JUMP_LINK_REG) begin        
        oImmExt[31:12] = {20{oImmExt[11]}};
        oImmExt[11:0]  = iInstruction[31:20];
      end

      else begin
        oImmExt[31:20]  = {12{iInstruction[31]}};
        oImmExt[19:12]  = iInstruction[19:12];
        oImmExt[11]     = iInstruction[20];
        oImmExt[10:1]   = iInstruction[30:21];
        oImmExt[0]      = 1'b0; 
      end
    end

    BRANCH : begin      
      oImmExt[31:13] = {19{oImmExt[11]}};       
      oImmExt[12:1]  = {iInstruction[31], iInstruction[7], iInstruction[30:25], iInstruction[11:8]};
      oImmExt[0]     = 1'b0; //Branch immediate encoded in multiples of 2 (lsb = 0)
    end

    default : begin
      oImmExt = {32{1'b0}}; //set imm20 to 0 by default
    end
  endcase
end

endmodule
