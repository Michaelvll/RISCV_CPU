`inlcude "Defines.vh"

module ID (
	input wire					rst,
	input wire[`InstAddrBus]	pc_i,
	input wire[`InstBus]		inst_i,

	// Read data from regfile
	input wire[`RegBus]		 	reg1_data_i,
	input wire[`RegBus]		 	reg2_data_i,

	output reg					reg1_re_o, // Enable read1 to regfile
	output reg					reg2_re_o, // Enable read2 to regfile
	output reg[`RegAddrBus]	 	reg1_addr_o,
	output reg[`RegAddrBus]	 	reg2_addr_o,

	// ifo. for EXE
	output reg[`AluOpBus]		aluop_o,
	output reg[`AluSelBus]		alusel_o,
	output reg[`RegBus]		 	alu1_data_o,
	output reg[`RegBus]		 	alu2_data_o,
	output reg					w_enable_o,
	output reg[`RegAddrBus]	 	w_dir_o
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
		aluop_o		<=	`EXE_NOP_OP;
		alusel_o	<=	`EXE_RES_NOP;
		w_enable_o	<= 	`WriteDisable;
		w_dir_o		<= 	`NOPRegAddr;
		instvalid	<=	`InstValid;
		reg1_re_o	<=	1'b0;
		reg2_re_o	<=	1'b0;
		reg1_addr_o	<=	`NOPRegAddr;
		reg2_addr_o	<=	`NOPRegAddr;
		imm <= `ZeroWord;
	end
	else
	begin
		aluop_o		<=	`EXE_NOP_OP;
		alusel_o	<=	`EXE_RES_NOP;
		w_enable_o	<= 	`WriteDisable;
		w_dir_o		<= 	rd;
		instvalid	<=	`InstInValid;
		reg1_re_o	<=	1'b0;
		reg2_re_o	<=	1'b0;
		reg1_addr_o	<=	rs1;
		reg2_addr_o	<=	rs2;
		imm <= `ZeroWord;

		case(opcode)
			`EXE_LOGICI:
			begin
				case(funct3)
					3'b110: // ORI
					begin
						w_enable_o	<=	`WriteEnable;
						aluop_o		<=	`EXE_OR_OP;
						alusel_o	<=	`EXE_RES_LOGIC;
						reg1_re_o	<=	1'b1;
						reg2_re_o	<=	1'b0;
						imm			<=	{20'h00000, imm_I};
						w_dir_o		<=	rd;
						instvalid	<=	`InstValid;
					end
				endcase
			default:
			begin
			end
		endcase
	end
end

always @ (*)
begin
	if (rst)
		alu1_data_o	<=	`ZeroWord;
	else if (reg1_re_o)
		alu1_data_o	<=	reg1_data_i;
	else if (!reg1_re_o)
		alu1_data_o	<=	imm;
	else
		alu1_data_o	<=	`ZeroWord;
end

always @ (*)
begin
	if (rst)
		alu2_data_o	<=	`ZeroWord;
	else if (reg2_re_o)
		alu2_data_o	<=	reg2_data_i;
	else if (!reg2_re_o)
		alu2_data_o	<=	imm;
	else
		alu2_data_o	<=	`ZeroWord;
end


endmodule