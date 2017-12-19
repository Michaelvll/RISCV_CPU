`ifndef _EX_ME
`define _EX_ME

`include "Defines.vh"
`include "IDInstDef.vh"

module EX_ME(
	input wire		clk,
	input wire		rst,

	input wire				ex_w_enable,
	input wire[`RegAddrBus]	ex_w_addr,
	input wire[`RegBus]		ex_w_data,

	output reg				me_w_enable,
	output reg[`RegAddrBus]	me_w_addr,
	output reg[`RegBus]		me_w_data,

	input wire[5:0]			stall
);
always @ (posedge clk)
begin
	if (rst)
	begin
		me_w_enable	<=	`WriteDisable;
		me_w_addr	<=	`NOPRegAddr;
		me_w_data	<=	`ZeroWord;
	end
	else if (stall[3] && !stall[4])
	begin
		me_w_enable	<=	`WriteDisable;
		me_w_addr	<=	`NOPRegAddr;
		me_w_data	<=	`ZeroWord;
	end
	else if (!stall[3])
	begin
		me_w_enable	<=	ex_w_enable;
		me_w_addr	<=	ex_w_addr;
		me_w_data	<=	ex_w_data;
	end
end


endmodule

`endif