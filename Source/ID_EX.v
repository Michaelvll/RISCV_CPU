`ifndef _ID_EX
`define _ID_EX

`include "Defines.vh"
`include "IDInstDef.vh"

module ID_EX(
	input wire					clk,
	input wire					rst,

	input wire[`InstAddrBus]	id_pc, // In order to put addr calculation to ex
	input wire[`AluOpBus]		id_aluop,
	input wire[`AluOutSelBus]	id_alusel,
	input wire[`RegBus]			id_r1_data,
	input wire[`RegBus]			id_r2_data,
	input wire					id_w_enable,
	input wire[`RegAddrBus]		id_w_addr,
	

	output reg[`AluOpBus]		ex_aluop,
	output reg[`AluOutSelBus]	ex_alusel,
	output reg[`RegBus]			ex_r1_data,
	output reg[`RegBus]			ex_r2_data,
	output reg					ex_w_enable,
	output reg[`RegAddrBus]		ex_w_addr,
	output reg[`InstAddrBus]	ex_pc,

	input wire[5:0]				stall,
	input wire[`RegBus]			id_offset,
	output reg[`RegBus]			ex_offset,

	// For jumps and branches
	input wire					ex_b_flag
);

reg		next_jump;
initial
begin
	next_jump	<=	1'b0;
end

always @ (posedge clk)
begin
	if (rst)
	begin
		ex_aluop			=	`EX_NOP_OP;
		ex_alusel			=	`EX_RES_NOP;
		ex_r1_data			=	`ZeroWord;	
		ex_r2_data			=	`ZeroWord;
		ex_w_enable			=	`WriteDisable;
		ex_w_addr			=	`NOPRegAddr;
		ex_pc				=	`ZeroWord;
		ex_offset			=	`ZeroWord;
		next_jump			=	1'b0;
	end
	else
	begin
		if (ex_b_flag)
		begin
			ex_aluop		=	`EX_NOP_OP;
			ex_alusel		=	`EX_RES_NOP;
			ex_r1_data		=	`ZeroWord;	
			ex_r2_data		=	`ZeroWord;
			ex_w_enable		=	`WriteDisable;
			ex_w_addr		=	`NOPRegAddr;
			ex_pc			=	`ZeroWord;
			ex_offset		=	`ZeroWord;
			next_jump		=	1'b1;
		end
	
		if (stall[2] && !stall[3])
		begin
			ex_aluop		=	`EX_NOP_OP;
			ex_alusel		=	`EX_RES_NOP;
			ex_r1_data		=	`ZeroWord;	
			ex_r2_data		=	`ZeroWord;
			ex_w_enable		=	`WriteDisable;
			ex_w_addr		=	`NOPRegAddr;
			ex_offset		=	`ZeroWord;
			ex_pc			=	`ZeroWord;
		end
		else if (!stall[2])
		begin
			if (next_jump)
			begin
				ex_aluop	=	`EX_NOP_OP;
				ex_alusel	=	`EX_RES_NOP;
				ex_r1_data	=	`ZeroWord;	
				ex_r2_data	=	`ZeroWord;
				ex_w_enable	=	`WriteDisable;
				ex_w_addr	=	`NOPRegAddr;
				ex_offset	=	`ZeroWord;
				ex_pc		=	`ZeroWord;
				next_jump	=	1'b0;
			end
			else
			begin
				ex_aluop	=	id_aluop;
				ex_alusel	=	id_alusel;
				ex_r1_data	=	id_r1_data;
				ex_r2_data	=	id_r2_data;
				ex_w_enable	=	id_w_enable;
				ex_w_addr	=	id_w_addr;
				ex_pc		=	id_pc;
				ex_offset	=	id_offset;
				next_jump	=	1'b0;
			end
		end
	end
end


endmodule

`endif