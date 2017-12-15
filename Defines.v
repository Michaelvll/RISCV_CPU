`ifndef _Def
`define _Def

`define RstEnable       1'b1
`define RstDisabel      1'b0
`define Zero            32'h00000000
`define WriteEnable     1'b1
`define WriteDisable    1'b0
`define ReadEnable      1'b1
`define ReadDisable     1'b0
`define Instvalid       1'b1 
`define InstInvalid     1'b0
`define InstAddrBus     31: 0
`define InstBus         31: 0


`define RegAddrBus      4: 0
`define RegAddrBus      31: 0
`define RegWidth        32

`define ChipEnable      1'b1
`define ChipDisable     1'b0

`endif