// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vdatamem__Syms.h"


VL_ATTR_COLD void Vdatamem___024root__trace_init_sub__TOP__0(Vdatamem___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->declBit(c+1,"clk", false,-1);
    tracep->declBit(c+2,"ResultSrc", false,-1);
    tracep->declBit(c+3,"WE", false,-1);
    tracep->declBus(c+4,"A", false,-1, 31,0);
    tracep->declBus(c+5,"WD", false,-1, 31,0);
    tracep->declBus(c+6,"Result", false,-1, 31,0);
    tracep->pushNamePrefix("datamem ");
    tracep->declBus(c+8,"ADDRESS_WIDTH", false,-1, 31,0);
    tracep->declBus(c+9,"DATA_WIDTH", false,-1, 31,0);
    tracep->declBit(c+1,"clk", false,-1);
    tracep->declBit(c+2,"ResultSrc", false,-1);
    tracep->declBit(c+3,"WE", false,-1);
    tracep->declBus(c+4,"A", false,-1, 31,0);
    tracep->declBus(c+5,"WD", false,-1, 31,0);
    tracep->declBus(c+6,"Result", false,-1, 31,0);
    tracep->declBus(c+7,"RD", false,-1, 31,0);
    tracep->pushNamePrefix("myDataMux ");
    tracep->declBus(c+4,"A", false,-1, 31,0);
    tracep->declBus(c+7,"RD", false,-1, 31,0);
    tracep->declBit(c+2,"ResultSrc", false,-1);
    tracep->declBus(c+6,"Result", false,-1, 31,0);
    tracep->popNamePrefix(2);
}

VL_ATTR_COLD void Vdatamem___024root__trace_init_top(Vdatamem___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root__trace_init_top\n"); );
    // Body
    Vdatamem___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vdatamem___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vdatamem___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vdatamem___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vdatamem___024root__trace_register(Vdatamem___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root__trace_register\n"); );
    // Body
    tracep->addFullCb(&Vdatamem___024root__trace_full_top_0, vlSelf);
    tracep->addChgCb(&Vdatamem___024root__trace_chg_top_0, vlSelf);
    tracep->addCleanupCb(&Vdatamem___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vdatamem___024root__trace_full_sub_0(Vdatamem___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vdatamem___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root__trace_full_top_0\n"); );
    // Init
    Vdatamem___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vdatamem___024root*>(voidSelf);
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vdatamem___024root__trace_full_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vdatamem___024root__trace_full_sub_0(Vdatamem___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root__trace_full_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullBit(oldp+1,(vlSelf->clk));
    bufp->fullBit(oldp+2,(vlSelf->ResultSrc));
    bufp->fullBit(oldp+3,(vlSelf->WE));
    bufp->fullIData(oldp+4,(vlSelf->A),32);
    bufp->fullIData(oldp+5,(vlSelf->WD),32);
    bufp->fullIData(oldp+6,(vlSelf->Result),32);
    bufp->fullIData(oldp+7,(vlSelf->datamem__DOT__RD),32);
    bufp->fullIData(oldp+8,(0xaU),32);
    bufp->fullIData(oldp+9,(0x20U),32);
}
