
  typedef enum logic[3:1] { 
    BRANCH, 
    LOAD, 
    STORE, 
    UPPER, 
    IMM_COMPUTATION, 
    REG_COMMPUTATION, 
    JUMP
  } InstructionTypes;

  typedef enum logic[4:1] {    
    ADD, 
    SUB, 
    SHIFT_LEFT_LOGICAL, 
    SET_LESS_THAN, 
    USET_LESS_THAN,  
    XOR,
    SHIFT_RIGHT_LOGICAL, 
    SHIFT_RIGHT_ARITHMETIC,   
    OR, 
    AND, 
    NULL_R
  } TypeR;

  typedef enum logic [4:1] {   
    IMM_ADD,
    IMM_SHIFT_LEFT_LOGICAL = 2,
    IMM_SET_LESS_THAN, 
    IMM_USET_LESS_THAN, 
    IMM_XOR,
    IMM_SHIFT_RIGHT_LOGICAL, 
    IMM_SHIFT_RIGHT_ARITHMETIC,  
    IMM_OR, 
    IMM_AND,
    LOAD_BYTE, 
    LOAD_HALF, 
    LOAD_WORD, 
    ULOAD_BYTE, 
    ULOAD_HALF,  
    NULL_I
  } TypeI;

  typedef enum logic[2:1] {
    ADD_UPPER_PC,
    LOAD_UPPER_IMM,
    NULL_U
  } TypeU;

  typedef enum logic[2:1] {
    STORE_BYTE,
    STORE_HALF,
    STORE_WORD,
    NULL_S
  } TypeS;

  typedef enum logic[2:1] {
    JUMP_LINK_REG,
    JUMP_LINK,
    NULL_J
  } TypeJ;

  typedef enum logic[3:1] { 
    BEQ, 
    BNE, 
    BLT, 
    BGE, 
    BLTU, 
    BGEU, 
    NULL_B 
  } TypeB;

  typedef union{ 
    TypeR R;
    TypeI I;
    TypeU U;
    TypeS S;
    TypeJ J;
    TypeB B;
  } InstructionSubTypes;

  typedef union {
    TypeR REG_COMPUTATION;
    TypeI IMM_COMPUTATION;
  } AluOp;
