`timescale 1ns/1ps

module SimCPU();

reg clk;
reg rst;
wire Rx,Tx;

initial
begin
	clk= 1'b1;
	forever #10 clk = ~clk;
end

initial
begin
	rst = 1'b1;
	#10	rst		= 	1'b0;
	#900000 	rst		= 	1'b1;
	#100000 	$stop;
end

TopCPU top0(
	.EXclk(clk),
	.button(rst),
	.Tx(Tx),
	.Rx(Rx)
);

sim_memory sm(
	.clk(clk),
	.rst(rst),
	.Tx(Rx),
	.Rx(Tx)
);


endmodule