// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vdatamux.h for the primary calling header

#include "verilated.h"

#include "Vdatamux__Syms.h"
#include "Vdatamux__Syms.h"
#include "Vdatamux___024root.h"

#ifdef VL_DEBUG
VL_ATTR_COLD void Vdatamux___024root___dump_triggers__ico(Vdatamux___024root* vlSelf);
#endif  // VL_DEBUG

void Vdatamux___024root___eval_triggers__ico(Vdatamux___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamux__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamux___024root___eval_triggers__ico\n"); );
    // Body
    vlSelf->__VicoTriggered.set(0U, (0U == vlSelf->__VicoIterCount));
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vdatamux___024root___dump_triggers__ico(vlSelf);
    }
#endif
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vdatamux___024root___dump_triggers__act(Vdatamux___024root* vlSelf);
#endif  // VL_DEBUG

void Vdatamux___024root___eval_triggers__act(Vdatamux___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamux__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamux___024root___eval_triggers__act\n"); );
    // Body
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vdatamux___024root___dump_triggers__act(vlSelf);
    }
#endif
}
