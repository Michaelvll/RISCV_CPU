`ifndef _ME_WB
`define _ME_WB
`include "Defines.vh"
`include "IDInstDef.vh"

module ME_WB(
	input wire					clk,
	input wire					rst,

	input wire					me_w_enable,
	input wire[`RegAddrBus]		me_w_addr,
	input wire[`RegBus]			me_w_data,

	output reg					wb_w_enable,
	output reg[`RegAddrBus]		wb_w_addr,
	output reg[`RegBus]			wb_w_data,

	input wire[5:0]				stall
);

always @ (posedge clk)
begin
	if (rst)
	begin
		wb_w_enable		<=	`WriteDisable;
		wb_w_addr		<=	`NOPRegAddr;
		wb_w_data		<=	`ZeroWord;
	end
	else if (stall[4] && !stall[5])
	begin
		wb_w_enable		<=	`WriteDisable;
		wb_w_addr		<=	`NOPRegAddr;
		wb_w_data		<=	`ZeroWord;
	end
	else if (!stall[4])
	begin
		wb_w_enable		<=	me_w_enable;
		wb_w_addr		<=	me_w_addr;
		wb_w_data		<=	me_w_data;
	end
end



endmodule

`endif