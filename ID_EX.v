`ifndef _ID_EX
`define _ID_EX

`include "Defines.vh"
`include "IDInstDef.vh"

module ID_EX(
	input wire				clk,
	input wire				rst,

	input wire[`AluOpBus]		id_aluop,
	input wire[`AluOutSelBus]	id_alusel,
	input wire[`RegBus]			id_r1_data,
	input wire[`RegBus]			id_r2_data,
	input wire					id_w_enable,
	input wire[`RegBus]			id_w_addr,

	output reg[`AluOpBus]		ex_aluop,
	output reg[`AluOutSelBus]	ex_alusel,
	output reg[`RegBus]			ex_r1_data,
	output reg[`RegBus]			ex_r2_data,
	output reg					ex_w_enable,
	output reg[`RegAddrBus]		ex_w_addr
);
always @ (posedge clk)
begin
	if (rst)
	begin
		ex_aluop		<=	`EX_NOP_OP;
		ex_alusel		<=	`EX_RES_NOP;
		ex_r1_data		<=	`ZeroWord;	
		ex_r2_data		<=	`ZeroWord;
		ex_w_enable		<=	`WriteDisable;
		ex_w_addr		<=	`NOPRegAddr;
	end
	else
	begin
		ex_aluop		<=	id_aluop;
		ex_alusel		<=	id_alusel;
		ex_r1_data		<=	id_r1_data;
		ex_r2_data		<=	id_r2_data;
		ex_w_enable		<=	id_w_enable;
		ex_w_addr		<=	id_w_addr;
	end
end


endmodule

`endif