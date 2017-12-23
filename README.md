# RISCV-CPU

This is a project of Computer System class of ACM honor class in SJTU.

## Notice

1. The imm in sltiu command is signed extended, and unsigned compared.

1. The aluop is firstly numbered by the opcode+funct3+(funct7?), then it is renumbered by the sequence: 0x1,0x2,..., to make the number shorter for better performance.

### Branches and Jalr

1. When turn off the switches *ID_BRANCHES* and *ID_JALR*
	
	EX find it needs to change PC, it will set b_flag to 1, so as to clear the content in if_id and id_ex, which clear the pipeline before EX, and set PC to the target address. This method can be regarded as always predict that the branch will not taken.
1. When turn on the switches

	ID will find out whether should PC be changed, and clear IF_ID directly, and set PC to the target address. ID_BRANCHES will slow down ID to some degree, which may cause the pipeline become unbalanced (untested!), and the impact of ID_JALR is much larger than the former one.

### Stall for load

As load can should take one more cycle to get the result of a register, it may stall the pipeline to avoid RAW hazard.

### Makefile for test generation

I write a makefile for make, which can make both .s and .cpp files automatically. And can easily compile the .cpp to .S file and see the dump result by using it. The guidance for using it is in [Makefile for risc v tool chain](https://gist.github.com/Michaelvll/46e069e29a8448326acadd7bb2bb1654).

## Support ISA

Now this project support almost all of the commands in rv32i. The suppoted commands are listed in the [Appendix A](#ApdxA)

## Future

I am trying to change the architecture from Havard architecture to Von Neumann architecture and add uart for memory access with icache and dcache.

## Q&A

1. Why op_imm, like xori command doesn't support imm larger than 0x7ff such as 0x801?
	
	 Because the imm is signed.

## Reference

1. [A MIPS CPU written in Verilog by jmahler](https://github.com/jmahler/mips-cpu.git)
1. 《自己动手写CPU》雷思磊
1. [A Mips CPU written in verilog by sxtyzhangzk](https://github.com/sxtyzhangzk/mips-cpu.git)

## Appendix

### <span id="ApdxA">A. Suppoted commands</span>

| Command | Support |
|---------|---------|
| LUI     | [O]     |
| AUIPC   | [O]     |
| JAL     | [O]     |
| JALR    | [O]     |
| BEQ     | [O]     |
| BNE     | [O]     |
| BLT     | [O]     |
| BGE     | [O]     |
| BLTU    | [O]     |
| BGEU    | [O]     |
| LB      | [O]     |
| LH      | [O]     |
| LW      | [O]     |
| LBU     | [O]     |
| LHU     | [O]     |
| SB      | [O]     |
| SH      | [O]     |
| SW      | [O]     |
| ADDI    | [O]     |
| SLTI    | [O]     |
| SLTIU   | [O]     |
| XORI    | [O]     |
| ORI     | [O]     |
| ANDI    | [O]     |
| SLLI    | [O]     |
| SRLI    | [O]     |
| SRAI    | [O]     |
| ADD     | [O]     |
| SUB     | [O]     |
| SLL     | [O]     |
| SLT     | [O]     |
| SLTU    | [O]     |
| XOR     | [O]     |
| SRL     | [O]     |
| SRA     | [O]     |
| OR      | [O]     |
| AND     | [O]     |
| Fence   | [X]     |
| Fence.I | [X]     |
| ECALL   | [X]     |
| EBREAK  | [X]     |
| CSRRW   | [X]     |
| CSRRS   | [X]     |
| CSRRC   | [X]     |
| CSRRWI  | [X]     |
| CSRRSI  | [X]     |
| CSRRCI  | [X]     |