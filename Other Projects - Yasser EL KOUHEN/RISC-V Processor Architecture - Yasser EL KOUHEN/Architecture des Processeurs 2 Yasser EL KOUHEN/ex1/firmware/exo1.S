.section .start;
.globl start;



start:
	li t0,1
	li t1,2
	li t2,3
	li t3,4
	li t4,5
	li t5,6
	li t6,7
lab1 :  j  lab1
	nop

.end start
