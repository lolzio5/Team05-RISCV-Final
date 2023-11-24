// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vdatamem.h for the primary calling header

#ifndef VERILATED_VDATAMEM___024ROOT_H_
#define VERILATED_VDATAMEM___024ROOT_H_  // guard

#include "verilated.h"


class Vdatamem__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vdatamem___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(clk,0,0);
    VL_IN8(ResultSrc,0,0);
    VL_IN8(WE,0,0);
    CData/*0:0*/ __Vtrigprevexpr___TOP__clk__0;
    CData/*0:0*/ __VactContinue;
    VL_IN(A,31,0);
    VL_IN(WD,31,0);
    VL_OUT(Result,31,0);
    IData/*31:0*/ datamem__DOT__RD;
    IData/*31:0*/ __VstlIterCount;
    IData/*31:0*/ __VicoIterCount;
    IData/*31:0*/ __VactIterCount;
    VlUnpacked<IData/*31:0*/, 1024> datamem__DOT__ram_array;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<1> __VactTriggered;
    VlTriggerVec<1> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vdatamem__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vdatamem___024root(Vdatamem__Syms* symsp, const char* v__name);
    ~Vdatamem___024root();
    VL_UNCOPYABLE(Vdatamem___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
