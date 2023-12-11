module cahe_top(
    input  logic         iClk,     
    input  logic         iRst, 
    input  logic         iFlush,
    input logic [31:0]   iFlushAddress,
    input logic [31:0]   iAddress,
    output logic [31:0]  oData  
);

logic [25:0] ATag;
logic [25:0] CTag
logic [3:0]  AIndex;
logic [3:0]  FlushIndex,
logic [31:0] CData;
logic CValid,
logic hit;
logic [31:0] MainMemoryData;
logic [31:0] MainMemoryAdress;
logic ReadMainMemory;


cache_decode cache_decode(
    .iAddress(iAddress),
    .iFlushAddress(iFlushAddress),
    .oIndexFlush(FlushIndex),
    .oTag(ATag),
    .oIndex(AIndex)
);

cache cache(
    .iCLK(iClk),
    .iIndex(AIndex),
    .iFlush(iFlush),
    .iAddress(iAddress),
    .iFlushAddress(FlushIndex),
    .iMainMemoryData(MainMemoryData),
    .oMainMemoryAdress(MainMemoryAdress)
    .oReadMainMemory(ReadMainMemory),
    .oTag(CTag),
    .oV(CValid),
    .oData(CData)
);

findhit findhit(
    .iV(CValid),
    .iTagCache(CTag),
    .iTagTarget(ATag),
    .oHit(hit)
);

DataMemory DataMemory(
    .iClk(iClk),
    .iWriteEn(mem_write_en),
    .iInstructionType(instruction_type),
    .iMemoryInstructionType(instruction_sub_type), 
    .iAddress(alu_result),
    .iMemData(mem_data_in),
    .oMemData(mem_data_out)
);