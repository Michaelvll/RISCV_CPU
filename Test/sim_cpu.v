`timescale 1ns/1ps

module SimCPU();

reg CLOCK_50;
reg rst;
wire Rx,Tx;

initial
begin
	CLOCK_50 = 1'b0;
	rst = 1'b1;
	#1 		rst		= 	1'b0;
	#1900 	rst		= 	1'b1;
	#2000 	$stop;
	forever #10 CLOCK_50 = ~CLOCK_50;
end

TopCPU top0(
	.EXclk(CLOCK_50),
	.button(rst),
	.Tx(Tx),
	.Rx(Rx)
);

sim_memory sm(
	.clk(CLOCK_50),
	.rst(rst),
	.Tx(Tx),
	.Rx(Rx)
);


endmodule