.org 0x0
.global _start

_start:
# ================== Test for arithmatic ops ================
	lui	x1, 0x80000		# x1 				= 0x80000000
	ori x1, x1, 0x010	# x1 = x1 | 0x010	= 0x80000010

	lui x2, 0x80000		# x2				= 0x80000000
	ori	x2, x2, 0x001	# x2 = x2 | 0x001	= 0x80000001

	add x3, x2, x1		# x3				= 0x00000011
	addi x3, x3, 0x0fe	# x3				= 0x0000010f
	add x3, x3, x2		# x3				= 0x80000110

	sub x3, x3, x2		# x3 				= 0x0000010f

# ================== Test for cmp ops =======================
	lui x1,0xffff0		# x1 				= 0xffff0000
	slt x2, x1, x0		# x2				= 1		notice: signed
	sltu x2, x1, x0		# x2				= 0		notice: unsigned
	lui x1, 0x00001		# x1				= 0x00001000
	slti x3, x1, -0x800	# x3				= 0		notice: signed
	sltiu x3, x1, -0x800 # x3				= 1		notice: signed extend and unsigned comparation


