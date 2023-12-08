`include "include/ControlTypeDefs.svh"
module top(
    input  logic         iClk,         // Clock input
    input  logic         iRst,         // Reset Signal

    output logic [31:0]  oRega0        // Output Register a0
);

//--------FETCH PIPELINE REGISTER---------------------

    logic           stall_d;    
    logic   [31:0]  instruction_f;
    logic   [31:0]  pc_plus_4_f;

    FPipelineRegister FPipelineRegister(
        .iCLk(iClk),
        .iStallD(stall_d),
        .iRDF(instruction_f),
        .iPCPlus4F(pc_plus_4_f),
        .oInstrD(instr_d),
        .oPCPlus4D(pc_plus_4_d)
    );

////////////////////////////////
////      PC Register       ////
////////////////////////////////

    logic [31:0] pc_f; //pc from fetch stage
    logic [31:0] target_pc;
    logic [31:0] branch_target;
    logic        pc_src;
    logic        pc_src_f;

    PCRegisterF PCRegister(
        .iClk(iClk),
        .iRst(iRst),
        .iPCSrcD(pc_src),
        .iPCSrcF(pc_src_f),
        .iTargetPC(target_pc),
        .iBranchTarget(branch_target),
        .oPC(pc_f)
    );

    InstructionMemoryF InstructionROM(
        .iPC(pc_f),
        .oInstruction(instruction_f)
    );

    //if we have a branch instruction that branches backward then take the branch(static branch prediction)
    BranchPredictorF BranchPredictorF(
        .iInstructionF(instruction_f),
        .oTakeBranch(pc_src_f),
        .oBranchTarget(branch_target)
    );

//--------DECODE PIPELINE REGISTER---------------------
    
    logic [31:0] reg_data_out1_d;
    logic [31:0] reg_data_out2_d;
    logic [31:0] sign_imm_d;  

    logic [4:0]  rs_d;
    logic [4:0]  rt_d;
    logic [4:0]  rd_d;

    logic [1:0]  result_src_d;    
    logic [2:0]  alu_control_d;
    logic        alu_src_d;
    logic        reg_dst_d;
    logic        mem_to_reg_d;
    logic        mem_write_d;
    logic        reg_write_d;
    logic        zero_d;

    DPipelineRegister DPipelineRegister(
        .iCLk(iClk),
        .iFlushE(flush_e),
        .iRegWriteD(reg_write_d),
        .iMemToRegD(mem_to_reg_d),
        .iMemWriteD(mem_write_d),
        .iALUControlD(alu_control_d),
        .iALUSrcD(alu_src_d),
        .iRegDstD(reg_dst_d),
        .iRD1D(reg_data_out1_d),
        .iRD2D(reg_data_out2_d),
        .iRsD(rs_d),
        .iRtD(rt_d),
        .iRdD(rd_d),
        .iSignImmD(sign_imm_d),
        .oRegWriteE(reg_write_e),
        .oMemToRegE(mem_to_reg_e),
        .oMemWriteE(mem_write_e),
        .oALUControlE(alu_control_e),
        .oALUSrcE(alu_src_e),
        .oRegDstE(reg_dst_e),
        .oRD1E(reg_data_out1_e),
        .oRD2E(reg_data_out2_e),
        .oRsE(rs_e),
        .oRtE(rt_e),
        .oRdE(rd_e),
        .oSignImmE(sign_imm_e)
    );


//////////////////////////////////////////////////////////
//// Control Unit : Control Path + Instruction Memory ////
//////////////////////////////////////////////////////////
    
    InstructionTypes    instruction_type_d;
    InstructionSubTypes instruction_sub_type_d;

    ControlPathD ControlPath(
        .iInstruction(instruction_d),
        .iZero(zero_d), 
        .oImmExt(imm_ext_d),
        .oRegWrite(reg_write_d),
        .oMemWrite(mem_write_d),
        .oAluControl(alu_control_d),
        .oAluSrc(alu_src_d),
        .oResultSrc(result_src_d),
        .oPCSrc(pc_src),
        .oRs1(rs1_d),
        .oRs2(rs2_d),
        .oRd(rd_d),
        .oInstructionType(instruction_type_d),
        .oInstructionSubType(instruction_sub_type_d)
    );


///////////////////////////////////////////
////  PC Adder : Target PC Calculator  ////
///////////////////////////////////////////


    PCAdder TargetPCAdder(
        .iPC(pc),
        .iImmExt(imm_ext_d),
        .iInstructionType(instruction_type_d),
        .iInstructionSubType(instruction_sub_type_d),
        .iRegOffset(alu_op1),
        .oPCTarget(target_pc)
    );


/////////////////////////////////
////      Register File      ////
/////////////////////////////////


    RegisterFile RegisterFile(
        .iClk(iClk),
        .iWriteEn(reg_write_en_w),
        .iReadAddress1(rs1_d),
        .iReadAddress2(rs2_d),
        .iWriteAddress(rd_d),
        .iDataIn(reg_data_in),
        .oRegData1(reg_data_out1_d),
        .oRegData2(reg_data_out2_d),
        .oRega0(oRega0)
    );

    HazardUnit HazardControl(
        .iInstructionTypeE(instruction_type_e),
        .iDestRegE(rd_e),
        .iDestRegM(rd_m),
        .iDestRegW(rd_w),
        .iRegWriteEnM(reg_write_en_m),
        .iRegWriteEnW(reg_write_en_w),
        .iSrcReg1D(rs1_d),
        .iSrcReg2D(rs2_d),
        .iSrcReg1E(rs1_e),
        .iSrcReg2E(rs2_e),
        .oForwardAluOp1E(alu_op1_select),
        .oForwardAluOp2E(alu_op2_select),
        .oForwardCompOp1D(),
        .oForwardCompOp2D(),
        .oStallF(),
        .oStallE(),
        .oFlushE()
    );

//--------EXECUTION STAGE PIPELINE REGISTER---------------------

    InstructionTypes    instruction_type_e;
    InstructionSubTypes instruction_sub_type_e;

    logic [31:0] write_data_e;
    logic [31:0] reg_data_out1_e;
    logic [31:0] reg_data_out2_e;
    logic [31:0] sign_imm_e;  

    logic [2:0]  alu_control_e;
    logic [31:0] alu_out_e;
    logic        mem_write_e;
    logic        reg_write_e;
    logic        mem_to_reg_e;
    logic [4:0]  write_reg_e;

    EPipelineRegister EPipelineRegister(
        .iCLk(iClk),
        .iRegWriteE(reg_write_e),
        .iMemToRegE(mem_to_reg_e),
        .iMemWriteE(mem_write_e),
        .iALUOutE(alu_out_e),
        .iWriteDataE(write_data_e),
        .iWriteRegE(write_reg_e),
        .oRegWriteM(reg_write_m),
        .oMemToRegM(mem_to_reg_m),
        .oMemWriteM(mem_write_m),
        .oALUOutM(alu_out_m),
        .oWriteDataM(write_data_m),
        .oWriteRegM(write_reg_m)
    );


/////////////////////////////////
////  Arithmetic Logic Unit  ////
/////////////////////////////////


    //Alu Operands      -     Otput From Register File and Control Unit (Immediate Operand)
    logic [31:0] alu_op1_e;
    logic [31:0] alu_op2_e;

    //Control Signals   -     Output From Control Unit

    logic [1:0] alu_op1_select;
    logic [1:0] alu_op2_select;

    AluOpForwarderE AluOpForwarder(
        .iForwardAluOp1(alu_op1_select),
        .iForwardAluOp2(alu_op2_select),
        .iResultDataW(result_out_w),
        .iAluResultOutM(alu_result_m),
        .iRegData1E(reg_data_out1_e),
        .iRegData2E(reg_data_out2_e),
        .oAluOp1(alu_op1_e),
        .oAluOp2(alu_op2_e)
    );

    always_comb begin
        alu_op2_e = alu_src_e ? imm_ext_e : alu_op2_e ; //Pick between immediate or register operand
    end
    
    Alu Alu(
        .iAluControl(alu_control_e),
        .iAluOp1(alu_op1_e),
        .iAluOp2(alu_op2_e),
        .oAluResult(alu_result_e),
        .oZero(zero_e)
    );    

//--------MEMORY STAGE PIPELINE REGISTER---------------------

    InstructionTypes    instruction_type_m;
    InstructionSubTypes instruction_sub_type_m;
    logic [31:0] alu_out_m;
    logic [31:0] reg_data_out1_m;
    logic [31:0] reg_data_out2_m;
    logic [31:0] sign_imm_m;  

    logic        reg_write_m;
    logic        mem_to_reg_m;
    logic        alu_src_m;
    logic [31:0] alu_out_m;
    logic [31:0] read_data_m;
    logic        mem_write_en_m;
    logic        reg_write_en_m;
    logic [4:0]  write_reg_m;
    

    logic        reg_write_w;
    logic        mem_to_reg_w;
    logic [31:0] alu_out_w;
    logic [31:0] read_data_w;
    logic [4:0]  write_reg_w;


     MPipelineRegister MPipelineRegister(
        .iCLk(iClk),
        .iRegWriteM(reg_write_m),
        .iMemToRegM(mem_to_reg_m),
        .iReadDataM(read_data_m),
        .iALUOutM(alu_out_m),
        .iWriteRegM(write_reg_m),
        .oRegWriteW(reg_write_w),
        .oMemToRegW(mem_to_reg_w),
        .oALUROutW(alu_out_w),
        .oReadDataW(read_data_w),
        .oWriteRegW(write_reg_w)
    );


/////////////////////////////////
////      Data Memory        ////
/////////////////////////////////

    //Control Signals     -   Output From Control Unit
    logic        mem_write_en;


    // Data that is to be written to data memory is the value stored in the second source register
    always_comb begin
        mem_data_in = reg_data_out2_m;
    end

    DataMemory DataMemory(
        .iClk(iClk),
        .iWriteEn(mem_write_m),
        .iInstructionType(instruction_type_m),
        .iMemoryInstructionType(instruction_sub_type_m), 
        .iAddress(alu_out_m),
        .iMemData(write_data_m),
        .oMemData(read_data_m)
    );

//////////////////////////////////////////////////////////////////////////////////////
////  Write Back Result Selector : Choses What Is Written Back To Register File  /////
//////////////////////////////////////////////////////////////////////////////////////

    logic [31:0] result_out_w;

    ResultMux ResultSelector(
        .iMemToRegW(mem_to_reg_w),
        .iALUOutW(alu_out_w),
        .iReadDataW(read_data_w),
        .oResultW(result_out_w)
    );  

endmodule
