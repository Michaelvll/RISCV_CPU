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
	input wire[`RegBus]		mem_addr_i,

	input wire[`RegBus]		mem_r_data_i,
	output reg				mem_w_enable_o,
	output reg[3:0]			mem_sel_o,
	output reg[`RegBus]		mem_w_data_o,
	output reg[`RegBus]		mem_addr_o,
	output reg				mem_ce_o

);

always @(*)
begin
	stall_req_o = 1'b0;
end

always @ (*)
begin
	if (rst)
	begin
		w_enable_o		<=	`WriteDisable;
		w_addr_o		<=	`NOPRegAddr;
		w_data_o		<=	`ZeroWord;
		mem_w_enable_o	<=	`WriteDisable;
		mem_sel_o		<=	4'b0000;
		mem_w_data_o		<=	`ZeroWord;
		mem_addr_o		<=	`ZeroWord;
		mem_ce_o		<=	`ChipDisable;
	end
	else
	begin
		w_enable_o		<=	w_enable_i;
		w_addr_o		<=	w_addr_i;
		case (aluop_i)
			`EX_LB_OP:
			begin
				mem_w_enable_o	<=	`WriteDisable;
				mem_ce_o		<=	`ChipEnable;
				mem_addr_o		<=	mem_addr_i;
				mem_w_data_o		<=	`ZeroWord;
				case (mem_addr_i[1:0])
					2'b00:	begin
						w_data_o	<=	{{24{mem_r_data_i[31]}},mem_r_data_i[31:24]};
						mem_sel_o	<=	4'b0001;
					end
					2'b01:	begin
						w_data_o	<=	{{24{mem_r_data_i[23]}},mem_r_data_i[23:16]};
						mem_sel_o	<=	4'b0010;
					end
					2'b10:	begin
						w_data_o	<=	{{24{mem_r_data_i[15]}},mem_r_data_i[15:8]};
						mem_sel_o	<=	4'b0100;
					end
					2'b11:	begin
						w_data_o	<=	{{24{mem_r_data_i[7]}},mem_r_data_i[7:0]};
						mem_sel_o	<=	4'b1000;
					end
					default:	begin
						w_data_o	<=	`ZeroWord;
					end
				endcase
			end

			`EX_LH_OP:
			begin
				mem_w_enable_o	<= `WriteDisable;
				mem_ce_o		<= `ChipEnable;
				mem_addr_o		<= mem_addr_i;
				mem_w_data_o		<=	`ZeroWord;
				case (mem_addr_i[1:0])
					2'b00:	begin
						w_data_o	<=	{{16{mem_r_data_i[31]}},mem_r_data_i[31:16]};
						mem_sel_o	<=	4'b0011;
					end
					2'b10:	begin
						w_data_o	<=	{{16{mem_r_data_i[15]}},mem_r_data_i[15:0]};
						mem_sel_o	<=	4'b1100;
					end
					default:	begin
						w_data_o	<=	`ZeroWord;
					end
				endcase
			end	
			`EX_LW_OP:
			begin
				mem_w_enable_o	<=	`WriteDisable;
				mem_ce_o		<=	`ChipEnable;
				mem_addr_o		<=	mem_addr_i;
				mem_w_data_o		<=	`ZeroWord;				
				w_data_o		<=	mem_r_data_i;
				mem_sel_o		<=	4'b1111;
			end
			`EX_LBU_OP:
			begin
				mem_w_enable_o	<=	`WriteDisable;
				mem_ce_o		<=	`ChipEnable;
				mem_addr_o		<=	mem_addr_i;
				mem_w_data_o		<=	`ZeroWord;			
				case (mem_addr_i[1:0])
					2'b00:	begin
						w_data_o	<=	{{24{1'b0}},mem_r_data_i[31:24]};
						mem_sel_o	<=	4'b0001;
					end
					2'b01:	begin
						w_data_o	<=	{{24{1'b0}},mem_r_data_i[23:16]};
						mem_sel_o	<=	4'b0010;
					end
					2'b10:	begin
						w_data_o	<=	{{24{1'b0}},mem_r_data_i[15:8]};
						mem_sel_o	<=	4'b0100;
					end
					2'b11:	begin
						w_data_o	<=	{{24{1'b0}},mem_r_data_i[7:0]};
						mem_sel_o	<=	4'b1000;
					end
					default:	begin
						w_data_o	<=	`ZeroWord;
					end
				endcase				
			end

			`EX_LHU_OP:
			begin
				mem_w_enable_o	<=	`WriteDisable;
				mem_ce_o		<=	`ChipEnable;
				mem_addr_o		<=	mem_addr_i;
				mem_w_data_o	<=	`ZeroWord;				
				case (mem_addr_i[1:0])
					2'b00:	begin
						w_data_o	<=	{{16{1'b0}},mem_r_data_i[31:16]};
						mem_sel_o	<=	4'b0011;
					end
					2'b10:	begin
						w_data_o	<=	{{16{1'b0}},mem_r_data_i[15:0]};
						mem_sel_o	<=	4'b1100;
					end
					default:	begin
						w_data_o	<=	`ZeroWord;
						mem_sel_o	<=	4'b0000;
						
					end
				endcase				
			end

			`EX_SB_OP:
			begin
				mem_w_enable_o	<=	`WriteEnable;
				mem_ce_o		<=	`ChipEnable;
				mem_addr_o		<=	mem_addr_i;
				mem_w_data_o		<=	{w_data_i[7:0],w_data_i[7:0],w_data_i[7:0],w_data_i[7:0]};
				case (mem_addr_i[1:0])
					2'b00:	begin
						mem_sel_o	<=	4'b0001;
					end
					2'b01:	begin
						mem_sel_o	<=	4'b0010;
					end
					2'b10:	begin
						mem_sel_o	<=	4'b0100;
					end
					2'b11:	begin
						mem_sel_o	<=	4'b1000;	
					end
					default:	begin
						mem_sel_o	<=	4'b0000;
					end
				endcase				
			end
			
			`EX_SH_OP:
			begin
				mem_w_enable_o	<=	`WriteEnable ;
				mem_ce_o		<=	`ChipEnable;
				mem_addr_o		<=	mem_addr_i;
				mem_w_data_o		<=	{w_data_i[15:0],w_data_i[15:0]};
				case (mem_addr_i[1:0])
					2'b00:	begin
						mem_sel_o	<=	4'b0011;
					end
					2'b10:	begin
						mem_sel_o	<=	4'b1100;
					end
					default:	begin
						mem_sel_o	<=	4'b0000;
					end
				endcase		
			end

			`EX_SW_OP:
			begin
				mem_w_enable_o	<=	`WriteEnable;
				mem_ce_o		<=	`ChipEnable;
				mem_addr_o		<=	mem_addr_i;
				mem_w_data_o		<=	w_data_i;
				mem_sel_o		<=	4'b1111;	
			end

			default:
			begin
				w_data_o		<=	w_data_i;
				mem_w_enable_o	<=	`WriteDisable;
				mem_addr_o		<=	`ZeroWord;
				mem_w_data_o	<=	`ZeroWord;
				mem_sel_o		<=	4'b0000;
				mem_ce_o		<=	`ChipDisable;
			end
		endcase
	end
end

endmodule

`endif