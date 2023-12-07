`include "include/ControlTypeDefs.svh"
module top(
    input  logic         iClk,         // Clock input
    input  logic         iRst,         // Reset Signal

    output logic [31:0]  oRega0        // Output Register a0
);

////////////////////////////////
////      PC Register       ////
////////////////////////////////


    logic [31:0] pc_f; //pc from fetch stage
    logic [31:0] target_pc;
    logic [31:0] instruction_f; //instruction out of fetch
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

    //if we have a branch instruciton that branches backward then take the branch(static branch prediction)
    BranchPredictorF BranchPredictorF(
        .iInstructionF(instruction_f),
        .oTakeBranch(pc_src_f),
        .oBranchTarget(branch_target),
    );


//--------DECODE PIPELINE REGISTER---------------------
    
    InstructionTypes    instruction_type_d;
    InstructionSubTypes instruction_sub_type_d;
    logic [31:0] instruction_d
    logic [31:0] reg_data_out1_d;
    logic [31:0] reg_data_out2_d;
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
    logic [31:0] alu_result_m;
    logic [31:0] reg_data_out1_m;
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
        mem_data_in = reg_data_out2_m;
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
