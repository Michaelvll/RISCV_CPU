`ifndef _ID
`define _ID
`include "Defines.vh"
`include "IDInstDef.vh"
`include "ALUInstDef.vh"

module ID (
	input wire					rst,
	input wire[`InstAddrBus]	pc_i,
	input wire[`InstBus]		inst_i,

	// Read data from regfile
	input wire[`RegBus]		 	r1_data_i,
	input wire[`RegBus]		 	r2_data_i,

	output reg					r1_enable_o, // Enable read1 to regfile
	output reg					r2_enable_o, // Enable read2 to regfile
	output reg[`RegAddrBus]	 	r1_addr_o,
	output reg[`RegAddrBus]	 	r2_addr_o,

	// ifo. for EXE
	output reg[`AluOpBus]		aluop_o,
	output reg[`AluOutSelBus]	alusel_o,
	output reg[`RegBus]		 	r1_data_o,
	output reg[`RegBus]		 	r2_data_o,
	output reg					w_enable_o,
	output reg[`RegAddrBus]	 	w_addr_o,

	// Forwarding from ex
	input wire 					ex_w_enable_i,
	input wire[`RegAddrBus]		ex_w_addr_i,
	input wire[`RegBus]			ex_w_data_i,

	// Forwarding from mem
	input wire					mem_w_enable_i,
	input wire[`RegAddrBus]		mem_w_addr_i,
	input wire[`RegBus]			mem_w_data_i,

	output reg					stall_req_o,

	output reg[`InstAddrBus]	pc_o,
	output reg[`RegBus]			b_offset_o,

	output reg					b_flag_o,
	output reg[`InstAddrBus]	b_target_addr_o
);

reg instvalid;
reg[`RegBus] imm;

wire[6:0]		opcode;
wire[4:0]		rd;
wire[2:0]		funct3;
wire[4:0]		rs1;
wire[4:0]		rs2;
wire[6:0]		funct7;
wire[11:0]		imm_I;
wire[11:0]		imm_S;
wire[31:0]		imm_B;
wire[31:0]	 	imm_U;
wire[31:0]		imm_J;


assign opcode		=	inst_i[6:0];
assign rd			=	inst_i[11:7];
assign funct3		=	inst_i[14:12];
assign rs1			=	inst_i[19:15];
assign rs2			=	inst_i[24:20];
assign funct7		=	inst_i[31:25];
assign imm_I		=	inst_i[31:20];
assign imm_S		=	{inst_i[31:25], inst_i[11:7]};
assign imm_B		=	{{20{inst_i[31]}}, inst_i[7], 
							inst_i[30:25], inst_i[11:8],1'h0};
assign imm_U		=	{inst_i[31:12], 12'h0};
assign imm_J		=	{{12{inst_i[31]}}, inst_i[19:12],
							inst_i[20], inst_i[30:21],1'h0};

wire				b_flag;
wire[`InstAddrBus]	b_target_res;

assign b_target_res = (opcode == `OP_JAL)? imm_J + pc_i: imm_B + pc_i;

`ifdef ID_BRANCHES
// This part may cause lower speed
wire				lt_res;
wire				gt_res;
wire				eq_res;
assign lt_res = ((aluop_o == `EX_BLT_OP ||
				aluop_o == `EX_BGE_OP)? 
				$signed(r1_data_o) < $signed(r2_data_o):
				r1_data_o < r2_data_o);

assign eq_res = (r1_data_o == r2_data_o);
// end
`endif //ID_BRANCHES

`ifdef ID_JALR
// This part can be much slower than the id_branches
wire[`RegBus] sum_res;
assign sum_res = r1_data_o + {{20{imm_I[11]}}, imm_I};
//end
`endif //ID_JALR


always @(*)
begin
	case(opcode)
		`OP_JAL:
		begin
			b_flag_o		<=	1'b1;
			b_target_addr_o	<=	b_target_res;
		end
`ifdef ID_JALR
		`OP_JALR:
		begin
			b_flag_o		<=	1'b1;
			b_target_addr_o	<=	sum_res;
		end
`endif //ID_JALR

`ifdef ID_BRANCHES
// This part may cause lower speed
		`OP_BRANCH:
		begin
			case (funct3)
				`FUNCT3_BEQ:
				begin
					b_flag_o		<=	eq_res;
					b_target_addr_o	<=	b_target_res;
				end
				`FUNCT3_BNE:
				begin
					b_flag_o		<=	~eq_res;
					b_target_addr_o	<=	b_target_res;
				end
				`FUNCT3_BLT, `FUNCT3_BLTU:
				begin
					b_flag_o		<=	lt_res;
					b_target_addr_o	<=	b_target_res;
				end
				`FUNCT3_BGE, `FUNCT3_BGEU:
				begin
					b_flag_o		<=	~lt_res;
					b_target_addr_o	<=	b_target_res;
				end
				  
				default:
				begin
					b_flag_o		<=	1'b0;
					b_target_addr_o	<=	`ZeroWord;
				end
			endcase
		end
// end
`endif //ID_BRANCHES
		default:
		begin
			b_flag_o		<=	1'b0;
			b_target_addr_o	<=	`ZeroWord;
		end
	endcase
end


always @ (*)
begin
	if (rst)
	begin
		aluop_o			<=	`EX_NOP_OP;
		alusel_o		<=	`EX_RES_NOP;
		r1_enable_o		<=	1'b0;
		r2_enable_o		<=	1'b0;
		r1_addr_o		<=	`NOPRegAddr;
		r2_addr_o		<=	`NOPRegAddr;
		w_enable_o		<= 	`WriteDisable;
		w_addr_o		<= 	`NOPRegAddr;
		instvalid		<=	`InstValid;
		imm 			<= `ZeroWord;

		stall_req_o		<=	1'b0;
		
	end

	else
	begin
		pc_o			<=	pc_i;
		case(opcode)
			`OP_LUI:
			begin
				aluop_o			<=	`EX_OR_OP;
				alusel_o		<=	`EX_RES_LOGIC;
				r1_enable_o		<=	1'b0;
				r2_enable_o		<=	1'b0;
				r1_addr_o		<=	rs1;
				r2_addr_o		<=	rs2;
				imm				<=	imm_U;
				w_enable_o		<=	`WriteEnable;
				w_addr_o		<=	rd;
				instvalid		<=	`InstValid;

				stall_req_o		<=	1'b0;
				
			end

			`OP_AUIPC:
			begin
				aluop_o			<=	`EX_AUIPC_OP;
				alusel_o		<=	`EX_RES_ARITH;
				r1_enable_o		<=	1'b0;
				r2_enable_o		<=	1'b0;
				r1_addr_o		<=	rs1;
				r2_addr_o		<=	rs2;
				imm				<=	imm_U;
				w_enable_o		<=	`WriteEnable;
				w_addr_o		<=	rd;
				instvalid		<=	`InstValid;

				stall_req_o		<=	1'b0;
			end

			`OP_JAL:
			begin
				aluop_o			<=	`EX_JAL_OP;
				alusel_o		<=	`EX_RES_J_B;
				r1_enable_o		<=	1'b0;
				r2_enable_o		<=	1'b0;
				r1_addr_o		<=	rs1;
				r2_addr_o		<=	rs2;
				imm				<=	imm_J;
				w_enable_o		<=	`WriteEnable;
				w_addr_o		<=	rd;
				instvalid		<=	`InstValid;

				stall_req_o		<=	1'b0;
				
			end

			`OP_JALR:
			begin
				aluop_o			<=	`EX_JALR_OP;
				alusel_o		<=	`EX_RES_J_B;
				r1_enable_o		<=	1'b1;
				r2_enable_o		<=	1'b0;
				r1_addr_o		<=	rs1;
				r2_addr_o		<=	rs2;
				imm				<=	{{20{imm_I[11]}}, imm_I};
				w_enable_o		<=	`WriteEnable;
				w_addr_o		<=	rd;
				instvalid		<=	`InstValid;

				stall_req_o		<=	1'b0;
			end

			`OP_BRANCH:
			begin
				case(funct3)
					`FUNCT3_BEQ:
					begin
						aluop_o			<=	`EX_BEQ_OP;
						alusel_o		<=	`EX_RES_NOP;
						r1_enable_o		<=	1'b1;
						r2_enable_o		<=	1'b1;
						r1_addr_o		<=	rs1;
						r2_addr_o		<=	rs2;
						imm				<=	imm_B;
						w_enable_o		<=	`WriteDisable;
						w_addr_o		<=	`ZeroWord;
						instvalid		<=	`InstValid;
						stall_req_o		<=	1'b0;
					end
					`FUNCT3_BNE:
					begin
						aluop_o			<=	`EX_BNE_OP;
						alusel_o		<=	`EX_RES_NOP;
						r1_enable_o		<=	1'b1;
						r2_enable_o		<=	1'b1;
						r1_addr_o		<=	rs1;
						r2_addr_o		<=	rs2;
						imm				<=	imm_B;
						w_enable_o		<=	`WriteDisable;
						w_addr_o		<=	`ZeroWord;
						instvalid		<=	`InstValid;
						stall_req_o		<=	1'b0;
					end
					`FUNCT3_BLT:
					begin
						aluop_o			<=	`EX_BLT_OP;
						alusel_o		<=	`EX_RES_NOP;
						r1_enable_o		<=	1'b1;
						r2_enable_o		<=	1'b1;
						r1_addr_o		<=	rs1;
						r2_addr_o		<=	rs2;
						imm				<=	imm_B;
						w_enable_o		<=	`WriteDisable;
						w_addr_o		<=	`ZeroWord;
						instvalid		<=	`InstValid;
						stall_req_o		<=	1'b0;
					end
					`FUNCT3_BGE:
					begin
						aluop_o			<=	`EX_BGE_OP;
						alusel_o		<=	`EX_RES_NOP;
						r1_enable_o		<=	1'b1;
						r2_enable_o		<=	1'b1;
						r1_addr_o		<=	rs1;
						r2_addr_o		<=	rs2;
						imm				<=	imm_B;
						w_enable_o		<=	`WriteDisable;
						w_addr_o		<=	`ZeroWord;
						instvalid		<=	`InstValid;
						stall_req_o		<=	1'b0;
					end
					`FUNCT3_BLTU:
					begin
						aluop_o			<=	`EX_BLTU_OP;
						alusel_o		<=	`EX_RES_NOP;
						r1_enable_o		<=	1'b1;
						r2_enable_o		<=	1'b1;
						r1_addr_o		<=	rs1;
						r2_addr_o		<=	rs2;
						imm				<=	imm_B;
						w_enable_o		<=	`WriteDisable;
						w_addr_o		<=	`ZeroWord;
						instvalid		<=	`InstValid;
						stall_req_o		<=	1'b0;
					end
					`FUNCT3_BGEU:
					begin
						aluop_o			<=	`EX_BGEU_OP;
						alusel_o		<=	`EX_RES_NOP;
						r1_enable_o		<=	1'b1;
						r2_enable_o		<=	1'b1;
						r1_addr_o		<=	rs1;
						r2_addr_o		<=	rs2;
						imm				<=	imm_B;
						w_enable_o		<=	`WriteDisable;
						w_addr_o		<=	`ZeroWord;
						instvalid		<=	`InstValid;
						stall_req_o		<=	1'b0;
					end
					default:
					begin
					end
				endcase
			end

			`OP_OPI:
			begin
				case(funct3)
					`FUNCT3_ADDI:
					begin
						aluop_o			<=	`EX_ADD_OP;
						alusel_o		<=	`EX_RES_ARITH;
						r1_enable_o		<=	1'b1;
						r2_enable_o		<=	1'b0;
						r1_addr_o		<=	rs1;
						r2_addr_o		<=	rs2;
						imm				<=	{{20{imm_I[11]}}, imm_I[11: 0]};
						w_enable_o		<=	`WriteEnable;
						w_addr_o		<=	rd;
						instvalid		<=	`InstValid;
						stall_req_o		<=	1'b0;
					end

					`FUNCT3_SLTI:
					begin
						aluop_o			<=	`EX_SLT_OP;
						alusel_o		<=	`EX_RES_ARITH;
						r1_enable_o		<=	1'b1;
						r2_enable_o		<=	1'b0;
						r1_addr_o		<=	rs1;
						r2_addr_o		<=	rs2;
						imm				<=	{{20{imm_I[11]}}, imm_I[11: 0]};
						w_enable_o		<=	`WriteEnable;
						w_addr_o		<=	rd;
						instvalid		<=	`InstValid;
						stall_req_o		<=	1'b0;
					end

					`FUNCT3_SLTIU:
					begin
						aluop_o			<=	`EX_SLTU_OP;
						alusel_o		<=	`EX_RES_ARITH;
						r1_enable_o		<=	1'b1;
						r2_enable_o		<=	1'b0;
						r1_addr_o		<=	rs1;
						r2_addr_o		<=	rs2;
						imm				<=	{{20{imm_I[11]}}, imm_I[11: 0]};	
						w_enable_o		<=	`WriteEnable;
						w_addr_o		<=	rd;
						instvalid		<=	`InstValid;
						stall_req_o		<=	1'b0;
					end
					
					`FUNCT3_XORI:
					begin
						aluop_o			<=	`EX_XOR_OP;
						alusel_o		<=	`EX_RES_LOGIC;
						r1_enable_o		<=	1'b1;
						r2_enable_o		<=	1'b0;
						r1_addr_o		<=	rs1;
						r2_addr_o		<=	rs2;
						imm				<=	{20'h0, imm_I};
						w_enable_o		<=	`WriteEnable;
						w_addr_o		<=	rd;
						instvalid		<=	`InstValid;
						stall_req_o		<=	1'b0;
					end

					`FUNCT3_ORI: // ORI
					begin
						aluop_o			<=	`EX_OR_OP;
						alusel_o		<=	`EX_RES_LOGIC;
						r1_enable_o		<=	1'b1;
						r2_enable_o		<=	1'b0;
						r1_addr_o		<=	rs1;
						r2_addr_o		<=	rs2;
						imm				<=	{20'h0, imm_I};
						w_enable_o		<=	`WriteEnable;
						w_addr_o		<=	rd;
						instvalid		<=	`InstValid;
						stall_req_o		<=	1'b0;
					end

					`FUNCT3_ANDI:
					begin
						aluop_o			<=	`EX_AND_OP;
						alusel_o		<=	`EX_RES_LOGIC;
						r1_enable_o		<=	1'b1;
						r2_enable_o		<=	1'b0;
						r1_addr_o		<=	rs1;
						r2_addr_o		<=	rs2;
						imm				<=	{20'h0, imm_I};
						w_enable_o		<=	`WriteEnable;
						w_addr_o		<=	rd;
						instvalid		<=	`InstValid;
						stall_req_o		<=	1'b0;
					end
					
					`FUNCT3_SLLI:
					begin
						aluop_o			<=	`EX_SLL_OP;
						alusel_o		<=	`EX_RES_SHIFT;
						r1_enable_o		<=	1'b1;
						r2_enable_o		<=	1'b0;
						r1_addr_o		<=	rs1;
						r2_addr_o		<=	rs2;
						imm				<=	{27'h0, rs2};
						w_enable_o		<=	`WriteEnable;
						w_addr_o		<=	rd;
						instvalid		<=	`InstValid;
						stall_req_o		<=	1'b0;
					end

					`FUNCT3_SRLI_SRAI:
					begin
						case (funct7)
							`FUNCT7_SRLI:
							begin
								aluop_o		<=	`EX_SRL_OP;
								alusel_o	<=	`EX_RES_SHIFT;
								r1_enable_o	<=	1'b1;
								r2_enable_o	<=	1'b0;
								r1_addr_o	<=	rs1;
								r2_addr_o	<=	rs2;
								imm			<=	{27'h0, rs2};
								w_enable_o	<=	`WriteEnable;
								w_addr_o	<=	rd;
								instvalid	<=	`InstValid;
								stall_req_o	<=	1'b0;
							end

							`FUNCT7_SRAI:
							begin
								aluop_o		<=	`EX_SRA_OP;
								alusel_o	<=	`EX_RES_SHIFT;
								r1_enable_o	<=	1'b1;
								r2_enable_o	<=	1'b0;
								r1_addr_o	<=	rs1;
								r2_addr_o	<=	rs2;
								imm			<=	{27'h0, rs2};
								w_enable_o	<=	`WriteEnable;
								w_addr_o	<=	rd;
								instvalid	<=	`InstValid;
								stall_req_o	<=	1'b0;
							end
						  default:
						  begin
						  end
						endcase
					end

					default:
					begin
					end
				endcase
			end
			
			`OP_OP:
			begin
				case (funct3)
					`FUNCT3_ADD_SUB:
					begin
						case (funct7)
							`FUNCT7_ADD:
							begin
								aluop_o		<=	`EX_ADD_OP;
								alusel_o	<=	`EX_RES_ARITH;
								r1_enable_o	<=	1'b1;
								r2_enable_o	<=	1'b1;
								r1_addr_o	<=	rs1;
								r2_addr_o	<=	rs2;
								imm			<=	`ZeroWord;
								w_enable_o	<=	`WriteEnable;
								w_addr_o	<=	rd;
								instvalid	<=	`InstValid;
								stall_req_o	<=	1'b0;
							end

							`FUNCT7_SUB:
							begin
								aluop_o		<=	`EX_SUB_OP;
								alusel_o	<=	`EX_RES_ARITH;
								r1_enable_o	<=	1'b1;
								r2_enable_o	<=	1'b1;
								r1_addr_o	<=	rs1;
								r2_addr_o	<=	rs2;
								imm			<=	`ZeroWord;
								w_enable_o	<=	`WriteEnable;
								w_addr_o	<=	rd;
								instvalid	<=	`InstValid;
								stall_req_o	<=	1'b0;
							end
						endcase
					end

					`FUNCT3_SLL:
					begin
						aluop_o		<=	`EX_SLL_OP;
						alusel_o	<=	`EX_RES_SHIFT;
						r1_enable_o	<=	1'b1;
						r2_enable_o	<=	1'b1;
						r1_addr_o	<=	rs1;
						r2_addr_o	<=	rs2;
						imm			<=	`ZeroWord;
						w_enable_o	<=	`WriteEnable;
						w_addr_o	<=	rd;
						instvalid	<=	`InstValid;
						stall_req_o	<=	1'b0;
					end

					`FUNCT3_SLT:
					begin
						aluop_o		<=	`EX_SLT_OP;
						alusel_o	<=	`EX_RES_ARITH;
						r1_enable_o	<=	1'b1;
						r2_enable_o	<=	1'b1;
						r1_addr_o	<=	rs1;
						r2_addr_o	<=	rs2;
						imm			<=	`ZeroWord;
						w_enable_o	<=	`WriteEnable;
						w_addr_o	<=	rd;
						instvalid	<=	`InstValid;
						stall_req_o	<=	1'b0;
					end

					`FUNCT3_SLTU:
					begin
						aluop_o		<=	`EX_SLTU_OP;
						alusel_o	<=	`EX_RES_ARITH;
						r1_enable_o	<=	1'b1;
						r2_enable_o	<=	1'b1;
						r1_addr_o	<=	rs1;
						r2_addr_o	<=	rs2;
						imm			<=	`ZeroWord;
						w_enable_o	<=	`WriteEnable;
						w_addr_o	<=	rd;
						instvalid	<=	`InstValid;
						stall_req_o	<=	1'b0;
					end

					`FUNCT3_XOR:
					begin
						aluop_o		<=	`EX_XOR_OP;
						alusel_o	<=	`EX_RES_LOGIC;
						r1_enable_o	<=	1'b1;
						r2_enable_o	<=	1'b1;
						r1_addr_o	<=	rs1;
						r2_addr_o	<=	rs2;
						imm			<=	`ZeroWord;
						w_enable_o	<=	`WriteEnable;
						w_addr_o	<=	rd;
						instvalid	<=	`InstValid;
						stall_req_o	<=	1'b0;
					end
					`FUNCT3_SRL_SRA:
					begin
					   case (funct7)
                            `FUNCT7_SRL:
                            begin
                                aluop_o		<=	`EX_SRL_OP;
                                alusel_o	<=	`EX_RES_SHIFT;
                                r1_enable_o	<=	1'b1;
                                r2_enable_o	<=	1'b1;
                                r1_addr_o	<=	rs1;
                                r2_addr_o	<=	rs2;
                                imm			<=	`ZeroWord;
                                w_enable_o	<=	`WriteEnable;
                                w_addr_o	<=	rd;
                                instvalid	<=	`InstValid;
                                stall_req_o	<=	1'b0;
                                
                                
                            end
    
                            `FUNCT7_SRA:
                            begin
                                aluop_o		<=	`EX_SRA_OP;
                                alusel_o	<=	`EX_RES_SHIFT;
                                r1_enable_o	<=	1'b1;
                                r2_enable_o	<=	1'b1;
                                r1_addr_o	<=	rs1;
                                r2_addr_o	<=	rs2;
                                imm			<=	`ZeroWord;
                                w_enable_o	<=	`WriteEnable;
                                w_addr_o	<=	rd;
                                instvalid	<=	`InstValid;
                                stall_req_o	<=	1'b0;
                                
                                
                            end
                        endcase
					end
					
					`FUNCT3_OR:
					begin
						aluop_o		<=	`EX_OR_OP;
						alusel_o	<=	`EX_RES_LOGIC;
						r1_enable_o	<=	1'b1;
						r2_enable_o	<=	1'b1;
						r1_addr_o	<=	rs1;
						r2_addr_o	<=	rs2;
						imm			<=	`ZeroWord;
						w_enable_o	<=	`WriteEnable;
						w_addr_o	<=	rd;
						instvalid	<=	`InstValid;
						stall_req_o	<=	1'b0;
					end

					`FUNCT3_AND:
					begin
						aluop_o		<=	`EX_AND_OP;
						alusel_o	<=	`EX_RES_LOGIC;
						r1_enable_o	<=	1'b1;
						r2_enable_o	<=	1'b1;
						r1_addr_o	<=	rs1;
						r2_addr_o	<=	rs2;
						imm			<=	`ZeroWord;
						w_enable_o	<=	`WriteEnable;
						w_addr_o	<=	rd;
						instvalid	<=	`InstValid;
						stall_req_o	<=	1'b0;
					end

				endcase
			end
			
			default:
			begin
				aluop_o		<=	`EX_NOP_OP;
				alusel_o	<=	`EX_RES_NOP;
				r1_enable_o	<=	1'b0;
				r2_enable_o	<=	1'b0;
				r1_addr_o	<=	rs1;
				r2_addr_o	<=	rs2;
				imm			<= `ZeroWord;
				w_enable_o	<= 	`WriteDisable;
				w_addr_o	<= 	rd;
				instvalid	<=	`InstInvalid;
				stall_req_o	<=	1'b0;
				
			end
		endcase
	end
end

always @ (*)
begin
	if (rst)
		r1_data_o	<=	`ZeroWord;
	else if (r1_enable_o && ex_w_enable_i && ex_w_addr_i == r1_addr_o)
		r1_data_o 	<=	ex_w_data_i;
	else if (r1_enable_o && mem_w_enable_i && mem_w_addr_i == r1_addr_o)
		r1_data_o	<=	mem_w_data_i;
	else if (r1_enable_o)
		r1_data_o	<=	r1_data_i;
	else if (!r1_enable_o)
		r1_data_o	<=	imm;
	else
		r1_data_o	<=	`ZeroWord;
end

always @ (*)
begin
	if (rst)
		r2_data_o	<=	`ZeroWord;
	else if (r2_enable_o && ex_w_enable_i && ex_w_addr_i == r2_addr_o)
		r2_data_o 	<=	ex_w_data_i;
	else if (r2_enable_o && mem_w_enable_i && mem_w_addr_i == r2_addr_o)
		r2_data_o	<=	mem_w_data_i;
	else if (r2_enable_o)
		r2_data_o	<=	r2_data_i;
	else if (!r2_enable_o)
		r2_data_o	<=	imm;
	else
		r2_data_o	<=	`ZeroWord;
end

always @(*)
begin
	if (rst)
	begin
		b_offset_o	<=	`ZeroWord;
	end
	else
	begin
		b_offset_o	<=	imm;
	end
end


endmodule

`endif