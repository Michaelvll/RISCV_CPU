`ifndef _IF_ID
`define	_IF_ID
`include "Defines.vh"

module IF_ID(
	input wire	clk,
	input wire	rst,

	input wire[`InstAddrBus]	if_pc,
	input wire[`InstBus]		if_inst,

	output reg[`InstAddrBus]	id_pc,
	output reg[`InstBus]		id_inst
);

always @ (posedge clk)
begin
	if (rst)
	begin
		id_pc   <=  `ZeroWord;
		id_inst <=  `ZeroWord;
	end
	else
	begin
		id_pc	<=	if_pc;
		id_inst	<=	if_inst;
	end
end

endmodule

`endif