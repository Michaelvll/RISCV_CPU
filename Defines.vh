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

`define ChipEnable		1'b1
`define ChipDisable		1'b0

// ============= Register file related ===============
`define RegAddrBus		4: 0
`define RegAddrWidth	5
`define RegBus			31: 0
`define RegWidth		32

`define NOPRegAddr		5'b00000







`endif