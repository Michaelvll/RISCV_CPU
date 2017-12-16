`ifndef _WB
`define _WB
`include "Defines.vh"

module WB(
	input wire		rst,

	input wire					w_enable_i,
	input wire[`RegAddrBus]		w_addr_i,
	input wire[`RegBus]			w_data_i,
	
	output wire					w_enable_o,
	output wire[`RegAddrBus]	w_addr_o,
	output wire[`RegBus]		w_data_o
);

assign w_enable_o	=	w_enable_i;
assign w_addr_o		=	w_addr_i;
assign w_data_o		=	w_data_i;



endmodule

`endif