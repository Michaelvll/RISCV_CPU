`ifndef _ME
`define _ME
`include "Defines.vh"
`include "IDInstDef.vh"

module ME(
	input wire rst,

	input wire				w_enable_i,
	input wire[`RegAddrBus]	w_addr_i,
	input wire[`RegBus]		w_data_i,

	output reg 				w_enable_o,
	output reg[`RegAddrBus]	w_addr_o,
	output reg[`RegBus]		w_data_o
);

always @ (*)
begin
	if (rst)
	begin
		w_enable_o	<=	`WriteDisable;
		w_addr_o		<=	`NOPRegAddr;
		w_data_o	<=	`ZeroWord;
	end
	else
	begin
		w_enable_o	<=	w_enable_i;
		w_addr_o		<=	w_addr_i;
		w_data_o	<=	w_data_i;
	end
end

endmodule

`endif