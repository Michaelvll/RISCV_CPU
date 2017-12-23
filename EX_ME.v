`ifndef _EX_ME
`define _EX_ME

`include "Defines.vh"
`include "IDInstDef.vh"
`include "ALUInstDef.vh"

module EX_ME(
	input wire		clk,
	input wire		rst,

	input wire				ex_w_enable,
	input wire[`RegAddrBus]	ex_w_addr,
	input wire[`RegBus]		ex_w_data,

	output reg				me_w_enable,
	output reg[`RegAddrBus]	me_w_addr,
	output reg[`RegBus]		me_w_data,

	input wire[5:0]			stall,
	
	// For load and store
	input wire[`AluOpBus]	ex_aluop,
	input wire[`RegBus]		ex_mem_addr,
	output reg[`AluOpBus]	me_aluop,
	output reg[`RegBus]		me_mem_addr
);
always @ (posedge clk)
begin
	if (rst)
	begin
		me_w_enable	<=	`WriteDisable;
		me_w_addr	<=	`NOPRegAddr;
		me_w_data	<=	`ZeroWord;

		me_aluop	<=	`EX_NOP_OP;
		me_mem_addr	<=	`ZeroWord;
	end
	else if (stall[3] && !stall[4])
	begin
		me_w_enable	<=	`WriteDisable;
		me_w_addr	<=	`NOPRegAddr;
		me_w_data	<=	`ZeroWord;

		me_aluop	<=	`EX_NOP_OP;
		me_mem_addr	<=	`ZeroWord;
	end
	else if (!stall[3])
	begin
		me_w_enable	<=	ex_w_enable;
		me_w_addr	<=	ex_w_addr;
		me_w_data	<=	ex_w_data;

		me_aluop	<=	ex_aluop;
		me_mem_addr	<=	ex_mem_addr;
	end
end


endmodule

`endif