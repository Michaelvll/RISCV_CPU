`ifndef _RESICV_MIN_SOPC
`define _RESICV_MIN_SOPC
`include "Defines.vh"
`include "IDInstDef.vh"
`include "cpu.v"
`include "Inst_rom.v"
`include "Data_ram.v"

module Riscv_min_sopc(
	input wire clk,
	input wire rst
);

wire[`InstAddrBus]	inst_addr;
wire[`InstBus]		inst;
wire				rom_ce;
wire				ram_w_enable;
wire[`RegBus]		ram_r_data;
wire[`RegBus]		ram_addr;
wire[`RegBus]		ram_w_data;
wire[3:0] 			ram_sel;   
wire 				ram_ce; 

cpu cpu0(
	.clk(clk),
	.rst(rst),

	.rom_data_i(inst),
	.rom_ce_o(rom_ce),
	.rom_addr_o(inst_addr),

	.ram_r_data_i(ram_r_data),
	.ram_addr_o(ram_addr),
	.ram_w_data_o(ram_w_data),
	.ram_w_enable_o(ram_w_enable),
	.ram_sel_o(ram_sel),
	.ram_ce_o(ram_ce)
);

Inst_rom inst_rom0 (
	.ce(rom_ce),
	.addr(inst_addr),
	.inst(inst)
);

Data_ram data_ram0 (
	.clk(clk),
	.ce(ram_ce),
	.we(ram_w_enable),
	.addr(ram_addr),
	.sel(ram_sel),
	.data_i(ram_w_data),
	.data_o(ram_r_data)
);



endmodule

`endif