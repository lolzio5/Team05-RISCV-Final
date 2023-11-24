// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vdatamux.h for the primary calling header

#ifndef VERILATED_VDATAMUX___024ROOT_H_
#define VERILATED_VDATAMUX___024ROOT_H_  // guard

#include "verilated.h"


class Vdatamux__Syms;

class alignas(VL_CACHE_LINE_BYTES) Vdatamux___024root final : public VerilatedModule {
  public:

    // DESIGN SPECIFIC STATE
    VL_IN8(ResultSrc,0,0);
    CData/*0:0*/ __VactContinue;
    VL_IN(A,31,0);
    VL_IN(RD,31,0);
    VL_OUT(Result,31,0);
    IData/*31:0*/ __VstlIterCount;
    IData/*31:0*/ __VicoIterCount;
    IData/*31:0*/ __VactIterCount;
    VlTriggerVec<1> __VstlTriggered;
    VlTriggerVec<1> __VicoTriggered;
    VlTriggerVec<0> __VactTriggered;
    VlTriggerVec<0> __VnbaTriggered;

    // INTERNAL VARIABLES
    Vdatamux__Syms* const vlSymsp;

    // CONSTRUCTORS
    Vdatamux___024root(Vdatamux__Syms* symsp, const char* v__name);
    ~Vdatamux___024root();
    VL_UNCOPYABLE(Vdatamux___024root);

    // INTERNAL METHODS
    void __Vconfigure(bool first);
};


#endif  // guard
