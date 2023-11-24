// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vdatamem.h for the primary calling header

#include "verilated.h"

#include "Vdatamem__Syms.h"
#include "Vdatamem__Syms.h"
#include "Vdatamem___024root.h"

void Vdatamem___024root___ctor_var_reset(Vdatamem___024root* vlSelf);

Vdatamem___024root::Vdatamem___024root(Vdatamem__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vdatamem___024root___ctor_var_reset(this);
}

void Vdatamem___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vdatamem___024root::~Vdatamem___024root() {
}
