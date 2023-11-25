# Decoders

### The components in this section are used to decode incoming instruction parts such as the OpCode, funct3 and funct7

---

### i and r Funct_decode

![ifunct decode](/doc/ifunct_decode.PNG "ifunct decode")
![ decode](/doc/rfunct_decode.PNG " decode")

These two decoders are needed to decode I and R type instructions. Dependind on the values of funct3, funct7 and OpCode, the decoder would produce a single output which would distinguish which instruction is currently executing.

- *For example an output can be STR_WORD from iFunct_decode if the current instruction is to load a word*

---

### funct7 and funct3 decode

![funct3 decode](/doc/funct3_decode.PNG "funct3 decode")

These decoders are built upon the i and r funct decoders in order to further differentiate between the type of instructions running.

funct3 uses the i and r type decoders to produce an extended list of outputs that cover various load, store, arithmetic and immediate instructions.

funct7 narrows down the selection of the arithmetic and right shift instructions.

---

### Op_decode 

This decoder is needed