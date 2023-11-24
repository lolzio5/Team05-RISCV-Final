// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vdatamux.h for the primary calling header

#include "verilated.h"

#include "Vdatamux__Syms.h"
#include "Vdatamux___024root.h"

VL_INLINE_OPT void Vdatamux___024root___ico_sequent__TOP__0(Vdatamux___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamux__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamux___024root___ico_sequent__TOP__0\n"); );
    // Body
    vlSelf->Result = ((IData)(vlSelf->ResultSrc) ? vlSelf->RD
                       : vlSelf->A);
}

void Vdatamux___024root___eval_ico(Vdatamux___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamux__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamux___024root___eval_ico\n"); );
    // Body
    if ((1ULL & vlSelf->__VicoTriggered.word(0U))) {
        Vdatamux___024root___ico_sequent__TOP__0(vlSelf);
    }
}

void Vdatamux___024root___eval_act(Vdatamux___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamux__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamux___024root___eval_act\n"); );
}

void Vdatamux___024root___eval_nba(Vdatamux___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamux__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamux___024root___eval_nba\n"); );
}

void Vdatamux___024root___eval_triggers__ico(Vdatamux___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vdatamux___024root___dump_triggers__ico(Vdatamux___024root* vlSelf);
#endif  // VL_DEBUG
void Vdatamux___024root___eval_triggers__act(Vdatamux___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vdatamux___024root___dump_triggers__act(Vdatamux___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vdatamux___024root___dump_triggers__nba(Vdatamux___024root* vlSelf);
#endif  // VL_DEBUG

void Vdatamux___024root___eval(Vdatamux___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamux__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamux___024root___eval\n"); );
    // Init
    CData/*0:0*/ __VicoContinue;
    VlTriggerVec<0> __VpreTriggered;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    vlSelf->__VicoIterCount = 0U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        __VicoContinue = 0U;
        Vdatamux___024root___eval_triggers__ico(vlSelf);
        if (vlSelf->__VicoTriggered.any()) {
            __VicoContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VicoIterCount))) {
#ifdef VL_DEBUG
                Vdatamux___024root___dump_triggers__ico(vlSelf);
#endif
                VL_FATAL_MT("datamux.sv", 1, "", "Input combinational region did not converge.");
            }
            vlSelf->__VicoIterCount = ((IData)(1U) 
                                       + vlSelf->__VicoIterCount);
            Vdatamux___024root___eval_ico(vlSelf);
        }
    }
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        __VnbaContinue = 0U;
        vlSelf->__VnbaTriggered.clear();
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            vlSelf->__VactContinue = 0U;
            Vdatamux___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    Vdatamux___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("datamux.sv", 1, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
                Vdatamux___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                Vdatamux___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("datamux.sv", 1, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vdatamux___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vdatamux___024root___eval_debug_assertions(Vdatamux___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamux__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamux___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->ResultSrc & 0xfeU))) {
        Verilated::overWidthError("ResultSrc");}
}
#endif  // VL_DEBUG
