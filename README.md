# RISCV-CPU

This is a project of Computer System class of ACM honor class in SJTU.

## Notice

1. The imm in sltiu command is signed extended, and unsigned compared.

1. The aluop is firstly numbered by the opcode+funct3+(funct7?), then it is renumbered by the sequence: 0x1,0x2,..., to make the number shorter for better performance.

### 跳转的处理
1. 不开启ID_BRANCHES和ID_JALR的情况下
	
	EX发现需要跳转，将b_flag置成1，从而清空if_id，id_ex中的内容，从而实现清空流水，同时更新pc值，指向目标位置。相当于是轮盘赌的分支预测方法。
1. 开启两个开关的情况下
	ID阶段判断是否发生跳转，直接对IF_ID进行相应的清空操作，并向pc发出相应的修改信号，其中ID_BRANCHES会在一定程度上拖慢ID的速度，可能会造成流水不均衡（未测试），而ID_JALR的影响可能会更大。

## Problem and solve

1. 如何处理指令造成的暂停流水
	
	我的想法：
		
		见xmind文件		


## Reference

1. [A MIPS CPU written in Verilog by jmahler](https://github.com/jmahler/mips-cpu.git)
1. 《自己动手写CPU》雷思磊
1. [A Mips CPU written in verilog by sxtyzhangzk](https://github.com/sxtyzhangzk/mips-cpu.git)

## Questions

1. Why op_imm, like xori command doesn't support imm larger than 0x7ff such as 0x801?
	Because the imm is signed.
