// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vdatamem.h"
#include "Vdatamem__Syms.h"
#include "verilated_vcd_c.h"

//============================================================
// Constructors

Vdatamem::Vdatamem(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vdatamem__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , ResultSrc{vlSymsp->TOP.ResultSrc}
    , WE{vlSymsp->TOP.WE}
    , A{vlSymsp->TOP.A}
    , WD{vlSymsp->TOP.WD}
    , Result{vlSymsp->TOP.Result}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vdatamem::Vdatamem(const char* _vcname__)
    : Vdatamem(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vdatamem::~Vdatamem() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vdatamem___024root___eval_debug_assertions(Vdatamem___024root* vlSelf);
#endif  // VL_DEBUG
void Vdatamem___024root___eval_static(Vdatamem___024root* vlSelf);
void Vdatamem___024root___eval_initial(Vdatamem___024root* vlSelf);
void Vdatamem___024root___eval_settle(Vdatamem___024root* vlSelf);
void Vdatamem___024root___eval(Vdatamem___024root* vlSelf);

void Vdatamem::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vdatamem::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vdatamem___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_activity = true;
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vdatamem___024root___eval_static(&(vlSymsp->TOP));
        Vdatamem___024root___eval_initial(&(vlSymsp->TOP));
        Vdatamem___024root___eval_settle(&(vlSymsp->TOP));
    }
    // MTask 0 start
    VL_DEBUG_IF(VL_DBG_MSGF("MTask0 starting\n"););
    Verilated::mtaskId(0);
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vdatamem___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfThreadMTask(vlSymsp->__Vm_evalMsgQp);
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vdatamem::eventsPending() { return false; }

uint64_t Vdatamem::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "%Error: No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vdatamem::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vdatamem___024root___eval_final(Vdatamem___024root* vlSelf);

VL_ATTR_COLD void Vdatamem::final() {
    Vdatamem___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vdatamem::hierName() const { return vlSymsp->name(); }
const char* Vdatamem::modelName() const { return "Vdatamem"; }
unsigned Vdatamem::threads() const { return 1; }
void Vdatamem::prepareClone() const { contextp()->prepareClone(); }
void Vdatamem::atClone() const {
    contextp()->threadPoolpOnClone();
}
std::unique_ptr<VerilatedTraceConfig> Vdatamem::traceConfig() const {
    return std::unique_ptr<VerilatedTraceConfig>{new VerilatedTraceConfig{false, false, false}};
};

//============================================================
// Trace configuration

void Vdatamem___024root__trace_init_top(Vdatamem___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD static void trace_init(void* voidSelf, VerilatedVcd* tracep, uint32_t code) {
    // Callback from tracep->open()
    Vdatamem___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vdatamem___024root*>(voidSelf);
    Vdatamem__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (!vlSymsp->_vm_contextp__->calcUnusedSigs()) {
        VL_FATAL_MT(__FILE__, __LINE__, __FILE__,
            "Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    }
    vlSymsp->__Vm_baseCode = code;
    tracep->scopeEscape(' ');
    tracep->pushNamePrefix(std::string{vlSymsp->name()} + ' ');
    Vdatamem___024root__trace_init_top(vlSelf, tracep);
    tracep->popNamePrefix();
    tracep->scopeEscape('.');
}

VL_ATTR_COLD void Vdatamem___024root__trace_register(Vdatamem___024root* vlSelf, VerilatedVcd* tracep);

VL_ATTR_COLD void Vdatamem::trace(VerilatedVcdC* tfp, int levels, int options) {
    if (tfp->isOpen()) {
        vl_fatal(__FILE__, __LINE__, __FILE__,"'Vdatamem::trace()' shall not be called after 'VerilatedVcdC::open()'.");
    }
    if (false && levels && options) {}  // Prevent unused
    tfp->spTrace()->addModel(this);
    tfp->spTrace()->addInitCb(&trace_init, &(vlSymsp->TOP));
    Vdatamem___024root__trace_register(&(vlSymsp->TOP), tfp->spTrace());
}
