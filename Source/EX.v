`ifndef _EX
`define _EX
`include "Defines.vh"
`include "IDInstDef.vh"
`include "ALUInstDef.vh"

module EX(
	input wire rst,
	
	input wire[`InstAddrBus]	pc_i, // In order to put addr calculation into ex
	input wire[`AluOpBus]		aluop_i,
	input wire[`AluOutSelBus]	alusel_i,
	input wire[`RegBus]			r1_data_i,
	input wire[`RegBus]			r2_data_i,
	input wire					w_enable_i,
	input wire[`RegAddrBus]		w_addr_i,

	output reg 					w_enable_o,
	output reg[`RegAddrBus]		w_addr_o,
	output reg[`RegBus]			w_data_o,

	output reg					stall_req_o,
	input wire[`RegBus]			offset_i,

	//	For jumps and branches
	output reg 					b_flag_o,
	output reg[`InstAddrBus]	b_target_addr_o,

	// For load and store
	output wire[`AluOpBus]		aluop_o,
	output wire[`RegBus]		mem_addr_o,
	// The data for store will be in w_data_o

	output wire					is_ld
);
always@(*)
	stall_req_o		<=		1'b0;


reg[`RegBus]		logic_res;
reg[`RegBus]		shift_res;
reg[`RegBus]		arith_res;
reg[`RegBus]		J_B_res;

wire[`RegBus]		r2_data_i_mux;
wire[`RegBus]		sum_res;
wire				lt_res;
wire				gt_res;
wire				eq_res;
wire[`InstAddrBus]	pc_plus_4;
wire[`InstAddrBus]	pc_plus_offset;

// ============ ALU Data prepare part ================


assign sum_res = (aluop_i == `EX_SUB_OP ? 
						r1_data_i - r2_data_i: r1_data_i + r2_data_i);

assign lt_res = ((aluop_i == `EX_SLT_OP || aluop_i == `EX_BLT_OP ||
				aluop_i == `EX_BGE_OP)? 
				$signed(r1_data_i) < $signed(r2_data_i):
				r1_data_i < r2_data_i);

assign eq_res = (r1_data_i == r2_data_i);

assign pc_plus_4 = pc_i + 4;

assign pc_plus_offset = pc_i + offset_i;

// ============ ALU LOAD_STORE part ================

assign aluop_o = ((aluop_i == `EX_LB_OP) || 
				(aluop_i == `EX_LH_OP) ||
				(aluop_i == `EX_LW_OP) ||
				(aluop_i == `EX_LBU_OP)||
				(aluop_i == `EX_LHU_OP)||
				(aluop_i == `EX_SB_OP) ||
				(aluop_i == `EX_SH_OP) ||
				(aluop_i == `EX_SW_OP) ) ? aluop_i : `ME_NOP_OP;

assign mem_addr_o = r1_data_i + offset_i;

assign is_ld = ((aluop_i == `EX_LB_OP) || 
				(aluop_i == `EX_LH_OP) ||
				(aluop_i == `EX_LW_OP) ||
				(aluop_i == `EX_LBU_OP)||
				(aluop_i == `EX_LHU_OP)) ? 1'b1 : 1'b0;

// ============ ALU J_B part ================

always @ (*)
begin
	if (rst) 
	begin
		J_B_res		<=	`ZeroWord;
		b_flag_o	<=	1'b0;
	end
	else
	begin
		case (aluop_i)
			`EX_JAL_OP:
			begin
				J_B_res				<=	pc_plus_4;
			end
			
			`EX_JALR_OP:
			begin
`ifndef ID_JALR
				b_flag_o			<=	1'b1;
				b_target_addr_o		<=	{sum_res[31:1], 1'h0};
`endif //ID_JALR
				J_B_res				<=	pc_plus_4;
			end
`ifndef ID_BRANCHES
			`EX_BEQ_OP:
			begin
				b_flag_o			<=	eq_res;
				b_target_addr_o		<=	pc_plus_offset;
			end

			`EX_BNE_OP:
			begin
				b_flag_o			<= ~eq_res;
				b_target_addr_o		<= pc_plus_offset;
			end

			`EX_BLT_OP,`EX_BLTU_OP:
			begin
				b_flag_o			<=	lt_res;
				b_target_addr_o		<=	pc_plus_offset;
			end

			`EX_BGE_OP,`EX_BGEU_OP:
			begin
				b_flag_o			<=	~lt_res;
				b_target_addr_o		<=	pc_plus_offset;
			end
`endif //ID_BRANCHES
			default:
			begin
				b_flag_o			<=	1'b0;
				b_target_addr_o		<=	`ZeroWord;
				J_B_res				<=	`ZeroWord;
			end	
		endcase
	end

end


// ============ ALU Arithmatic part ================

always @ (*) 
begin
	if (rst) 
	begin
		arith_res	<=	`ZeroWord;
	end
	else 
	begin
		case (aluop_i)
			`EX_SLT_OP, `EX_SLTU_OP:
			begin
				arith_res	<=	{31'h0, lt_res};
			end

			`EX_ADD_OP, `EX_SUB_OP: 
			begin
				arith_res	<=	sum_res;			
			end
			
			`EX_AUIPC_OP:
			begin
			  	arith_res	<=	pc_plus_offset;
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
	else if (w_enable_i && w_addr_i == `ZeroWord)
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
			`EX_RES_J_B:
			begin
				w_data_o	<=	J_B_res;
			end
			`EX_RES_LD_ST:
			begin
				w_data_o	<=	r2_data_i;
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