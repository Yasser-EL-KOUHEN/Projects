.section .start
.globl start

start:
    li t0, 15         
    li t1, 5          

.calcul: 
    add t2, t1, t0    
    sub t3, t2, t0    
    and t4, t3, t1   

lab1: 
    j lab1           
    nop

.end start