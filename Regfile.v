`include "Defines.vh"
// `include "Common.vh"

module regfile(
	input wire clk,
	input wire rst,

	input wire				w_enable,
	input wire[`RegAddrBus] w_addr, 
	input wire[`RegBus]	 	w_data,

	input wire				r_enable_1,
	input wire[`RegAddrBus] r_addr_1,
	output reg[`RegBus]		rdata1,

	input wire				r_enable_2,
	input wire[`RegAddrBus] r_addr_2,
	output reg[`RegBus]	 	rdata2
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
		rdata1 <= `ZeroWord;
	end
	else if (r_enable_1 && r_addr_1 == w_addr && w_enable)
		rdata1 <= w_data
	else if (r_enable_1)
		rdata1 <= regs[r_addr_1];
	else
		rdata1 <= `ZeroWord;
	end
end

always @ (*)
begin
	if (rst)
	begin
		rdata2 <= `ZeroWord;
	end
	else if (r_enable_2 && r_addr_2 == w_addr && w_enable)
		rdata2 <= w_data
	else if (r_enable_2)
		rdata2 <= regs[r_addr_2];
	else
		rdata2 <= `ZeroWord;
	end
end


endmodule