module cache_top(
    input  logic         iClk,
    input logic          iWriteEn,
    input logic          iInstructionType,
    input logic          iMemoryInstructionType,     
    input logic [31:0]   iAddress,
    output logic [31:0]  oMemData  
);

logic [25:0] ATag;
logic [25:0] CTag;
logic [3:0]  AIndex;
logic [3:0]  FlushIndex;
logic [31:0] CData;
logic CValid;
logic hit;
logic [31:0] MainMemoryData;
logic [31:0] MainMemoryAdress;
logic ReadMainMemory;
logic iFlush;
logic [31:0] iFlushAddress;
logic [31:0] tData;

always_comb begin

    if (iWriteEn==1) begin
        iFlush <= 1;
        iFlushAddress <= iAddress;
    end
        
end

always_ff @(negedge iClk) begin
    oData=tData;
end
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
    .iHit(hit),
    .iFlushAddress(FlushIndex),
    .iMainMemoryData(MainMemoryData),
    .oMainMemoryAdress(MainMemoryAdress),
    .oReadMainMemory(ReadMainMemory),
    .oTag(CTag),
    .oV(CValid),
    .oData(tData)
);

DataMemory DataMemory(
    
);

findhit findhit(
    .iV(CValid),
    .iTagCache(CTag),
    .iTagTarget(ATag),
    .oHit(hit)
);
endmodule
