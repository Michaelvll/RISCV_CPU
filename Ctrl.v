module Ctrl(
	input wire 			rst,

	input wire			if_stall_req_i,
	input wire			id_stall_req_i,
	input wire			ex_stall_req_i,
	input wire			me_stall_req_i,
	input wire			wb_stall_req_i,

	output reg[5:0]		stall
);

	always @(*)
	begin
		if (rst)
		begin
			stall	<=	6'b000000;
		end
		else if (wb_stall_req_i)
			stall	<=	6'b111111;
		else if (me_stall_req_i)
			stall	<=	6'b011111;
		else if (ex_stall_req_i)
			stall	<=	6'b001111;
		else if (id_stall_req_i)
			stall	<=	6'b000111;
		else if (if_stall_req_i)
			stall	<=	6'b000011;
		else 
			stall	<=	6'b000000;
	end


endmodule