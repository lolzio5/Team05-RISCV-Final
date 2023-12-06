//Testing basic arithmatic:
li s0, 0xF1
addi s1, s0, 0x1 //Should output 0xF2

xor s2, s1, s0 //Should ouput 0x2 

sll s2, s2, 2 //Should output 0x8

srl s0, s2, 2 //should output 0x2

and s3, s0, s2 //should output 0x0

or s3, s0, s2 //should output 0x0A

slt 

sltu





//Testing loading small immediate value:
lui s0, 0xFF
add    s0, zero, s0 //output 0xFF

//Testing loading large immadede value
//Method 1:
li s0, 0xFEDC8EAB //testing load immediate 
add    s0, zero, s0 //output 0xFEDC8EAB
//Method 2:
lui s0, 0xFEDC9
addi s0, s0, 0xEAB //output 0xFEDC8EAB





