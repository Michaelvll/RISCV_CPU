`ifndef _pc_reg
`define _pc_reg

`include "Defines.vh"
`include "IDInstDef.vh"

module PC_reg (
    input wire 					clk,
    input wire					rst,

    output reg [`InstAddrBus]	pc,
	
	input wire[5:0]				stall,

	input wire					ex_b_flag_i,
	input wire[`InstAddrBus]	ex_b_target_addr_i,

	input wire					id_b_flag_i,
	input wire[`InstAddrBus]	id_b_target_addr_i
);

initial
begin
	pc	<=	`ZeroWord;
end

always @(posedge clk) 
begin
// $display("hello, world!");
	if (rst)
		pc <= `ZeroWord;
	else if (!stall[0])
	begin
		if (ex_b_flag_i)
			pc	<=	ex_b_target_addr_i;
		else if (id_b_flag_i)
			pc	<=	id_b_target_addr_i;
		else 
			pc <= pc + 32'h4;
	end
end

endmodule

`endif