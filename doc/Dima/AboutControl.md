# Control Path and Control Main


## Control Path

The control path is responsible for producing outputs AluCtrl, AluSrc, ImmSrc, PCSrc and RegWrite. It does this by utilising the decoders and encoders to determine which instruction is executing currently.

![](/doc/ControlPath.PNG)



## Control Main



Control main combines the instruction memory ROM, sign extension unit and the control path to produce the full set of outputs :

- AluSrc
- AluCtrl [4:1]
- PCSrc
- ImmSrc [12:1]
- ImmOp [32:1]
- RegWrite

The instructions are fed into the control path from the instruction ROM and outputs of the control path are fed into the main outputs and into the sign extension unit.

![](/doc/ControlMain.PNG)