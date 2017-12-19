# RISCV-CPU
This is a project of Computer System class of ACM honor class in SJTU.

## Notice
1. The imm in sltiu command is signed extended, and unsigned compared.
2. The aluop is firstly numbered by the opcode+funct3+(funct7?), then it is renumbered by the sequence: 0x1,0x2,..., to make the number shorter for better performance.

## Reference
1. [A MIPS CPU written in Verilog by jmahler](https://github.com/jmahler/mips-cpu.git)
2. 自己动手写CPU》雷思磊
3. [A Mips CPU written in verilog by sxtyzhangzk](https://github.com/sxtyzhangzk/mips-cpu.git)

## Questions
1. Why op_imm, like xori command doesn't support imm larger than 0x7ff such as 0x801?
	Because the imm is signed.