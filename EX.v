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
	input wire[`RegAddrBus]		w_addr_i,

	output reg 					w_enable_o,
	output reg[`RegAddrBus]		w_addr_o,
	output reg[`RegBus]			w_data_o
);

reg[`RegBus]	logic_res;
reg[`RegBus]	shift_res;
reg[`RegBus]	arith_res;

// ============ ALU Arithmatic part ================
wire[`RegBus]	r2_data_i_mux;
wire[`RegBus]	sum_res;
wire			lt_res;

// assign sum_res = (aluop_i == `EX_SUB_OP ? 
// 						r1_data_i - r2_data_i: r1_data_i + r2_data_i);

// assign sum_res = r1_data_i + r2_data_i_mux;

// assign lt_res = (aluop_i == `EX_SLT_OP ? 
// 				$signed(r1_data_i) < $signed(r2_data_i): r1_data_i < r2_data_i);

always @ (*) 
begin
	if (rst) 
	begin
		arith_res	<=	`ZeroWord;
	end
	else 
	begin
		case (aluop_i)
			`EX_SLT_OP:
			begin
				arith_res	<=	{31'h0, {$signed(r1_data_i) < $signed(r2_data_i)}};
			end

			`EX_SLTU_OP:
			begin
				arith_res	<=	{31'h0, {r1_data_i < r2_data_i}};
			end

			`EX_ADD_OP: 
			begin
				arith_res	<=	r1_data_i + r2_data_i;			
			end
			
			`EX_SUB_OP:
			begin
				arith_res	<=	r1_data_i - r2_data_i;
			end

			default: 
			begin
				arith_res	<=	`ZeroWord;
			end
		endcase
	end
end



// ============ ALU logic part =====================
always @ (*)
begin
	if (rst)
		logic_res	<=	`ZeroWord;
	else 
	begin
		case (aluop_i)
			`EX_OR_OP:
			begin
				logic_res	<=	r1_data_i | r2_data_i;
			end
			`EX_XOR_OP:
			begin
				logic_res	<=	r1_data_i ^ r2_data_i;
			end
			`EX_AND_OP:
			begin
				logic_res	<=	r1_data_i & r2_data_i;
			end


			default:
			begin
				logic_res	<=	`ZeroWord;
			end
		endcase
	end	
end

// ============ ALU shift part =====================
always @ (*)
begin
	if (rst)
		shift_res	<=	`ZeroWord;
	else 
	begin
		case (aluop_i)
			`EX_SLL_OP:
			begin
				shift_res	<=	r1_data_i << r2_data_i[4:0];
			end
			`EX_SRL_OP:
			begin
				shift_res	<=	r1_data_i  >> r2_data_i[4:0];
			end
			`EX_SRA_OP:
			begin
				shift_res	<=	({32{r1_data_i[31]}} << (6'd32 - {1'b0,r2_data_i[4:0]})) | r1_data_i >> r2_data_i[4:0];
			end


			default:
			begin
				shift_res	<=	`ZeroWord;
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
				w_data_o	<=	logic_res;
			end
			`EX_RES_SHIFT:
			begin
				w_data_o	<=	shift_res;
			end
			`EX_RES_ARITH:
			begin
				w_data_o	<=	arith_res;
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