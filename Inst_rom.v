`ifndef _INST_ROM
`define _INST_ROM

`include "Define.vh"

module Inst_rom (
	input wire					ce,
	input wire[`InstAddrBus]	addr,
	output	reg[`InstBus]		inst
);

reg[`InstBus]	inst_mem[0: `InstMemNum-1];

// Initialize the inst_mem with "inst_rom.data" file
initial	$readmemh ("inst_rom.data", inst_mem);

always @ (*)
begin
	if (!ce)
	begin
		inst <= `ZeroWord;
	end
	else
	begin
		inst	<=	inst_mem[addr[`InstMemNumLog2 + 1: 2]];
	end
end



endmodule

`endif