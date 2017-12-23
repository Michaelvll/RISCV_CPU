	.org 0x0
	.globl _start

_start:
	lui	x3,0x0eeff
	srli x3, x3, 12
	sb	x3, 3(x0)		 # [0x3] = 0xff
	srl  x3,x3,8
	sb	x3, 2(x0)		 # [0x2] = 0xee
	lui x3,0xccdd
	srli x3, x3, 12
	sb	x3, 1(x0)		 # [0x1] = 0xdd
	srl  x3,x3,8
	sb	x3, 0(x0)		 # [0x0] = 0xcc
	lb	x1, 3(x0)		 # x1 = 0xffffffff
	lbu  x1, 2(x0)		 # x1 = 0x000000ee
	lw	x1, 0(x0)		# x1 = 0xffeeddcc
	nop

	lui x3,0xaabb
	srli x3, x3, 12
	sh	x3, 4(x0)		 # [0x4] = 0xbb, [0x5] = 0xaa
	lhu  x1, 4(x0)		 # x1 = 0x0000aabb
	lh	x1, 4(x0)		 # x1 = 0xffffaabb
 
	lui x3,0x8899
	srli x3, x3, 12
	sh	x3, 6(x0)		 # [0x6] = 0x99, [0x7] = 0x88
	lh	x1, 6(x0)		 # x1 = 0xffff8899
	lhu  x1, 6(x0)		 # x1 = 0x00008899

	lui x3,0x4455
	srli x3, x3, 12
	sll  x3,x3,0x10
	lui x2, 0x6677	  
	srli x2, x2, 12
	or x3, x2, x3		# x3 = 0x44556677
	sw	x3, 8(x0)		 # [0x8] = 0x77, [0x9]= 0x66, [0xa]= 0x55, [0xb] = 0x44
	lw	x1, 8(x0)		 # x1 = 0x44556677



	 
_loop:
	j _loop
	nop
