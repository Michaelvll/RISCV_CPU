.org 0x0
.global _start

_start:
	lui x1, 0x10100		# x1 = 0x10100000
	ori x1, x1, 0x101	# x1 = x1 | 0x101	= 0x10100101
	ori x2, x1, 0x010	# x2 = x1 | 0x010 	= 0x10100111
	or x1, x1, x2		# x1 = x1 | x2		= 0x10100111
	andi x3, x1, 0x0ce	# x3 = x1 & 0x0ce	= 0x00000000
	and x1, x3, x1		# x1 = x3 & x1		= 0x00000000
	xori x4, x1, 0x7f0	# x4 = x1 ^ 0x7f0	= 0x000007f0
	xori x1, x4, 0x0f0	# x1 = x4 ^ 0x0f0	= 0x00000700
	xor x1, x4, x1		# x1 = x4 ^ x1		= 0x000000f0
