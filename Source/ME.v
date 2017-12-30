`ifndef _ME
`define _ME
`include "Defines.vh"
`include "IDInstDef.vh"

module ME(
	input wire rst,

	input wire				w_enable_i,
	input wire[`RegAddrBus]	w_addr_i,
	input wire[`RegBus]		w_data_i,

	output reg 				w_enable_o,
	output reg[`RegAddrBus]	w_addr_o,
	output reg[`RegBus]		w_data_o,

	output	reg				stall_req_o,

	input wire[`AluOpBus]	aluop_i,
	input wire[`RegBus]		ram_addr_i,

	output reg				ram_r_enable_o,
	input wire[`RegBus]		ram_r_data_i,
	output reg				ram_w_enable_o,
	output reg[3:0]			ram_w_mask_o,
	output reg[`RegBus]		ram_w_data_o,
	output reg[`RegBus]		ram_addr_o,

	input wire				ram_busy,
	input wire				ram_done
);

always @(*)
begin
	if (rst)
	begin
		w_addr_o		<=	`NOPRegAddr;
		w_data_o		<=	`ZeroWord;
	end
	else if (aluop_i == `ME_NOP_OP)
	begin
		w_addr_o		<=	w_addr_i;
		w_data_o		<=	w_data_i;
	end
	else if (ram_done)
	begin
		case (aluop_i)
			`EX_LB_OP:
			begin
				case (ram_addr_i[1:0])
					2'b11:	begin
						w_data_o	<=	{{24{ram_r_data_i[31]}},ram_r_data_i[31:24]};
					end
					2'b10:	begin
						w_data_o	<=	{{24{ram_r_data_i[23]}},ram_r_data_i[23:16]};
					end
					2'b01:	begin
						w_data_o	<=	{{24{ram_r_data_i[15]}},ram_r_data_i[15:8]};
					end
					2'b00:	begin
						w_data_o	<=	{{24{ram_r_data_i[7]}},ram_r_data_i[7:0]};
					end
					default:	begin
						w_data_o	<=	`ZeroWord;
					end
				endcase
			end

			`EX_LH_OP:
			begin
				case (ram_addr_i[1:0])
					2'b10:	begin
						w_data_o	<=	{{16{ram_r_data_i[31]}},ram_r_data_i[31:16]};
					end
					2'b00:	begin
						w_data_o	<=	{{16{ram_r_data_i[15]}},ram_r_data_i[15:0]};
					end
					default:	begin
						w_data_o	<=	`ZeroWord;
					end
				endcase
			end	
			`EX_LW_OP:
			begin
				w_data_o		<=	ram_r_data_i;
			end
			`EX_LBU_OP:
			begin
				case (ram_addr_i[1:0])
					2'b11:	begin
						w_data_o	<=	{{24{1'b0}},ram_r_data_i[31:24]};
					end
					2'b10:	begin
						w_data_o	<=	{{24{1'b0}},ram_r_data_i[23:16]};
					end
					2'b01:	begin
						w_data_o	<=	{{24{1'b0}},ram_r_data_i[15:8]};
					end
					2'b00:	begin
						w_data_o	<=	{{24{1'b0}},ram_r_data_i[7:0]};
					end
					default:	begin
						w_data_o	<=	`ZeroWord;
					end
				endcase				
			end

			`EX_LHU_OP:
			begin
				case (ram_addr_i[1:0])
					2'b10:	begin
						w_data_o	<=	{{16{1'b0}},ram_r_data_i[31:16]};
					end
					2'b00:	begin
						w_data_o	<=	{{16{1'b0}},ram_r_data_i[15:0]};
					end
					default:	begin
						w_data_o	<=	`ZeroWord;
					end
				endcase				
			end
		default:
		begin
			w_data_o        =   w_data_i;
		end
		endcase
	end
end

always @(*)
begin
	if (rst)
	begin
		stall_req_o 	<=	1'b0;
		w_enable_o		<=	`WriteDisable;
		
		ram_r_enable_o	<=	1'b0;
		ram_w_enable_o	<=	`WriteDisable;
		ram_w_mask_o	<=	4'b0000;
		ram_w_data_o	<=	`ZeroWord;
		ram_addr_o		<=	`ZeroWord;
	end
	else if (aluop_i == `ME_NOP_OP)
	begin
		stall_req_o 	<=	1'b0;
		w_enable_o		<=	w_enable_i;
		ram_r_enable_o	<=	1'b0;
		ram_w_enable_o	<=	`WriteDisable;
		ram_w_mask_o	<=	4'b0000;
		ram_w_data_o	<=	`ZeroWord;
		ram_addr_o		<=	`ZeroWord;
	end
	else if (!ram_busy && !stall_req_o)
	begin
		stall_req_o		<=	1'b1;
		case(aluop_i)
			`EX_LB_OP,`EX_LH_OP,`EX_LW_OP,`EX_LBU_OP,`EX_LHU_OP:
			begin
					ram_r_enable_o	<=	1'b1;
					ram_w_enable_o	<=	`WriteDisable;
					ram_addr_o		<=	{ram_addr_i[31:2], 2'h0};
					ram_w_data_o	<=	`ZeroWord;
			end
			
			`EX_SB_OP:
			begin
				ram_r_enable_o	<=	1'b0;
				ram_w_enable_o	<=	`WriteEnable;
				ram_addr_o		<=	ram_addr_i;
				ram_w_data_o	<=	{w_data_i[7:0],w_data_i[7:0],w_data_i[7:0],w_data_i[7:0]};
				case (ram_addr_i[1:0])
					2'b00:	begin
						ram_w_mask_o	<=	4'b0001;
					end
					2'b01:	begin
						ram_w_mask_o	<=	4'b0010;
					end
					2'b10:	begin
						ram_w_mask_o	<=	4'b0100;
					end
					2'b11:	begin
						ram_w_mask_o	<=	4'b1000;	
					end
					default:	begin
						ram_w_mask_o	<=	4'b0000;
					end
				endcase				
			end
			
			`EX_SH_OP:
			begin
				ram_r_enable_o	<=	1'b0;
				ram_w_enable_o	<=	`WriteEnable ;
				ram_addr_o		<=	ram_addr_i;
				ram_w_data_o	<=	{w_data_i[15:0],w_data_i[15:0]};
				case (ram_addr_i[1:0])
					2'b00:	begin
						ram_w_mask_o	<=	4'b0011;
					end
					2'b10:	begin
						ram_w_mask_o	<=	4'b1100;
					end
					default:	begin
						ram_w_mask_o	<=	4'b0000;
					end
				endcase		
			end

			`EX_SW_OP:
			begin
				ram_r_enable_o	<=	1'b0;
				ram_w_enable_o	<=	`WriteEnable;
				ram_addr_o		<=	ram_addr_i;
				ram_w_data_o		<=	w_data_i;
				ram_w_mask_o		<=	4'b1111;	
			end
			default:
			begin
				w_enable_o		<=	`WriteDisable;
				ram_r_enable_o	<=	1'b0;
				ram_w_enable_o	<=	`WriteDisable;
				ram_w_mask_o	<=	4'b0000;
				ram_w_data_o	<=	`ZeroWord;
				ram_addr_o		<=	`ZeroWord;
				stall_req_o 	<=	1'b0;
			end
		endcase
	end
	else if (ram_busy && !stall_req_o)
		stall_req_o		<=	1'b1;
	else if (ram_busy && stall_req_o)
		stall_req_o		<=	1'b1;
	else if (!ram_busy && stall_req_o)
		stall_req_o		<=	1'b0;


end

/*
always @ (*)
begin
	if (rst)
	begin
		w_enable_o		<=	`WriteDisable;
		w_addr_o		<=	`NOPRegAddr;
		w_data_o		<=	`ZeroWord;
		ram_r_enable_o	<=	1'b0;
		ram_w_enable_o	<=	`WriteDisable;
		ram_w_mask_o	<=	4'b0000;
		ram_w_data_o	<=	`ZeroWord;
		ram_addr_o		<=	`ZeroWord;
		stall_req_o 	<=	1'b0;
	end
	else if (!ram_busy)
	begin
		stall_req_o		<=	1'b0;
		w_enable_o		<=	w_enable_i;
		w_addr_o		<=	w_addr_i;
		case (aluop_i)
			`EX_LB_OP:
			begin
				ram_r_enable_o	<=	1'b1;
				ram_w_enable_o	<=	`WriteDisable;
				ram_addr_o		<=	ram_addr_i;
				ram_w_data_o	<=	`ZeroWord;
				case (ram_addr_i[1:0])
					2'b11:	begin
						w_data_o	<=	{{24{ram_r_data_i[31]}},ram_r_data_i[31:24]};
						ram_w_mask_o	<=	4'b1000;
					end
					2'b10:	begin
						w_data_o	<=	{{24{ram_r_data_i[23]}},ram_r_data_i[23:16]};
						ram_w_mask_o	<=	4'b0100;
					end
					2'b01:	begin
						w_data_o	<=	{{24{ram_r_data_i[15]}},ram_r_data_i[15:8]};
						ram_w_mask_o	<=	4'b0010;
					end
					2'b00:	begin
						w_data_o	<=	{{24{ram_r_data_i[7]}},ram_r_data_i[7:0]};
						ram_w_mask_o	<=	4'b0001;
					end
					default:	begin
						w_data_o	<=	`ZeroWord;
					end
				endcase
			end

			`EX_LH_OP:
			begin
				ram_r_enable_o	<=	1'b1;
				ram_w_enable_o	= `WriteDisable;
				ram_addr_o		= ram_addr_i;
				ram_w_data_o		<=	`ZeroWord;
				case (ram_addr_i[1:0])
					2'b10:	begin
						w_data_o	<=	{{16{ram_r_data_i[31]}},ram_r_data_i[31:16]};
						ram_w_mask_o	<=	4'b1100;
					end
					2'b00:	begin
						w_data_o	<=	{{16{ram_r_data_i[15]}},ram_r_data_i[15:0]};
						ram_w_mask_o	<=	4'b0011;
					end
					default:	begin
						w_data_o	<=	`ZeroWord;
					end
				endcase
			end	
			`EX_LW_OP:
			begin
				ram_r_enable_o	<=	1'b1;
				ram_w_enable_o	<=	`WriteDisable;
				ram_addr_o		<=	ram_addr_i;
				ram_w_data_o	<=	`ZeroWord;				
				w_data_o		<=	ram_r_data_i;
				ram_w_mask_o		<=	4'b0000;
			end
			`EX_LBU_OP:
			begin
				ram_r_enable_o	<=	1'b1;
				ram_w_enable_o	<=	`WriteDisable;
				ram_addr_o		<=	ram_addr_i;
				ram_w_data_o		<=	`ZeroWord;			
				case (ram_addr_i[1:0])
					2'b11:	begin
						w_data_o	<=	{{24{1'b0}},ram_r_data_i[31:24]};
						ram_w_mask_o	<=	4'b1000;
					end
					2'b10:	begin
						w_data_o	<=	{{24{1'b0}},ram_r_data_i[23:16]};
						ram_w_mask_o	<=	4'b0100;
					end
					2'b01:	begin
						w_data_o	<=	{{24{1'b0}},ram_r_data_i[15:8]};
						ram_w_mask_o	<=	4'b0010;
					end
					2'b00:	begin
						w_data_o	<=	{{24{1'b0}},ram_r_data_i[7:0]};
						ram_w_mask_o	<=	4'b0001;
					end
					default:	begin
						w_data_o	<=	`ZeroWord;
					end
				endcase				
			end

			`EX_LHU_OP:
			begin
				ram_r_enable_o	<=	1'b1;
				ram_w_enable_o	<=	`WriteDisable;
				ram_addr_o		<=	ram_addr_i;
				ram_w_data_o	<=	`ZeroWord;				
				case (ram_addr_i[1:0])
					2'b10:	begin
						w_data_o	<=	{{16{1'b0}},ram_r_data_i[31:16]};
						ram_w_mask_o	<=	4'b1100;
					end
					2'b00:	begin
						w_data_o	<=	{{16{1'b0}},ram_r_data_i[15:0]};
						ram_w_mask_o	<=	4'b0011;
					end
					default:	begin
						w_data_o	<=	`ZeroWord;
						ram_w_mask_o	<=	4'b0000;
						
					end
				endcase				
			end

			`EX_SB_OP:
			begin
				ram_r_enable_o	<=	1'b0;
				ram_w_enable_o	<=	`WriteEnable;
				ram_addr_o		<=	ram_addr_i;
				ram_w_data_o	<=	{w_data_i[7:0],w_data_i[7:0],w_data_i[7:0],w_data_i[7:0]};
				case (ram_addr_i[1:0])
					2'b00:	begin
						ram_w_mask_o	<=	4'b0001;
					end
					2'b01:	begin
						ram_w_mask_o	<=	4'b0010;
					end
					2'b10:	begin
						ram_w_mask_o	<=	4'b0100;
					end
					2'b11:	begin
						ram_w_mask_o	<=	4'b1000;	
					end
					default:	begin
						ram_w_mask_o	<=	4'b0000;
					end
				endcase				
			end
			
			`EX_SH_OP:
			begin
				ram_r_enable_o	<=	1'b0;
				ram_w_enable_o	<=	`WriteEnable ;
				ram_addr_o		<=	ram_addr_i;
				ram_w_data_o	<=	{w_data_i[15:0],w_data_i[15:0]};
				case (ram_addr_i[1:0])
					2'b00:	begin
						ram_w_mask_o	<=	4'b0011;
					end
					2'b10:	begin
						ram_w_mask_o	<=	4'b1100;
					end
					default:	begin
						ram_w_mask_o	<=	4'b0000;
					end
				endcase		
			end

			`EX_SW_OP:
			begin
				ram_r_enable_o	<=	1'b0;
				ram_w_enable_o	<=	`WriteEnable;
				ram_addr_o		<=	ram_addr_i;
				ram_w_data_o		<=	w_data_i;
				ram_w_mask_o		<=	4'b1111;	
			end

			default:
			begin
				w_data_o		<=	w_data_i;
				ram_r_enable_o	<=	1'b0;
				ram_w_enable_o	<=	`WriteDisable;
				ram_addr_o		<=	`ZeroWord;
				ram_w_data_o	<=	`ZeroWord;
				ram_w_mask_o	<=	4'b0000;
			end
		endcase
	end
end 
*/

endmodule

`endif