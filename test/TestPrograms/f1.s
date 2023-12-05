main:
    addi    a0, zero, 0x0                       # load a0 with 0 (a0 is vbd_value, the output)
    addi    x2, zero, 0xFF
    addi    s2, zero, 0b1 
    addi    s3, zero, 0b1
    addi    s4, zero, 0b1
    addi    s5, zero, 0b0
    jal     x0, loop                            # Jump to loop

loop:
    addi    s1, zero, 0xFF                      # load s1 with a large number to be counted down
    addi    a0, a0, 1                           # increment a0 by 1
    beq     a0, x2, random_time                 # If a0 is 255, turn off after a random time
    jal     x0, constant_time                   # Jump to constant_time

constant_time:
    addi    s1, t1, -1                          # Decrement s1
    beq     s1, zero, loop                      # If s1 is equal to zero, return to loop
    jal     x0, constant_time                   # Else continue looping

random_time:
    jal     x1, random_logic                    # Calculate the random value to be decremented
    sll     s6, s6, 10                          # Make t6 much bigger so more time is wasted
    addi    s6, s6, -1
    beq     s6, zero, end                       # If s6 is equal to zero, end the program
    jalr    x1, x1, 2                           # Else continue looping from the adding statement

random_logic:
    addi    s6, zero, 0x0
    addi    s6, t2, 0x0
    sll     t3, t3, 1
    addi    s6, t3, 0x0
    sll     t4, t4, 2
    addi    s6, t4, 0x0
    sll     t5, t5, 3
    addi    s6, t5, 0x0
    xor     t2, t4, t5
    jalr    x1, x1, 1                           # Return to random_time, 1 instruction later

end:
    addi    a0, zero, 0x0                       #turn off the lights
