main:
    addi    a0, zero, 0x0                       # load a0 with 0 (a0 is vbd_value, the output)
    addi    x2, zero, 0xFF
    addi    t2, zero, 0b1 
    addi    t3, zero, 0b1
    addi    t4, zero, 0b1
    addi    t5, zero, 0b0
    jal     x0, loop                            # Jump to loop

loop:
    addi    t1, zero, 0xFF                      # load t1 with a large number to be counted down
    addi    a0, a0, 1                           # increment a0 by 1
    beq     a0, x2, random_time                 # If a0 is 255, turn off after a random time
    jal     x0, constant_time                   # Jump to constant_time

constant_time:
    addi    t1, t1, -1                          # Decrement t1
    beq     t1, zero, loop                      # If t1 is equal to zero, return to loop
    jal     x0, constant_time                   # Else continue looping

random_time:
    jal     x1, random_logic                    # Calculate the random value to be decremented
    sll     t6, t6, 10                          # Make t6 much bigger so more time is wasted
    addi    t6, t6, -1
    beq     t6, zero, end                       # If t6 is equal to zero, end the program
    jalr    x1, x1, 2                           # Else continue looping from the adding statement

random_logic:
    addi    t6, zero, 0x0
    addi    t6, t2, 0x0
    sll     t3, t3, 1
    addi    t6, t3, 0x0
    sll     t4, t4, 2
    addi    t6, t4, 0x0
    sll     t5, t5, 3
    addi    t6, t5, 0x0
    xor     t2, t4, t5
    jalr    x1, x1, 1                           # Return to random_time, 1 instruction later

end:
    addi    a0, zero, 0x0                       #turn off the lights
