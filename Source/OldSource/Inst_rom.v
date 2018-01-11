`ifndef _INST_ROM
`define _INST_ROM

`include "Defines.vh"
`include "IDInstDef.vh"

module Inst_rom (
	input wire					ce,
	input wire[`InstAddrBus]	addr,
	output	reg[`InstBus]		inst
);

reg[`InstBus]	inst_mem[0: `InstMemNum-1];

// Initialize the inst_mem with "inst_rom.data" file
initial	$readmemh("inst_rom.mem", inst_mem);
reg[`InstBus] inst_tmp;

always @ (*)
begin
	if (!ce)
	begin
		inst = `ZeroWord;
	end
	else
	begin

		inst_tmp	=	inst_mem[addr[`InstMemNumLog2 + 1: 2]];
		inst		=	{inst_tmp[7:0], inst_tmp[15:8], inst_tmp[23:16], inst_tmp[31:24]};

	end
end



endmodule

`endif