`ifndef _EX
`define _EX
`include "Defines.vh"
`include "IDInstDef.vh"
`include "ALUInstDef.vh"

module EX(
	input wire rst,
	
	input wire[`AluOpBus]		aluop_i,
	input wire[`AluOutSelBus]	alusel_i,
	input wire[`RegBus]			r1_data_i,
	input wire[`RegBus]			r2_data_i,
	input wire					w_enable_i,
	input wire[`RegAddrBus]		w_addr_i	,

	output reg 					w_enable_o,
	output reg[`RegAddrBus]		w_addr_o,
	output reg[`RegBus]			w_data_o
);

	reg[`RegBus]	logicout;
	reg[`RegBus]	shiftres;

// ============ ALU logic part =====================
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
			`EX_XOR_OP:
			begin
				logicout	<=	r1_data_i ^ r2_data_i;
			end
			`EX_AND_OP:
			begin
				logicout	<=	r1_data_i & r2_data_i;
			end


			default:
			begin
				logicout	<=	`ZeroWord;
			end
		endcase
	end	
end

// ============ ALU shift part =====================
always @ (*)
begin
	if (rst)
		shiftres	<=	`ZeroWord;
	else 
	begin
		case (aluop_i)
			`EX_SLL_OP:
			begin
				shiftres	<=	r1_data_i << r2_data_i[4:0];
			end
			`EX_SRL_OP:
			begin
				shiftres	<=	r1_data_i  >> r2_data_i[4:0];
			end
			`EX_SRA_OP:
			begin
				shiftres	<=	({32{r1_data_i[31]}} << (6'd32 - {1'b0,r2_data_i[4:0]})) | r1_data_i >> r2_data_i[4:0];
			end


			default:
			begin
				shiftres	<=	`ZeroWord;
			end
		endcase
	end	
end


// =========== ALU prepare write back ==================

always @ (*)
begin
	if (rst)
	begin
		w_enable_o		<=	`WriteDisable;
		w_addr_o		<=	`ZeroWord;
		w_data_o		<=	`ZeroWord;
	end
	else
	begin
		w_enable_o	<=	w_enable_i;
		w_addr_o	<=	w_addr_i;
		case (alusel_i)
			`EX_RES_LOGIC:
			begin
				w_data_o	<=	logicout;
			end
			`EX_RES_SHIFT:
			begin
				w_data_o	<=	shiftres;
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