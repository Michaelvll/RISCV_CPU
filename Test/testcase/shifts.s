.org 0x0
.globl _start

_start:
	lui x2, 0x04040			# x2				=	0x04040000
	ori x2, x2, 0x404		# x2 = x2 | 0x404	=	0x04040404
	ori x7, x0, 0x7			# x7 = x0 | 0x7		=	0x00000007
	ori x5, x0, 0x5			# x5 = x0 | 0x5		=	0x00000005
	ori x8, x0, 0x8			# x8 = x0 | 0x8		=	0x00000008
	slli x2, x2, 8			# x2 = x2 << 8		=	0x04040400
	sll x2, x2, x7			# x2 = x2 << x7		=	0x02020000
	srli x2, x2, 8			# x2 = x2 >> 8		=	0x00020200
	sra x2, x2, x8			# x2 = x2 a>> x8	=	0x00000202
	sll x2, x2, x8			# x2 = x2 << x8		=	0x00020200
	srai x2, x2, 1			# x2 = x2 a>> 1		= 	0x00010100
	srl  x2, x2, x8			# x2 = x2 >> x8		=	0x00000101
	# nop
	slli x2, x2, 23			# x2 = x2 << 23		=	0x80800000
	srai x2, x2, 16			# x2 = x2 a>> 16	= 	0xffff8080
	sra x2, x2, x8			# x2 = x2 a>> 8		=	0xffffff80
