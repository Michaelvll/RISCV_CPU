`timescale 1ns/1ps
`include "Defines.vh"


module SimCPU();

reg clk;
reg rst;
wire Rx,Tx;
wire button = ~rst;

initial
begin
	clk= 1'b1;
	forever #10 clk = ~clk;
end

initial
begin
	rst = 1'b1;
	#5000	rst		= 	1'b0;
	#90000000 	rst		= 	1'b1;
	#10000000	$stop;
end

TopCPU top0(
	.EXclk(clk),
	.button(button),
	.Tx(Tx),
	.Rx(Rx)
);

sim_memory sm(
	.clk_i(clk),
	.rst(rst),
	.Tx(Rx),
	.Rx(Tx)
);


endmodule