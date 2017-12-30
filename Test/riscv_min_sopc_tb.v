`timescale 1ns/1ps

module riscv_min_sopc_tb();

reg CLOCK_50;
reg rst;

initial
begin
	CLOCK_50 = 1'b1;
	forever #10 CLOCK_50 = ~CLOCK_50;
end

initial
begin
	rst = 1'b1;
	#1 		rst		= 	1'b0;
	#1900 	rst		= 	1'b1;
	#2000 	$stop;
end

TopCPU top0(
	.clk(CLOCK_50),
	.rst(rst)
);


endmodule