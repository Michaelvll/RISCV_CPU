`ifndef _CPU
`define	_CPU

`include "Defines.vh"
`include "IDInstDef.vh"
`include "pc_reg.v"
`include "IF.v"
`include "IF_ID.v"
`include "ID.v"
`include "ID_EX.v"
`include "EX.v"
`include "EX_ME.v"
`include "ME.v"
`include "ME_WB.v"
`include "WB.v"
`include "Regfile.v"

module cpu(
    input wire 		clk,
	input wire		rst,

	input wire[`RegBus]			rom_data_i,

	output wire					rom_ce_o,
	output wire[`InstAddrBus]	rom_addr_o
);

// ================== IF ============================
wire[`InstAddrBus]	pc;
wire[`InstAddrBus]	if_pc_o;
wire[`InstBus]		if_inst_o;

pc_reg pc_reg0(
	.clk(clk),
	.rst(rst),
	.pc(pc),
	.ce(rom_ce_o)
);

IF if0 (
	.clk(clk),
	.rst(rst),

	.pc_i(pc),
	.rom_data_i(rom_data_i),
	.pc_o(if_pc_o),
	.inst_o(if_inst_o),
	.rom_addr_o(rom_addr_o)
);

// ================== IF_ID =========================
wire[`InstAddrBus]	id_pc_i;
wire[`InstBus]		id_inst_i;

IF_ID if_id0 (
	.clk(clk),
	.rst(rst),

	.if_pc(if_pc_o),
	.if_inst(if_inst_o),
	.id_pc(id_pc_i),
	.id_inst(id_inst_i)
);

// ================== ID ===========================

// Send to the regfile to get reg_data
wire					id_r1_enable_o;
wire					id_r2_enable_o;
wire[`RegAddrBus]		id_r1_addr_o;
wire[`RegAddrBus]		id_r2_addr_o;
// Get from the regfile
wire[`RegBus]			id_r2_data_i;
wire[`RegBus]			id_r1_data_i;

wire[`AluOpBus]			id_aluop_o;
wire[`AluOutSelBus]		id_alusel_o;
wire[`RegBus]			id_r1_data_o;
wire[`RegBus]			id_r2_data_o;
wire					id_w_enable_o;
wire[`RegAddrBus]		id_w_addr_o;

ID id0 (
	.rst(rst),

	.inst_i(id_inst_i),
	.r1_data_i(id_r1_data_i),
	.r2_data_i(id_r2_data_i),
	.r1_enable_o(id_r1_enable_o),
	.r2_enable_o(id_r2_enable_o),
	.r1_addr_o(id_r1_addr_o),
	.r2_addr_o(id_r2_addr_o),
	.aluop_o(id_aluop_o),
	.alusel_o(id_alusel_o),
	.r1_data_o(id_r1_data_o),
	.r2_data_o(id_r2_data_o),
	.w_enable_o(id_w_enable_o),
	.w_addr_o(id_w_addr_o)
);

// ================== ID_EX =========================

wire[`AluOpBus]				ex_aluop_i;
wire[`AluOutSelBus]			ex_alusel_i;
wire[`RegBus]				ex_r1_data_i;
wire[`RegBus]				ex_r2_data_i;
wire						ex_w_enable_i;
wire[`RegAddrBus]			ex_w_addr_i;


ID_EX id_ex0 (
	.clk(clk),
	.rst(rst),

	.id_aluop(id_aluop_o),
	.id_alusel(id_alusel_o),
	.id_r1_data(id_r1_data_o),
	.id_r2_data(id_r2_data_o),
	.id_w_enable(id_w_enable_o),
	.id_w_addr(id_w_addr_o),
	.ex_aluop(ex_aluop_i),
	.ex_alusel(ex_alusel_i),
	.ex_r1_data(ex_r1_data_i),
	.ex_r2_data(ex_r2_data_i),
	.ex_w_enable(ex_w_enable_i),
	.ex_w_addr(ex_w_addr_i)
);

// ================== EX ===========================
wire						ex_w_enable_o;
wire[`RegAddrBus]			ex_w_addr_o;
wire[`RegBus]				ex_w_data_o;

EX ex0 (
	.rst(rst),

	.aluop_i(ex_aluop_i),
	.alusel_i(ex_alusel_i),
	.r1_data_i(ex_r1_data_i),
	.r2_data_i(ex_r2_data_i),
	.w_enable_i(ex_w_enable_i),
	.w_addr_i(ex_w_addr_i),
	.w_enable_o(ex_w_enable_o),
	.w_addr_o(ex_w_addr_o),
	.w_data_o(ex_w_data_o)
);

// ================== EX_ME ===========================
wire						me_w_enable_i;
wire[`RegAddrBus]			me_w_addr_i;
wire[`RegBus]				me_w_data_i;


EX_ME ex_me0 (
	.clk(clk),
	.rst(rst),

	.ex_w_enable(ex_w_enable_o),
	.ex_w_addr(ex_w_addr_o),
	.ex_w_data(ex_w_data_o),
	.me_w_enable(me_w_enable_i),
	.me_w_addr(me_w_addr_i),
	.me_w_data(me_w_data_i)
);

// ================== ME =============================
wire						me_w_enable_o;
wire[`RegAddrBus]			me_w_addr_o;
wire[`RegBus]				me_w_data_o;


ME me0 (
	.rst(rst),

	.w_enable_i(me_w_enable_i),
	.w_addr_i(me_w_addr_i),
	.w_data_i(me_w_data_i),
	.w_enable_o(me_w_enable_o),
	.w_addr_o(me_w_addr_o),
	.w_data_o(me_w_data_o)
);

// ================== ME_WB ===========================
wire						wb_w_enable_i;
wire[`RegAddrBus]			wb_w_addr_i;
wire[`RegBus]				wb_w_data_i;

ME_WB me_wb0 (
	.clk(clk),
	.rst(rst),

	.me_w_enable(me_w_enable_o),
	.me_w_addr(me_w_addr_o),
	.me_w_data(me_w_data_o),
	.wb_w_enable(wb_w_enable_i),
	.wb_w_addr(wb_w_addr_i),
	.wb_w_data(wb_w_data_i)
);

// ================== WB ==============================

wire						wb_w_enable_o;
wire[`RegAddrBus]			wb_w_addr_o;
wire[`RegBus]				wb_w_data_o;

WB wb0 (
	.rst(rst),

	.w_enable_i(wb_w_enable_i),
	.w_addr_i(wb_w_addr_i),
	.w_data_i(wb_w_data_i),
	.w_enable_o(wb_w_enable_o),
	.w_addr_o(wb_w_addr_o),
	.w_data_o(wb_w_data_o)
);


Regfile regfile0(
	.clk(clk),
	.rst(rst),
	
	.w_enable(wb_w_enable_o),
	.w_addr(wb_w_addr_o),
	.w_data(wb_w_data_o),
	.r1_enable(id_r1_enable_o),
	.r1_addr(id_r1_addr_o),
	.r1_data(id_r1_data_i),
	.r2_enable(id_r2_enable_o),
	.r2_addr(id_r2_addr_o),
	.r2_data(id_r2_data_i)
);

endmodule

`endif