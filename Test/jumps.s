.org 0x0
.global _start

_start:
ori x1, x0, 0x000			# (1) x1 = 0x00000000
jal x0,	_j10 				# (1) jump to 0x10
ori x1, x0, 0x111
ori x1, x0, 0x110

_j10:
# addr = 0x10
ori x1, x0, 0x010			# (2) x1 = 0x00000010
jal x3, _j24				# jump to 0x24 and set x3 = 0x18

ori x1, x0, 0x005			# x1 = 0x00000005
ori x1, x0, 0x01c			# (4) x1 = 0x0000001c
j _j38						# jump to 0x60

_j24:
# addr = 0x24
ori x1, x0, 0x24			# (3) x1 = 0x00000024
jalr x2, 4(x3)				# (3) jump to 0x1c and set x2 = 2c

ori x1, x0, 0x02c			# (6) x1 = 0x0000002c
ori x1, x0, 0x030			# (6) x1 = 0x00000030
j		_j48				# (6) jump to 0x80

_j38:
# addr =  0x38
ori x1, x0, 0x038			# (5) x1 = 0x00000038
jr x2						# (5) jump to 0x2c

ori x1, x0, 0x040
ori x1, x0, 0x044

_j48:
# addr = 0x48
ori x1, x0, 0x048			# (7) x1 = 0x00000048
ori x1, x0, 0x000			# (7) x1 = 0x00000000

_loop:
	addi x1, x1, 0x1		# (8+) ++x1
	j _loop
