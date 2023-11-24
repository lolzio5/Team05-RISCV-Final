// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vdatamux__Syms.h"


VL_ATTR_COLD void Vdatamux___024root__trace_init_sub__TOP__0(Vdatamux___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamux__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamux___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->declBus(c+1,"A", false,-1, 31,0);
    tracep->declBus(c+2,"RD", false,-1, 31,0);
    tracep->declBit(c+3,"ResultSrc", false,-1);
    tracep->declBus(c+4,"Result", false,-1, 31,0);
    tracep->pushNamePrefix("datamux ");
    tracep->declBus(c+1,"A", false,-1, 31,0);
    tracep->declBus(c+2,"RD", false,-1, 31,0);
    tracep->declBit(c+3,"ResultSrc", false,-1);
    tracep->declBus(c+4,"Result", false,-1, 31,0);
    tracep->popNamePrefix(1);
}

VL_ATTR_COLD void Vdatamux___024root__trace_init_top(Vdatamux___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamux__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamux___024root__trace_init_top\n"); );
    // Body
    Vdatamux___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vdatamux___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vdatamux___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vdatamux___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vdatamux___024root__trace_register(Vdatamux___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamux__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamux___024root__trace_register\n"); );
    // Body
    tracep->addFullCb(&Vdatamux___024root__trace_full_top_0, vlSelf);
    tracep->addChgCb(&Vdatamux___024root__trace_chg_top_0, vlSelf);
    tracep->addCleanupCb(&Vdatamux___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vdatamux___024root__trace_full_sub_0(Vdatamux___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vdatamux___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamux___024root__trace_full_top_0\n"); );
    // Init
    Vdatamux___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vdatamux___024root*>(voidSelf);
    Vdatamux__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vdatamux___024root__trace_full_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vdatamux___024root__trace_full_sub_0(Vdatamux___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamux__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamux___024root__trace_full_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullIData(oldp+1,(vlSelf->A),32);
    bufp->fullIData(oldp+2,(vlSelf->RD),32);
    bufp->fullBit(oldp+3,(vlSelf->ResultSrc));
    bufp->fullIData(oldp+4,(vlSelf->Result),32);
}
