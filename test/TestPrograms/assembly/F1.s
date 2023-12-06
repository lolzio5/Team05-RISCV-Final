main:
    addi    a0, zero, 0x0                       # load a0 with 0 (a0 is vbd_value, the output)
    addi    x2, zero, 0x0FF
    addi    s2, zero, 0x000 
    addi    s3, zero, 0x001
    addi    s4, zero, 0x000
    addi    s5, zero, 0x001
    jal     x0, loop                            # Jump to loop

loop:
    addi    s1, zero, 0x00F                      # load s1 with a large number to be counted down
    sll     a0, a0, 1                           # shift a0 by 1 so it goes up sequentially in decimal
    addi    a0, a0, 1                           # increment a0 by 1
    beq     a0, x2, random_time                 # If a0 is 255, turn off after a random time
    jal     x0, constant_time                   # Jump to constant_time

constant_time:
    addi    s1, s1, -1                          # Decrement s1
    beq     s1, zero, loop                      # If s1 is equal to zero, return to loop
    jal     x0, constant_time                   # Else continue looping

random_time:
    jal     x1, random_logic                    # Calculate the random value to be decremented                         # Make s6 much bigger so more time is wasted
    addi    s6, s6, -1
    beq     s6, zero, end                       # If s6 is equal to zero, end the program
    jalr    x1, x1, 1                           # Else continue looping from the adding statement

random_logic:
    addi    s6, zero, 0x0
    add     s6, s6, s2
    sll     s3, s3, 0x001
    add     s6, s6, s3
    sll     s4, s4, 0x001
    add     s6, s6, s4
    sll     s5, s5, 0x001
    add     s6, s6, s5
    xor     s2, s4, s5
    jalr    x0, x1, 1                           # Return to random_time, 1 instruction later

end:
    addi    a0, zero, 0x0 
    jal     x0, loop

