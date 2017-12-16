`ifndef _ID
`define _ID
`include "Defines.vh"
`include "IDInstDef.vh"

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
	output reg[`RegAddrBus]	 	w_addr_o
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
wire[12:1]		imm_B;
wire[31:12]	 	imm_U;
wire[20:1]		imm_J;


assign opcode	=	inst_i[6:0];
assign rd		=	inst_i[11:7];
assign funct3	=	inst_i[14:12];
assign rs1		=	inst_i[19:15];
assign rs2		=	inst_i[24:20];
assign funct7	=	inst_i[31:25];
assign imm_I	=	inst_i[31:20];
assign imm_S	=	{inst_i[31:25], inst_i[11:7]};
assign imm_B	=	{inst_i[31], inst_i[7], 
						inst_i[30:25], inst_i[11:8]};
assign imm_U	=	inst_i[31:12];
assign imm_J	=	{inst_i[31], inst_i[19:12],
						inst_i[20], inst_i[30:21]};

always @ (*)
begin
	if (rst)
	begin
		aluop_o		<=	`EX_NOP_OP;
		alusel_o	<=	`EX_RES_NOP;
		w_enable_o	<= 	`WriteDisable;
		w_addr_o	<= 	`NOPRegAddr;
		instvalid	<=	`InstValid;
		r1_enable_o	<=	1'b0;
		r2_enable_o	<=	1'b0;
		r1_addr_o	<=	`NOPRegAddr;
		r2_addr_o	<=	`NOPRegAddr;
		imm <= `ZeroWord;
	end
	else
	begin
		aluop_o		<=	`EX_NOP_OP;
		alusel_o	<=	`EX_RES_NOP;
		w_enable_o	<= 	`WriteDisable;
		w_addr_o		<= 	rd;
		instvalid	<=	`InstInvalid;
		r1_enable_o	<=	1'b0;
		r2_enable_o	<=	1'b0;
		r1_addr_o	<=	rs1;
		r2_addr_o	<=	rs2;
		imm <= `ZeroWord;

		case(opcode)
			`OP_OPI:
			begin
				case(funct3)
					`FUNCT3_ORI: // ORI
					begin
						w_enable_o	<=	`WriteEnable;
						aluop_o		<=	`EX_OR_OP;
						alusel_o	<=	`EX_RES_LOGIC;
						r1_enable_o	<=	1'b1;
						r2_enable_o	<=	1'b0;
						imm			<=	{20'h0, imm_I};
						w_addr_o		<=	rd;
						instvalid	<=	`InstValid;
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
end

always @ (*)
begin
	if (rst)
		r1_data_o	<=	`ZeroWord;
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
	else if (r2_enable_o)
		r2_data_o	<=	r2_data_i;
	else if (!r2_enable_o)
		r2_data_o	<=	imm;
	else
		r2_data_o	<=	`ZeroWord;
end


endmodule

`endif