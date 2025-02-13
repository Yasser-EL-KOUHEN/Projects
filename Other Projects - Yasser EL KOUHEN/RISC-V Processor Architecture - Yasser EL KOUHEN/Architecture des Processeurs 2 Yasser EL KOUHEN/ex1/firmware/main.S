.section .start;
.globl start

start:
    li t0, 0x3
    li t1, 0x8
    nop                 
    nop                 
    nop                  
    add t2, t1, t0

    li t3, 0x10
    li t4, 0x11
    nop
    nop
    nop
    sub t5, t3, t4

lab1:
    j lab1
    nop 

.end start
