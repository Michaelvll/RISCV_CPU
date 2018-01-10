`ifndef _RESICV_MIN_SOPC
`define _RESICV_MIN_SOPC
`timescale 1ns/1ps


`include "Defines.vh"
`include "IDInstDef.vh"
`define DEBG

module TopCPU(
	input wire EXclk,
	input wire button,
    output wire led,
	output wire Tx,
	input wire Rx
);


// ================== rst & clk =========================

assign led = button;

reg rst;
reg rst_delay;

wire clk;
wire clk_uart;
// clk_wiz_0 clk0(.clk_out1(clk), .clk_out2(clk_uart), .reset(1'b0), .clk_in1(EXclk));
clk_wiz_0 clk0(.clk_out1(clk), .reset(1'b0), .clk_in1(EXclk));


always @(posedge clk or negedge button)
begin
	if (!button)
	begin
		rst			<=	1'b1;
		rst_delay	<=	1'b1;
	end
	else 
	begin
		rst_delay	<=	1'b0;
		rst			<=	rst_delay;
	end
end

// ================== uart =============================
wire 		UART_send_flag;
wire [7:0]	UART_send_data;
wire 		UART_recv_flag;
wire [7:0]	UART_recv_data;
wire		UART_sendable;
wire		UART_receivable;
// uart_comm #(.BAUDRATE(300000000/*115200*/), .CLOCKRATE(1000000000)) UART(
`ifndef DEBG
uart_comm UART(	
`else
uart_comm #(.SAMPLE_INTERVAL(`SampleInterval)) UART(	
`endif

		clk, rst,
		UART_send_flag, UART_send_data,
		UART_recv_flag, UART_recv_data,
		UART_sendable, UART_receivable,
		Tx, Rx);


localparam CHANNEL_BIT = 1;
localparam MESSAGE_BIT = 72;
localparam CHANNEL = 1 << CHANNEL_BIT;


wire 					COMM_r_flag[CHANNEL-1:0];
wire [MESSAGE_BIT-1:0]	COMM_r_data[CHANNEL-1:0];
wire [4:0]				COMM_r_length[CHANNEL-1:0];
wire 					COMM_w_flag[CHANNEL-1:0];
wire [MESSAGE_BIT-1:0]	COMM_w_data[CHANNEL-1:0];
wire [4:0]				COMM_w_length[CHANNEL-1:0];
wire					COMM_readable[CHANNEL-1:0];
wire					COMM_writable[CHANNEL-1:0];


multchan_comm #(.MESSAGE_BIT(MESSAGE_BIT), .CHANNEL_BIT(CHANNEL_BIT)) COMM(
	clk, rst,
	UART_send_flag, UART_send_data,
	UART_recv_flag, UART_recv_data,
	UART_sendable, UART_receivable,
	{COMM_r_flag[1], COMM_r_flag[0]},
	{COMM_r_length[1], COMM_r_data[1], COMM_r_length[0], COMM_r_data[0]},
	{COMM_w_flag[1], COMM_w_flag[0]},
	{COMM_w_length[1], COMM_w_data[1], COMM_w_length[0], COMM_w_data[0]},
	{COMM_readable[1], COMM_readable[0]},
	{COMM_writable[1], COMM_writable[0]}
);


// ================== memory controller ========================

wire [2*2-1:0]	mem_rw_flag;
wire [2*32-1:0]	mem_addr;
wire [2*32-1:0]	mem_r_data;
wire [2*32-1:0]	mem_w_data;
wire [2*4-1:0]	mem_w_mask;
wire [1:0]		mem_busy;
wire [1:0]		mem_done;

memory_controller MEM_CTRL(
		clk, rst,
		COMM_w_flag[0], COMM_w_data[0], COMM_w_length[0],
		COMM_r_flag[0], COMM_r_data[0], COMM_r_length[0],
		COMM_writable[0], COMM_readable[0],
		mem_rw_flag, mem_addr,
		mem_r_data, mem_w_data, mem_w_mask,
		mem_busy, mem_done);

// ================== cpu =======================================


cpu cpu0(
	.clk(clk),
	.rst(rst),

	.mem_rw_flag_o(mem_rw_flag),
	.mem_addr_o(mem_addr),
	.mem_r_data_i(mem_r_data),
	.mem_w_data_o(mem_w_data),
	.mem_w_mask_o(mem_w_mask),
	.mem_busy_i(mem_busy),
	.mem_done_i(mem_done)
);



endmodule

`endif