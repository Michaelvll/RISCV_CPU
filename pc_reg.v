`ifndef _pc_reg
`define _pc_reg

`include "Defines.vh"

module pc_reg (
    input wire 					clk,
    input wire					rst,

    output reg [`InstAddrBus]	pc,
    output reg 					ce
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
        if (ce == `ChipEnable)
            pc <= pc + 32'h4;
        else
            pc <= `ZeroWord;
    end

endmodule

`endif