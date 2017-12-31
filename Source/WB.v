`ifndef _WB
`define _WB
`include "Defines.vh"
`include "IDInstDef.vh"

module WB(
	input wire					rst,

	input wire					w_enable_i,
	input wire[`RegAddrBus]		w_addr_i,
	input wire[`RegBus]			w_data_i,
	
	output wire					w_enable_o,
	output wire[`RegAddrBus]	w_addr_o,
	output wire[`RegBus]		w_data_o
);

assign w_enable_o	=	rst?1'b0:w_enable_i;
assign w_addr_o		=	rst?`NOPRegAddr:w_addr_i;
assign w_data_o		=	rst?`ZeroWord:w_data_i;



endmodule

`endif