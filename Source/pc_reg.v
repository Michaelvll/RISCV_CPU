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
reg[1:0]          next_jump;
reg[`InstAddrBus] target_addr;
initial
begin
	pc	    	<=	`ZeroWord;
    next_pc 	<=  32'd4;
    next_jump   <=	2'b00;
	target_addr <=	`ZeroWord;
end

always@(*)
begin
	if (rst)
	begin
		next_pc				=	32'd4;
	end
	else
	begin
		case (next_jump)
		2'b10:
		begin
			next_pc			=	target_addr;
		end
		2'b01:
		begin
			next_pc			=	target_addr;
		end
		default:
		begin
			next_pc			=	pc + 32'd4;
		end
	endcase
	end
end

always @(posedge clk) 
begin
// $display("hello, world!");
	if (rst)
	begin
		pc 					<= `ZeroWord;
		next_jump			<=	2'b00;
		target_addr			<=	`ZeroWord;
	end
	else 
	begin
        if (ex_b_flag_i)
        begin
			if (stall[0])
			begin
            	next_jump   <=  2'b10;
				target_addr	<=	ex_b_target_addr_i;
			end
			else
			begin
				next_jump	<=	2'b00;
            	pc  		<= 	ex_b_target_addr_i;
			end
        end
        else if (id_b_flag_i)
        begin
			if (stall[0])
			begin
            	next_jump   <=  2'b01;
				target_addr	<=	id_b_target_addr_i;
			end
			else
			begin
				next_jump	<=	2'b00;
				pc			<=	id_b_target_addr_i;
			end
        end
		else if (!stall[0])
		begin
			// pc  <=  next_pc;
            next_jump		<=  2'b00;
			target_addr		<=	`ZeroWord;
            pc  			<=  next_pc;
		end
	end
end

endmodule

`endif