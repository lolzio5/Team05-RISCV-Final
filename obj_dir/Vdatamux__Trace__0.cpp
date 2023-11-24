// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vdatamux__Syms.h"


void Vdatamux___024root__trace_chg_sub_0(Vdatamux___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vdatamux___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamux___024root__trace_chg_top_0\n"); );
    // Init
    Vdatamux___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vdatamux___024root*>(voidSelf);
    Vdatamux__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vdatamux___024root__trace_chg_sub_0((&vlSymsp->TOP), bufp);
}

void Vdatamux___024root__trace_chg_sub_0(Vdatamux___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamux__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamux___024root__trace_chg_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    bufp->chgIData(oldp+0,(vlSelf->A),32);
    bufp->chgIData(oldp+1,(vlSelf->RD),32);
    bufp->chgBit(oldp+2,(vlSelf->ResultSrc));
    bufp->chgIData(oldp+3,(vlSelf->Result),32);
}

void Vdatamux___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamux___024root__trace_cleanup\n"); );
    // Init
    Vdatamux___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vdatamux___024root*>(voidSelf);
    Vdatamux__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VlUnpacked<CData/*0:0*/, 1> __Vm_traceActivity;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        __Vm_traceActivity[__Vi0] = 0;
    }
    // Body
    vlSymsp->__Vm_activity = false;
    __Vm_traceActivity[0U] = 0U;
}
