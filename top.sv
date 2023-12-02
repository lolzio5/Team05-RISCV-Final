`include "include/ControlTypeDefs.svh"

module top(
    input  logic         iClk,         // Clock input
    input  logic         iRst, 
    //input  logic         iTrigger, commented out until implemented
    output logic [31:0]  oDataOut // Output data
);


////////////////////////////////
////      PC Register       ////
////////////////////////////////


    logic [31:0] pc;
    logic [31:0] target_pc;
    logic        pc_src;

    PCRegister PCRegister(
        .iClk(iClk),
        .iRst(iRst),
        .iPCSrc(pc_src),
        .iTargetPC(target_pc),
        .oPC(pc)
    );


//////////////////////////////////////////////////////////
//// Control Unit : Control Path + Instruction Memory ////
//////////////////////////////////////////////////////////

    /* [ Current Instruction Type ]           
       -- Output by Control Unit -- */
    InstructionSubTypes instruction_type;


    /* [ Source and Destination Register Addesses ]           
       -- Output by Control Unit -- */
    logic [4:0]  rs1;
    logic [4:0]  rs2;
    logic [4:0]  rd;


    /* [ Immedaite Operand ]           
       -- Output by Control Unit -- */
    logic [31:0] imm_ext;


    /* [ Zero Flag ]           
       -- Output by Control Unit -- */
    logic        zero;

    ControlUnit ControlUnit(
        .iPC(pc),
        .iZero(zero), 
        .oImmExt(imm_ext),
        .oRegWrite(reg_write_en),
        .oMemWrite(mem_write_en),
        .oAluControl(alu_control),
        .oAluSrc(alu_src),
        .oResultSrc(result_src),
        .oPCSrc(pc_src),
        .oRs1(rs1),
        .oRs2(rs2),
        .oRd(rd),
        .oInstructionSubType(instruction_type)
    );


/////////////////////////////////
////      Register File      ////
/////////////////////////////////


    //Register Data Out (Read Data) -     Output From Register File
    logic [31:0] reg_data_out1;
    logic [31:0] reg_data_out2;


    //Register Data In (Write Data) -     Output From ResultMux 
    logic [31:0] reg_data_in;


    //Control Signals               -     Output From control Unit
    logic        reg_write_en;

    RegisterFile RegisterFile(
        .iClk(iClk),
        .iWriteEn(reg_write_en),
        .iReadAddress1(rs1),
        .iReadAddress2(rs2),
        .iWriteAddress(rd),
        .iDataIn(reg_data_in),
        .oRegData1(reg_data_out1),
        .oRegData2(reg_data_out2)
    );


/////////////////////////////////
////      Data Memory        ////
/////////////////////////////////

    //Memory Data I/O 
    logic [31:0] mem_data_in;
    logic [31:0] mem_data_out;


    //Control Signals     -   Output From Control Unit
    logic        mem_write_en;


    // Data that is to be written to data memory is the value stored in the second source register
    always_comb begin
        mem_data_in = reg_data_out2;
    end

    DataMemory DataMemory(
        .iClk(iClk),
        .iWriteEn(mem_write_en),
        .iMemoryInstructionType(instruction_type), 
        .iAddress(alu_result),
        .iMemData(mem_data_in),
        .oMemData(mem_data_out)
    );


/////////////////////////////////
////  Arithmetic Logic Unit  ////
/////////////////////////////////


    //Data Signal       -     Output From Alu
    logic [31:0] alu_result;


    //Alu Operands      -     Otput From Register File and Control Unit (Immediate Operand)
    logic [31:0] alu_op1;
    logic [31:0] alu_op2;


    //Control Signals   -     Output From Control Unit
    logic [3:0]  alu_control;
    logic        alu_src;


    always_comb begin
        alu_op1 = reg_data_out1;
        alu_op2 = alu_src ? imm_ext : reg_data_out2 ; //Pick between immediate or register operand
    end
    
    Alu Alu(
        .iAluControl(alu_control),
        .iAluOp1(alu_op1),
        .iAluOp2(alu_op2),
        .oAluResult(alu_result),
        .oZero(zero)
    );    

///////////////////////////////////////////
////  PC Adder : Target PC Calculator  ////
///////////////////////////////////////////


    PCAdder TargetPCAdder(
        .iPC(pc),
        .iImmExt(imm_ext),
        .iInstructionSubType(instruction_type),
        .iRegOffset(alu_op1),
        .oPCTarget(target_pc)
    );

//////////////////////////////////////////////////////////////////////////////////////
////  Write Back Result Selector : Choses What Is Written Back To Register File  /////
//////////////////////////////////////////////////////////////////////////////////////

    //Control Signals   -   Output From Control Unit
    logic [2:0]  result_src;

    ResultMux ResultSelector(
        .iResultSrc(result_src),
        .iAluResult(alu_result),
        .iMemDataOut(mem_data_out),
        .iPC(pc),//
        .iUpperImm(imm_ext),
        .oRegDataIn(reg_data_in)
    );  

//Assign Output As Register Write Back Value

    always_comb begin
        oDataOut = reg_data_in;
    end

endmodule
