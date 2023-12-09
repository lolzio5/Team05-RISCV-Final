`include "include/ControlTypeDefs.svh"
module top(
    input  logic         iClk,         // Clock input
    input  logic         iRst,         // Reset Signal

    output logic [31:0]  oRega0        // Output Register a0
);

////////////////////////////////
////      PC Register       ////
////////////////////////////////

    FPipelineRegister FPipelineRegister(
        .iCLk(iClk),
        .iStallD(stall_d),
        .iRDF(instruction_f),
        .iPCPlus4F(pc_plus_4_f),
        .oInstrD(instr_d),
        .oPCPlus4D(pc_plus_4_d)
    );

    logic [31:0] pc_f; //pc from fetch stage
    logic [31:0] target_pc_d;
    logic [31:0] instruction_f; //instruction out of fetch
    logic [31:0] jb_target;
 
    logic        take_jb_f;
    logic        stall_f;

    PCRegisterF PCRegister(
        .iClk(iClk),
        .iRst(iRst),
        .iPCSrcD(pc_src_d),
        .iPCSrcF(take_jb_f),
        .iTargetPC(target_pc_d),
        .iBranchTarget(jb_target),
        .oPC(pc_f)
    );

    InstructionMemoryF InstructionROM(
        .iPC(pc_f),
        .oInstruction(instruction_f)
    );

    //if we have a branch instruciton that branches backward then take the branch(static branch prediction)
    JumpBranchHandlerF JumpBranchHandlerF(
        .iInstructionF(instruction_f),
        .oTakeJBF(take_jb_f),
        .oJBTarget(jb_target),
    );


//--------DECODE PIPELINE REGISTER---------------------
    
    InstructionTypes    instruction_type_d;
    InstructionSubTypes instruction_sub_type_d;
    logic [31:0] instruction_d
    logic [31:0] pc_d
    logic [31:0] reg_data_out1_d;
    logic [31:0] reg_data_out2_d;
    logic [31:0] reg_jump_offset_d;
    logic [31:0] imm_ext_d;  

    logic [4:0]  rs1_d;
    logic [4:0]  rs2_d;
    logic [4:0]  rd_d;

    logic [31:0] reg_data_in_w;

    logic [2:0]  result_src_d;    
    logic [3:0]  alu_control_d;
    logic        alu_src_d;

    logic        mem_write_en_d;
    logic        reg_write_en_d;

    logic        zero_d;
    logic        flush_d;
    logic        stall_d;

    logic        pc_src_d;
    logic        take_branch_d;
    logic        recover_pc_d;

    logic        comparator_op1_select;
    logic        comparator_op2_select;
    logic        comparator_op1_d;
    logic        comparator_op2_d;
    logic        forward_reg_offset;

    OperandForwarderD OperandForwarderD(
        .iRegData1D(reg_data_out1_d),
        .iRegData2D(reg_data_out2_d),
        .iAluResultOutM(alu_result_m),
        .iCompOp1Select(comparator_op1_select),
        .iCompOp2Select(comparator_op2_select),
        .iForwardRegOffset(forward_reg_offset),
        .oCompOp1(comparator_op1_d),
        .oCompOp2(comparator_op2_d),
        .oRegOffset(reg_jump_offset_d)
    );

    ComparatorD RegComparator(
        .iInstructionTypeD(instruction_d),
        .iBranchTypeD(instruction_sub_type_d),
        .iRegData1D(comparator_op1_d),
        .iRegData2D(comparator_op2_d),
        .iImmExtD(imm_ext_d),
        .iTakeBranchF(take_branch_d),
        .oRecoverPC(recover_pc_d),
        .oPCSrcD(pc_src_d)
    );

//////////////////////////////////////////////////////////
//// Control Unit : Control Path + Instruction Memory ////
//////////////////////////////////////////////////////////


    ControlPathD ControlPath(
        .iInstruction(instruction_d),
        .iZero(zero_d), 
        .oImmExt(imm_ext_d),
        .oRegWrite(reg_write_en),
        .oMemWrite(mem_write_en),
        .oAluControl(alu_control_d),
        .oAluSrc(alu_src_d),
        .oResultSrc(result_src_d),
        .oPCSrc(pc_src_d), //change pc_src output
        .oRs1(rs1_d),
        .oRs2(rs2_d),
        .oRd(rd_d),
        .oInstructionType(instruction_type_d),
        .oInstructionSubType(instruction_sub_type_d)
    );


///////////////////////////////////////////
////  PC Adder : Target PC Calculator  ////
///////////////////////////////////////////



    PCAdderD TargetPCAdder(
        .iPC(pc_d),
        .iImmExt(imm_ext_d),
        .iInstructionType(instruction_type_d),
        .iInstructionSubType(instruction_sub_type_d),
        .iRegOffset(reg_jump_offset_d),
        .iRecoverPCD(recover_pc_d),
        .oPCTarget(target_pc_d)
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
        .iInstructionTypeD(instruction_type_d),
        .iInstructionTypeE(instruction_type_e),
        .iInstructionTypeM(instruction_type_m),
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
        .oForwardCompOp1D(comparator_op1_select),
        .oForwardCompOp2D(comparator_op2_select),
        .oForwardRegOffsetD(forward_reg_offset),
        .oStallF(stall_f),
        .oStallD(stall_d),
        .oFlushE(flush_e)
    );

    DPipelineRegister PipelineRegisterE(
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
        .oRsE(rs1_e),
        .oRtE(rs2_e),
        .oRdE(rd_e),
        .oSignImmE(imm_ext_d)
    );

//--------EXECUTION STAGE PIPELINE REGISTER---------------------

    InstructionTypes    instruction_type_e;
    InstructionSubTypes instruction_sub_type_e;

    logic [31:0] alu_result_e;
    logic [31:0] reg_data_out1_e;
    logic [31:0] reg_data_out2_e;
    logic [31:0] imm_ext_e;  

    logic [4:0]  rs1_e;
    logic [4:0]  rs2_e;
    logic [4:0]  rd_e;

    logic [2:0]  result_src_e;
    logic [3:0]  alu_control_e;
    logic        alu_src_e;
    logic        mem_write_en_e;
    logic        reg_write_en_e;
    logic        zero_e;

    logic        flush_e;



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

    EPipelineRegister PipelineRegisterM(
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

//--------MEMORY STAGE PIPELINE REGISTER---------------------

    InstructionTypes    instruction_type_m;
    InstructionSubTypes instruction_sub_type_m;
    logic [31:0] alu_result_m;
    logic [31:0] reg_data_out1_m;
    logic [31:0] alu_op2_m;
    logic [31:0] reg_data_out2_m;
    logic [31:0] imm_ext_m;  

    logic [4:0]  rs1_m;
    logic [4:0]  rs2_m;
    logic [4:0]  rd_m;

    logic        zero_m;

    logic [2:0]  result_src_m;
    logic [3:0]  alu_control_m;
    logic        alu_src_m;
    logic        mem_write_en_m;
    logic        reg_write_en_m;


/////////////////////////////////
////      Data Memory        ////
/////////////////////////////////

    //Memory Data I/O 
    logic [31:0] mem_data_in;
    logic [31:0] mem_data_out_m;


    //Control Signals     -   Output From Control Unit
    logic        mem_write_en;


    // Data that is to be written to data memory is the value stored in the second source register
    always_comb begin
        mem_data_in = alu_op2_m;
    end

    DataMemory DataMemory(
        .iClk(iClk),
        .iWriteEn(mem_write_en),
        .iInstructionType(instruction_type_m),
        .iMemoryInstructionType(instruction_sub_type_m), 
        .iAddress(alu_result_m),
        .iMemData(mem_data_in),
        .oMemData(mem_data_out_m)
    );

//--------MEMORY STAGE PIPELINE REGISTER---------------------


    InstructionTypes    instruction_type_w;
    InstructionSubTypes instruction_sub_type_w;
    logic [31:0] mem_data_out_w;
    logic [31:0] alu_result_w;
    logic [31:0] reg_data_out1_w;
    logic [31:0] reg_data_out2_w;
    logic [31:0] imm_ext_w;  

    logic [4:0]  rs1_w;
    logic [4:0]  rs2_w;
    logic [4:0]  rd_w;

    logic [2:0]  result_src_w;
    logic [3:0]  alu_control_w;
    logic        alu_src_w;
    logic        mem_write_en_w;
    logic        reg_write_en_w;
    logic        zero_w;


//////////////////////////////////////////////////////////////////////////////////////
////  Write Back Result Selector : Choses What Is Written Back To Register File  /////
//////////////////////////////////////////////////////////////////////////////////////

    logic [31:0] result_out_w

    ResultMuxW ResultSelector(
        .iResultSrc(result_src_w),
        .iAluResult(alu_result_w),
        .iMemDataOut(mem_data_out_w),
        .iPC(pc),//
        .iUpperImm(imm_ext_w),
        .oRegDataIn(result_out_w)
    );  

endmodule
