`ifndef _IF
`define _IF

`include "Defines.vh"
`include "pc_reg.v"

module IF (
    input wire  clk,
    input wire  rst,

    output reg[`InstBus]    inst
);

wire [`InstAddrBus] if_pc;

pc_reg pc (
    .rst(rst),
    .pc(if_pc),
    .ce(ce)
);

always @ (posedge clk)
begin
    if (rst) 
        inst <= `ZeroWord;
    else
    begin
        
    end
end

endmodule





`endif