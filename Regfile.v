`include "Defines.vh"
`include "IDInstDef.vh"
// `include "Common.vh"

module Regfile(
	input wire clk,
	input wire rst,

	input wire				w_enable,
	input wire[`RegAddrBus] w_addr, 
	input wire[`RegBus]	 	w_data,

	input wire				r1_enable,
	input wire[`RegAddrBus] r1_addr,
	output reg[`RegBus]		r1_data,

	input wire				r2_enable,
	input wire[`RegAddrBus] r2_addr,
	output reg[`RegBus]	 	r2_data
);

reg [`RegBus] regs[(1 << `RegAddrWidth) - 1 : 0];

initial begin
	regs[0] = `RegWidth'h0;
end

always @ (posedge clk)
begin
	if (!rst)
	begin
		if (w_enable && w_addr != `RegAddrWidth'h0)
			regs[w_addr] <= w_data;
	end
end

always @ (*)
begin
	if (rst)
	begin
		r1_data <= `ZeroWord;
	end
	else if (r1_enable && r1_addr == w_addr && w_enable)
		r1_data <= w_data;
	else if (r1_enable)
		r1_data <= regs[r1_addr];
	else
		r1_data <= `ZeroWord;
end

always @ (*)
begin
	if (rst)
	begin
		r2_data <= `ZeroWord;
	end
	else if (r2_enable && r2_addr == w_addr && w_enable)
		r2_data <= w_data;
	else if (r2_enable)
		r2_data <= regs[r2_addr];
	else
		r2_data <= `ZeroWord;
end


endmodule