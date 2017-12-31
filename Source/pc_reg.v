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
reg[`InstAddrBus] next_pc;
initial
begin
	pc	    <=	`ZeroWord;
    next_pc <=  32'd4;
end

always@(*)
begin
    next_pc <=  pc + 32'd4;
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
			// pc  <=  next_pc;
            pc  <=  next_pc;
	end
end

endmodule

`endif