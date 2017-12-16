`ifndef _Def
`define _Def

`define ZeroWord		32'h00000000
`define WriteEnable	 	1'b1
`define WriteDisable	1'b0
`define ReadEnable		1'b1
`define ReadDisable	 	1'b0
`define InstValid		1'b1 
`define InstInvalid	 	1'b0
`define InstAddrBus	 	31: 0
`define InstBus		 	31: 0
`define InstAddrWidth	32
`define InstMemNum		131071
`define InstMemNumLog2	17

`define AluOpBus		9:0
`define AluOutSelBus	2:0

`define ChipEnable		1'b1
`define ChipDisable		1'b0

// ============= Register file related ===============
`define RegAddrBus		4: 0
`define RegAddrWidth	5
`define RegBus			31: 0
`define RegWidth		32

`define NOPRegAddr		5'b00000

// ============= ALU related =======================
// AluOp
`define EX_OR_OP		10'b0010011110
`define EX_NOP_OP		10'b0000000000

// AluSel
`define EX_RES_LOGIC	3'b001
`define EX_RES_NOP		3'b000





`endif