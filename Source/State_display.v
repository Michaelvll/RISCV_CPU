`timescale 1 ns / 1 ps

module State_display (
	input wire 			cpu_state,
	input wire 			clk,
	output reg[3:0] 	sel,
	output reg[6:0] 	light,
	output reg[15:0] 	leds,
	input wire			leds_switch
	);

localparam STATE_O	=	0;
localparam STATE_F1	=	1;
localparam STATE_F2	=	2;
localparam STATE_C	=	3;
localparam STATE_P	=	4;
localparam STATE_U	=	5;

parameter  period	= 100000;
parameter  leds_period = 5000000;

reg[5: 0] state;
reg[31:0] cnt;
reg[31:0] cnt2;
reg clkout;
reg leds_clkout;

integer j;
initial
begin
	cnt		= 0;
	cnt2	= 0;
	state 	= STATE_O;
end

always @( posedge clk)      //分频50Hz
begin 
	cnt			<= cnt+1;
	cnt2		<=	cnt2+1;
	if (cnt	== (period >> 1) - 1)               
		clkout 	<= 1'b1;
	else if (cnt == period - 1)                    
	begin 
		clkout 	<= 1'b0;
		cnt 	<= 32'b0;      
	end

	if (cnt2	== (leds_period >> 1) - 1)
	begin             
		leds_clkout 	<= 	1'b1;
	end
	else if (cnt2 == leds_period - 1)                    
	begin 
		leds_clkout 	<= 1'b0;
		cnt2			<= 32'b0;
	end

end

always @(posedge leds_clkout)
begin
	if(leds_switch)
	begin
		if (!leds)
			leds <= 16'b1;
		else
			leds <= leds << 1;
	end
	else
		leds	<=	16'b0;

end

always @(posedge clkout)          
begin 
	if (cpu_state)
	begin
		case (state)
		STATE_O:
		begin
			sel 	<=	4'b0111;
			light	<=	7'b0000001;
			state	<=	STATE_F1;
		end
		STATE_F1:
		begin
			sel 	<=	4'b1011;
			light	<=	7'b0111000;
			state	<=	STATE_F2;
		end
		STATE_F2:
		begin
			sel 	<=	4'b1101;
			light	<=	7'b0111000;
			state	<=	STATE_O;
		end
		default:
			state	<=	STATE_O;
		endcase
	end
	else
	begin
		case (state)
		STATE_C:
		begin
			sel 	<=	4'b0111;
			light	<=	7'b0110001;
			state	<=	STATE_P;
		end
		STATE_P:
		begin
			sel 	<=	4'b1011;
			light	<=	7'b0011000;
			state	<=	STATE_U;
		end
		STATE_U:
		begin
			sel 	<=	4'b1101;
			light	<=	7'b1000001;
			state	<=	STATE_C;
		end
		default:
			state	<=	STATE_C;	
		endcase
	end
end
    
endmodule