#Testing basic arithmatic:
li s0, 0xF1
addi s1, s0, 0x1 #Should output 0xF2

xor s2, s1, s0 #Should ouput 0x2 

sll s2, s2, 2 #Should output 0x8

srl s0, s2, 2 #should output 0x2

and s3, s0, s2 #should output 0x0

or s3, s0, s2 #should output 0x0A

slt s3, s0, s2

sltu s3, s0, s2


#Testing loading small immediate value:
lui s0, 0xFF
add    s0, zero, s0 #output 0xFF

#Testing loading large immadede value
#Method 1:
li s0, 0xFEDC8EAB #testing load immediate 
add    s0, zero, s0 #output 0xFEDC8EAB
#Method 2:
lui s0, 0xFEDC9
addi s0, s0, 0xEAB #output 0xFEDC8EAB

#testing loop (meric)
main:
    addi    t0, zero, 10     # Initialize t0 with 10
    addi    t1, zero, 0      # Initialize t1 with 0 (loop counter)

loop:
    addi    t1, t1, 1        # Increment t1
    sll     t2, t1, 1        # Shift left logical t1 by 1, store in t2
    xor     t3, t2, t1       # XOR t2 and t1, store in t3
    bne     t1, t0, loop     # If t1 is not equal to t0, branch to loop

    jal     ra, func         # Jump to func, store return address in ra

func:
    addi    t4, zero, 5      # Initialize t4 with 5
    jalr    zero, ra, 0      # Return to the address in ra

end:






