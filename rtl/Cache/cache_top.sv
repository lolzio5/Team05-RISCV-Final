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
logic [31:0] CData;
logic CValid,
logic hit;

cache_decode cache_decode(
    .iClk(iClk),
    .iAddress(iAddress),
    .oTag(ATag),
    .oIndex(AIndex)
);

cache cache(
    .iCLK(iClk),
    .iIndex(AIndex),
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