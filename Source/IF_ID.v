`ifndef _IF_ID
`define	_IF_ID
`include "Defines.vh"
`include "IDInstDef.vh"

module IF_ID(
	input wire	clk,
	input wire	rst,

	input wire[`InstAddrBus]	if_pc,
	input wire[`InstBus]		if_inst,

	output reg[`InstAddrBus]	id_pc,
	output reg[`InstBus]		id_inst,

	input wire[5:0]				stall,

	input wire					ex_b_flag,
	input wire					id_b_flag
);

reg					next_jump;
reg[`InstAddrBus]	next_pc;
reg[`InstBus]		next_inst;

initial
begin
	next_jump	<=	1'b0;
end

always @ (posedge clk)
begin
	if (rst)
	begin
		id_pc				=  `ZeroWord;
		id_inst 			=  `ZeroWord;
		next_jump			=	1'b0;
	end
	else 
	begin
		if (id_b_flag || ex_b_flag)
		begin
			next_jump		=	1'b1;
		end
		
		if(stall[1] && !stall[2])
		begin
			id_pc 			=	`ZeroWord;
			id_inst			=	`ZeroWord;
		end
		else if (!stall[1])
		begin
			if (next_jump)
			begin
				id_pc 		=	`ZeroWord;
				id_inst		=	`ZeroWord;
				next_jump	=	1'b0;
			end
			else
			begin
				id_pc		=	if_pc;
				id_inst		=	if_inst;
				next_jump	=	1'b0;
			end
		end
	end
end

endmodule

`endif