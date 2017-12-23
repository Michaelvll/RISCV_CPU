`ifndef _CPU
`define _CPU
`timescale 1ns/1ps

`include "Defines.vh"
`include "IDInstDef.vh"
`include "ALUInstDef.vh"
`include "PC_reg.v"
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
`include "Ctrl.v"

module cpu(
    input wire 		clk,
	input wire		rst,

	input wire[`RegBus]			rom_data_i,

	output wire					rom_ce_o,
	output wire[`InstAddrBus]	rom_addr_o,

	input wire[`RegBus]			ram_r_data_i,
	output wire[`RegBus]		ram_addr_o,
	output wire[`RegBus]		ram_w_data_o,
	output wire					ram_w_enable_o,
	output wire[3:0]			ram_sel_o,
	output wire					ram_ce_o
);

// ================== STALL Control =================
wire 				if_stall_req;
wire 				id_stall_req;
wire 				ex_stall_req;
wire 				me_stall_req;
wire[5:0]			stall;


Ctrl ctrl0(
	.rst(rst),
	.if_stall_req_i(if_stall_req),
	.id_stall_req_i(id_stall_req),
	.ex_stall_req_i(ex_stall_req),
	.me_stall_req_i(me_stall_req),
	.stall(stall)
);

// ================== IF ============================
wire[`InstAddrBus]	pc;
wire[`InstAddrBus]	if_pc_o;
wire[`InstBus]		if_inst_o;

wire				ex_b_flag_o;
wire[`RegBus]		ex_b_target_addr_o;

wire				id_b_flag_o;
wire[`RegBus]		id_b_target_addr_o;

PC_reg pc_reg0(
	.clk(clk),
	.rst(rst),
	.pc(pc),
	.ce(rom_ce_o),
	.stall(stall),

	.ex_b_flag_i(ex_b_flag_o),
	.ex_b_target_addr_i(ex_b_target_addr_o),

	.id_b_flag_i(id_b_flag_o),
	.id_b_target_addr_i(id_b_target_addr_o)
);

IF if0 (
	.clk(clk),
	.rst(rst),

	.pc_i(pc),
	.rom_data_i(rom_data_i),
	.pc_o(if_pc_o),
	.inst_o(if_inst_o),
	.rom_addr_o(rom_addr_o),
	.stall_req_o(if_stall_req)
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
	.id_inst(id_inst_i),

	.stall(stall),
	.ex_b_flag(ex_b_flag_o),
	.id_b_flag(id_b_flag_o)
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

wire					ex2id_w_enable;
wire[`RegAddrBus]		ex2id_w_addr;
wire[`RegBus]			ex2id_w_data;
wire					me2id_w_enable;
wire[`RegAddrBus]		me2id_w_addr;
wire[`RegBus]			me2id_w_data;
wire[`InstAddrBus]		id_pc_o;
wire[`RegBus]			id_offset_o;
wire					ex2id_pre_ld;

ID id0 (
	.rst(rst),

	.pc_i(id_pc_i),
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
	.w_addr_o(id_w_addr_o),
	.pc_o(id_pc_o),
	.ex_w_enable_i(ex2id_w_enable),
	.ex_w_addr_i(ex2id_w_addr),
	.ex_w_data_i(ex2id_w_data),
	.me_w_enable_i(me2id_w_enable),
	.me_w_addr_i(me2id_w_addr),
	.me_w_data_i(me2id_w_data),

	.stall_req_o(id_stall_req),
	.offset_o(id_offset_o),
	.b_flag_o(id_b_flag_o),
	.b_target_addr_o(id_b_target_addr_o),

	.ex_pre_ld(ex2id_pre_ld)
);

// ================== ID_EX =========================

wire[`AluOpBus]				ex_aluop_i;
wire[`AluOutSelBus]			ex_alusel_i;
wire[`RegBus]				ex_r1_data_i;
wire[`RegBus]				ex_r2_data_i;
wire						ex_w_enable_i;
wire[`RegAddrBus]			ex_w_addr_i;

wire[`InstAddrBus]			ex_pc_i;
wire[`RegBus]				ex_offset_i;


ID_EX id_ex0 (
	.clk(clk),
	.rst(rst),

	.id_pc(id_pc_o),
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
	.ex_w_addr(ex_w_addr_i),
	.ex_pc(ex_pc_i),

	.stall(stall),
	.ex_b_flag(ex_b_flag_o),
	.id_offset(id_offset_o),
	.ex_offset(ex_offset_i)
);

// ================== EX ===========================
wire						ex_w_enable_o;
wire[`RegAddrBus]			ex_w_addr_o;
wire[`RegBus]				ex_w_data_o;

wire[`AluOpBus]				ex_aluop_o;
wire[`RegBus]				ex_mem_addr_o;

EX ex0 (
	.rst(rst),

	.pc_i(ex_pc_i),
	.aluop_i(ex_aluop_i),
	.alusel_i(ex_alusel_i),
	.r1_data_i(ex_r1_data_i),
	.r2_data_i(ex_r2_data_i),
	.w_enable_i(ex_w_enable_i),
	.w_addr_i(ex_w_addr_i),
	.w_enable_o(ex_w_enable_o),
	.w_addr_o(ex_w_addr_o),
	.w_data_o(ex_w_data_o),

	.stall_req_o(ex_stall_req),

	.offset_i(ex_offset_i),
	.b_flag_o(ex_b_flag_o),
	.b_target_addr_o(ex_b_target_addr_o),

	.aluop_o(ex_aluop_o),
	.mem_addr_o(ex_mem_addr_o),

	.is_ld(ex2id_pre_ld)
);

// Forwarding wire
assign ex2id_w_enable	=	ex_w_enable_o;
assign ex2id_w_addr		=	ex_w_addr_o;
assign ex2id_w_data		=	ex_w_data_o;

// ================== EX_ME ===========================
wire						me_w_enable_i;
wire[`RegAddrBus]			me_w_addr_i;
wire[`RegBus]				me_w_data_i;
wire[`AluOpBus]				me_aluop_i;
wire[`RegBus]				me_mem_addr_i;


EX_ME ex_me0 (
	.clk(clk),
	.rst(rst),

	.ex_w_enable(ex_w_enable_o),
	.ex_w_addr(ex_w_addr_o),
	.ex_w_data(ex_w_data_o),
	.me_w_enable(me_w_enable_i),
	.me_w_addr(me_w_addr_i),
	.me_w_data(me_w_data_i),

	.stall(stall),

	.ex_aluop(ex_aluop_o),
	.ex_mem_addr(ex_mem_addr_o),
	.me_aluop(me_aluop_i),
	.me_mem_addr(me_mem_addr_i)
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
	.w_data_o(me_w_data_o),

	.stall_req_o(me_stall_req),

	.aluop_i(me_aluop_i),
	.mem_addr_i(me_mem_addr_i),

	.mem_r_data_i(ram_r_data_i),
	.mem_w_enable_o(ram_w_enable_o),
	.mem_sel_o(ram_sel_o),
	.mem_w_data_o(ram_w_data_o),
	.mem_addr_o(ram_addr_o),
	.mem_ce_o(ram_ce_o)
);

// Forwarding wire
assign me2id_w_enable	=	me_w_enable_o;	
assign me2id_w_addr		=	me_w_addr_o;
assign me2id_w_data		=	me_w_data_o;


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
	.wb_w_data(wb_w_data_i),

	.stall(stall)
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