`ifndef _Def
`define _Def

`define ZeroWord		32'h00000000
`define WriteEnable	 	1'b1
`define WriteDisable	1'b0
`define ReadEnable		1'b1
`define ReadDisable	 	1'b0
`define Instvalid		1'b1 
`define InstInvalid	 	1'b0
`define InstAddrBus	 	31: 0
`define InstBus		 	31: 0

`define AluOpBus		7:0
`define AluSelBus		2:0

`define ChipEnable		1'b1
`define ChipDisable		1'b0

// ============ Instruction related =================
// opcode related
`define EXE_LUI			7'b0110111
`define EXE_AUIPC		7'b0010111

// AluOp
`define EXE_OR_OP		8'b00100101
`define EXE_NOP_OP		8'b00000000

// AluSel
`define EXE_RES_LOGIC	3'b001

`define EXE_RES_NOP		3'b000



// ============= Register file related ===============
`define RegAddrBus		4: 0
`define RegAddrBus		31: 0
`define RegAddrWidth	5
`define RegWidth		32

`define NOPRegAddr		5'b00000


`endif