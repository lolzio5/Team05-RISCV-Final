// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vdatamem.h for the primary calling header

#include "verilated.h"

#include "Vdatamem__Syms.h"
#include "Vdatamem___024root.h"

VL_ATTR_COLD void Vdatamem___024root___eval_static(Vdatamem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root___eval_static\n"); );
}

VL_ATTR_COLD void Vdatamem___024root___eval_initial(Vdatamem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root___eval_initial\n"); );
    // Body
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = vlSelf->clk;
}

VL_ATTR_COLD void Vdatamem___024root___eval_final(Vdatamem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root___eval_final\n"); );
}

VL_ATTR_COLD void Vdatamem___024root___eval_triggers__stl(Vdatamem___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vdatamem___024root___dump_triggers__stl(Vdatamem___024root* vlSelf);
#endif  // VL_DEBUG
VL_ATTR_COLD void Vdatamem___024root___eval_stl(Vdatamem___024root* vlSelf);

VL_ATTR_COLD void Vdatamem___024root___eval_settle(Vdatamem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root___eval_settle\n"); );
    // Init
    CData/*0:0*/ __VstlContinue;
    // Body
    vlSelf->__VstlIterCount = 0U;
    __VstlContinue = 1U;
    while (__VstlContinue) {
        __VstlContinue = 0U;
        Vdatamem___024root___eval_triggers__stl(vlSelf);
        if (vlSelf->__VstlTriggered.any()) {
            __VstlContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VstlIterCount))) {
#ifdef VL_DEBUG
                Vdatamem___024root___dump_triggers__stl(vlSelf);
#endif
                VL_FATAL_MT("datamem.sv", 1, "", "Settle region did not converge.");
            }
            vlSelf->__VstlIterCount = ((IData)(1U) 
                                       + vlSelf->__VstlIterCount);
            Vdatamem___024root___eval_stl(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vdatamem___024root___dump_triggers__stl(Vdatamem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VstlTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        VL_DBG_MSGF("         'stl' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

void Vdatamem___024root___ico_sequent__TOP__0(Vdatamem___024root* vlSelf);

VL_ATTR_COLD void Vdatamem___024root___eval_stl(Vdatamem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root___eval_stl\n"); );
    // Body
    if ((1ULL & vlSelf->__VstlTriggered.word(0U))) {
        Vdatamem___024root___ico_sequent__TOP__0(vlSelf);
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vdatamem___024root___dump_triggers__ico(Vdatamem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root___dump_triggers__ico\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VicoTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VicoTriggered.word(0U))) {
        VL_DBG_MSGF("         'ico' region trigger index 0 is active: Internal 'ico' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vdatamem___024root___dump_triggers__act(Vdatamem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VactTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VactTriggered.word(0U))) {
        VL_DBG_MSGF("         'act' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

#ifdef VL_DEBUG
VL_ATTR_COLD void Vdatamem___024root___dump_triggers__nba(Vdatamem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root___dump_triggers__nba\n"); );
    // Body
    if ((1U & (~ (IData)(vlSelf->__VnbaTriggered.any())))) {
        VL_DBG_MSGF("         No triggers active\n");
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        VL_DBG_MSGF("         'nba' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vdatamem___024root___ctor_var_reset(Vdatamem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->clk = VL_RAND_RESET_I(1);
    vlSelf->ResultSrc = VL_RAND_RESET_I(1);
    vlSelf->WE = VL_RAND_RESET_I(1);
    vlSelf->A = VL_RAND_RESET_I(32);
    vlSelf->WD = VL_RAND_RESET_I(32);
    vlSelf->Result = VL_RAND_RESET_I(32);
    for (int __Vi0 = 0; __Vi0 < 1024; ++__Vi0) {
        vlSelf->datamem__DOT__ram_array[__Vi0] = VL_RAND_RESET_I(32);
    }
    vlSelf->datamem__DOT__RD = VL_RAND_RESET_I(32);
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = VL_RAND_RESET_I(1);
}
