`ifndef _pc_reg
`define _pc_reg

`include "Defines.vh"
`include "IDInstDef.vh"

module PC_reg (
    input wire 					clk,
    input wire					rst,

    output reg [`InstAddrBus]	pc,
    output reg 					ce,
	
	input wire[5:0]				stall
);
    initial
    begin
        pc = `InstAddrWidth'h0;
    end
    
	always @(posedge clk) 
    begin
        if (rst) 
        begin
            ce <= `ChipDisable;
        end
        else
        begin
            ce <= `ChipEnable;
        end
	end

    always @(posedge clk) 
    begin
        if (ce == `ChipDisable)
            pc <= `ZeroWord;
        else if (!stall[0])
            pc <= pc + 32'h4;
    end

endmodule

`endif