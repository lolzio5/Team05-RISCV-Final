// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vdatamux.h"
#include "Vdatamux__Syms.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vdatamux::Vdatamux(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vdatamux__Syms(contextp(), _vcname__, this)}
    , ResultSrc{vlSymsp->TOP.ResultSrc}
    , A{vlSymsp->TOP.A}
    , RD{vlSymsp->TOP.RD}
    , Result{vlSymsp->TOP.Result}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vdatamux::Vdatamux(const char* _vcname__)
    : Vdatamux(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vdatamux::~Vdatamux() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vdatamux___024root___eval_debug_assertions(Vdatamux___024root* vlSelf);
#endif  // VL_DEBUG
void Vdatamux___024root___eval_static(Vdatamux___024root* vlSelf);
void Vdatamux___024root___eval_initial(Vdatamux___024root* vlSelf);
void Vdatamux___024root___eval_settle(Vdatamux___024root* vlSelf);
void Vdatamux___024root___eval(Vdatamux___024root* vlSelf);

void Vdatamux::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vdatamux::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vdatamux___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vdatamux___024root___eval_static(&(vlSymsp->TOP));
        Vdatamux___024root___eval_initial(&(vlSymsp->TOP));
        Vdatamux___024root___eval_settle(&(vlSymsp->TOP));
    }
    // MTask 0 start
    VL_DEBUG_IF(VL_DBG_MSGF("MTask0 starting\n"););
    Verilated::mtaskId(0);
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vdatamux___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfThreadMTask(vlSymsp->__Vm_evalMsgQp);
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vdatamux::eventsPending() { return false; }

uint64_t Vdatamux::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vdatamux::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vdatamux___024root___eval_final(Vdatamux___024root* vlSelf);

VL_ATTR_COLD void Vdatamux::final() {
    Vdatamux___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vdatamux::hierName() const { return vlSymsp->name(); }
const char* Vdatamux::modelName() const { return "Vdatamux"; }
unsigned Vdatamux::threads() const { return 1; }
void Vdatamux::prepareClone() const { contextp()->prepareClone(); }
void Vdatamux::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vdatamux::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vdatamux___024root__trace_init_top(Vdatamux___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vdatamux___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vdatamux___024root*>(voidSelf);
    Vdatamux__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->scopeEscape(' ');
    tracep->pushNamePrefix(std::string{vlSymsp->name()} + ' ');
    Vdatamux___024root__trace_init_top(vlSelf, tracep);
    tracep->popNamePrefix();
    tracep->scopeEscape('.');
}

VL_ATTR_COLD void Vdatamux___024root__trace_register(Vdatamux___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vdatamux::trace(VerilatedVcdC* tfp, int levels, int options) {
    if (tfp->isOpen()) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vdatamux::trace()' shall not be called after 'VerilatedVcdC::open()'.");
    }
    if (false && levels && options) {}  // Prevent unused
    tfp->spTrace()->addModel(this);
    tfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    Vdatamux___024root__trace_register(&(vlSymsp->TOP), tfp->spTrace());
}
