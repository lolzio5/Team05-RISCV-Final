// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vdatamem.h for the primary calling header

#include "verilated.h"

#include "Vdatamem__Syms.h"
#include "Vdatamem___024root.h"

VL_INLINE_OPT void Vdatamem___024root___ico_sequent__TOP__0(Vdatamem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root___ico_sequent__TOP__0\n"); );
    // Body
    vlSelf->Result = ((IData)(vlSelf->ResultSrc) ? vlSelf->datamem__DOT__RD
                       : vlSelf->A);
}

void Vdatamem___024root___eval_ico(Vdatamem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root___eval_ico\n"); );
    // Body
    if ((1ULL & vlSelf->__VicoTriggered.word(0U))) {
        Vdatamem___024root___ico_sequent__TOP__0(vlSelf);
    }
}

void Vdatamem___024root___eval_act(Vdatamem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vdatamem___024root___nba_sequent__TOP__0(Vdatamem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root___nba_sequent__TOP__0\n"); );
    // Init
    SData/*9:0*/ __Vdlyvdim0__datamem__DOT__ram_array__v0;
    __Vdlyvdim0__datamem__DOT__ram_array__v0 = 0;
    IData/*31:0*/ __Vdlyvval__datamem__DOT__ram_array__v0;
    __Vdlyvval__datamem__DOT__ram_array__v0 = 0;
    CData/*0:0*/ __Vdlyvset__datamem__DOT__ram_array__v0;
    __Vdlyvset__datamem__DOT__ram_array__v0 = 0;
    // Body
    __Vdlyvset__datamem__DOT__ram_array__v0 = 0U;
    if (vlSelf->WE) {
        __Vdlyvval__datamem__DOT__ram_array__v0 = vlSelf->WD;
        __Vdlyvset__datamem__DOT__ram_array__v0 = 1U;
        __Vdlyvdim0__datamem__DOT__ram_array__v0 = 
            (0x3ffU & vlSelf->A);
    }
    if ((1U & (~ (IData)(vlSelf->WE)))) {
        vlSelf->datamem__DOT__RD = vlSelf->datamem__DOT__ram_array
            [(0x3ffU & vlSelf->A)];
    }
    if (__Vdlyvset__datamem__DOT__ram_array__v0) {
        vlSelf->datamem__DOT__ram_array[__Vdlyvdim0__datamem__DOT__ram_array__v0] 
            = __Vdlyvval__datamem__DOT__ram_array__v0;
    }
    vlSelf->Result = ((IData)(vlSelf->ResultSrc) ? vlSelf->datamem__DOT__RD
                       : vlSelf->A);
}

void Vdatamem___024root___eval_nba(Vdatamem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root___eval_nba\n"); );
    // Body
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vdatamem___024root___nba_sequent__TOP__0(vlSelf);
    }
}

void Vdatamem___024root___eval_triggers__ico(Vdatamem___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vdatamem___024root___dump_triggers__ico(Vdatamem___024root* vlSelf);
#endif  // VL_DEBUG
void Vdatamem___024root___eval_triggers__act(Vdatamem___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vdatamem___024root___dump_triggers__act(Vdatamem___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vdatamem___024root___dump_triggers__nba(Vdatamem___024root* vlSelf);
#endif  // VL_DEBUG

void Vdatamem___024root___eval(Vdatamem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root___eval\n"); );
    // Init
    CData/*0:0*/ __VicoContinue;
    VlTriggerVec<1> __VpreTriggered;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    vlSelf->__VicoIterCount = 0U;
    __VicoContinue = 1U;
    while (__VicoContinue) {
        __VicoContinue = 0U;
        Vdatamem___024root___eval_triggers__ico(vlSelf);
        if (vlSelf->__VicoTriggered.any()) {
            __VicoContinue = 1U;
            if (VL_UNLIKELY((0x64U < vlSelf->__VicoIterCount))) {
#ifdef VL_DEBUG
                Vdatamem___024root___dump_triggers__ico(vlSelf);
#endif
                VL_FATAL_MT("datamem.sv", 1, "", "Input combinational region did not converge.");
            }
            vlSelf->__VicoIterCount = ((IData)(1U) 
                                       + vlSelf->__VicoIterCount);
            Vdatamem___024root___eval_ico(vlSelf);
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
            Vdatamem___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    Vdatamem___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("datamem.sv", 1, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
                Vdatamem___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                Vdatamem___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("datamem.sv", 1, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vdatamem___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vdatamem___024root___eval_debug_assertions(Vdatamem___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vdatamem___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->ResultSrc & 0xfeU))) {
        Verilated::overWidthError("ResultSrc");}
    if (VL_UNLIKELY((vlSelf->WE & 0xfeU))) {
        Verilated::overWidthError("WE");}
}
#endif  // VL_DEBUG
