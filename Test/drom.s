	.section .rom,"ax"
	.globl main

	li sp, 0x00100000
	# li sp, 0x00010000

	jal main
	# sw sp, -8(sp)
	
	li a0, 0xff
	sb a0, 0x108(zero)
.L0:
	j .L0
	