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
reg               next_jump;
initial
begin
	pc	    	<=	`ZeroWord;
    next_pc 	<=  32'd4;
    next_jump   <=	1'b0;
end

always@(*)
begin
	if (ex_b_flag_i)
		next_pc			=	ex_b_target_addr_i;
	else if (id_b_flag_i)
		next_pc			=	id_b_target_addr_i;
	else if (!next_jump)
		next_pc			=	pc + 32'd4;
end

always @(posedge clk) 
begin
// $display("hello, world!");
	if (rst)
		pc 				= `ZeroWord;
	else 
	begin
        if (ex_b_flag_i)
        begin
            next_jump   =  1'b1;
        end
        else if (id_b_flag_i)
        begin
            next_jump   =  1'b1;
        end

		if (!stall[0])
		begin
			// pc  <=  next_pc;
            pc  		=  next_pc;
            next_jump	=  1'b0;
		end
	end
end

endmodule

`endif