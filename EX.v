`ifndef _EX
`define _EX
`include "Defines.vh"

module EX(
	input wire rst,
	
	input wire[`AluOpBus]	aluop_i,
	input wire[`AluSelBus]	alusel_i,
	input wire[`RegBus]		r1_data_i,
	input wire[`RegBus]		r2_data_i,
	input wire				w_enable_i,
	input wire[`RegAddrBus]	w_addr_i,

	output reg 				w_enable_o,
	output reg[`RegAddrBus]	w_addr_o,
	output reg[`RegBus]		w_data_o
);

	reg[`RegBus]	logicout;

// ============ ALU calculate part =====================
always @ (*)
begin
	if (rst)
		logicout	<=	`ZeroWord;
	else 
	begin
		case (aluop_i)
			`EX_OR_OP:
			begin
				logicout	<=	r1_data_i | r2_data_i;
			end
			default:
			begin
				logicout	<=	`ZeroWord;
			end
		endcase
	end	
end

// =========== ALU prepare write back ==================

always @ (*)
begin
	if (rst)
	begin
		w_enable_o	<=	`WriteDisable;
		w_addr_o		<=	`ZeroWord;
		w_data_o	<=	`ZeroWord;
	end
	else
	begin
		w_enable_o	<=	w_enable_i;
		w_addr_o		<=	w_addr_i;
		case (alusel_i)
			`EX_RES_LOGIC:
			begin
				w_data_o	<=	logicout;
			end
			default:
			begin
				w_data_o	<=	`ZeroWord;
			end
		endcase
	end
end





endmodule

`endif