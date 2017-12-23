`ifndef _IF_ID
`define	_IF_ID
`include "Defines.vh"
`include "IDInstDef.vh"

module IF_ID(
	input wire	clk,
	input wire	rst,

	input wire[`InstAddrBus]	if_pc,
	input wire[`InstBus]		if_inst,

	output reg[`InstAddrBus]	id_pc,
	output reg[`InstBus]		id_inst,

	input wire[5:0]				stall,

	input wire					ex_b_flag,
	input wire					id_b_flag
);

always @ (posedge clk)
begin
	if (rst)
	begin
		id_pc   <=  `ZeroWord;
		id_inst <=  `ZeroWord;
	end
	else if (id_b_flag || ex_b_flag)
	begin
		id_pc 	<=	`ZeroWord;
		id_inst	<=	`ZeroWord;
	end
	else if(stall[1] && !stall[2])
	begin
		id_pc 	<=	`ZeroWord;
		id_inst	<=	`ZeroWord;
	end
	else if (!stall[1])
	begin
		id_pc	<=	if_pc;
		id_inst	<=	if_inst;
	end
end

endmodule

`endif