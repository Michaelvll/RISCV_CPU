`ifndef _IF
`define _IF

`include "Defines.vh"
`include "IDInstDef.vh"
`include "pc_reg.v"

module IF (
    input wire  clk,
    input wire  rst,

	input wire[`InstAddrBus]	pc_i,
	input wire[`InstBus]		rom_data_i,
	output reg[`InstAddrBus]	pc_o,
    output reg[`InstBus]    	inst_o,
	output wire[`InstAddrBus]	rom_addr_o,

	output reg 					stall_req_o
);

assign rom_addr_o = pc_i;

always @(*)
begin
	stall_req_o		=	1'b0;
end

always @ (*)
begin
    if (rst) 
    begin
		pc_o		<=	`ZeroWord;
        inst_o 		<=	`ZeroWord;
    end
    else
    begin
        pc_o	<=	pc_i;
		inst_o	<=	rom_data_i;
    end
end

endmodule





`endif