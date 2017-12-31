`ifndef _IF
`define _IF

`include "Defines.vh"
`include "IDInstDef.vh"

module IF (
    input wire  rst,

	input wire[`InstAddrBus]	pc_i,
	input wire[`InstBus]		rom_data_i,
	output reg[`InstAddrBus]	pc_o,
    output reg[`InstBus]    	inst_o,
	output wire[`InstAddrBus]	rom_addr_o,

	output reg 					r_enable_o,
	input wire					rom_busy_i,
	input wire					rom_done_i,

	output reg 					stall_req_o
);

assign rom_addr_o = pc_i;

always @ (rom_busy_i, pc_i, rom_data_i, rst)
begin
    if (rst) 
    begin
		pc_o		=	`ZeroWord;
		r_enable_o	=	1'b0;
		stall_req_o	=	1'b0;
    end
    else if (!rom_busy_i && !stall_req_o)
    begin
        pc_o		=	pc_i;
		r_enable_o	=	1'b1;
		stall_req_o	=	1'b1;
    end
	else if (rom_busy_i && stall_req_o)
	begin
		stall_req_o	=	1'b1;
	end
	else if (!rom_busy_i && stall_req_o)
	begin
		stall_req_o	=	1'b0;
	end
end

always@(*)
begin
    if (rst)
        inst_o      =  `ZeroWord;
    else if (rom_done_i)
        inst_o      =  {rom_data_i[7:0],rom_data_i[15:8],rom_data_i[23:16],rom_data_i[31:24]};
end

endmodule





`endif