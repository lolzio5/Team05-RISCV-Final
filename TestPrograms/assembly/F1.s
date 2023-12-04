init:
    addi    s1, zero, 0x000
    addi    s3, zero, 0x000
    addi    s2, zero, 0x008
loop1:
    addi    s1, s1, 0x001
    bne     s2, s1, loop1
    jal     x1, CountDown
    addi    s1, zero, 0x000
    beq     s1, zero, init
CountDown:
    addi    s3, s3, 0x001
    bne     s2, s1, CountDown
    jalr    x0, x1, 0x000
