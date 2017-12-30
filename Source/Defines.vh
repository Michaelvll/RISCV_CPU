`ifndef _Def
`define _Def
// Attention: this may cause the speed of ID too slow to finish in a cycle
`define ID_BRANCHES
// Attention: this may be slowwer then the former one!!!
`define ID_JALR


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

// ============= Data ram related ===============
`define DataAddrBus 31:0
`define DataAddrWidth 32
`define DataBus 31:0
`define DataWidth 32
`define DataMemNum 131071
`define DataMemNumLog2 17
`define ByteBus 7:0




`endif