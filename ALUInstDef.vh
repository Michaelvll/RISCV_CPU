`define AluOpBus		10:0
`define AluOutSelBus	2:0

// ============= ALU related =======================
// AluOp

// CAN BE OPTIMIZED TO SHORTER SIZE!!!!!!

`define EX_ADD_OP     	11'b00100110000 // Add and sub Overflows are ignored
`define EX_SUB_OP       11'b00100110001
`define EX_SLT_OP     	11'b00100110100
`define EX_SLTU_OP    	11'b00100110110 // compares the values as unsigned numbers (i.e., the immediate is rst sign-extended XLEN bits then treated as an unsigned number).
`define EX_XOR_OP     	11'b00100111000
`define EX_OR_OP      	11'b00100111100
`define EX_AND_OP     	11'b00100111110
`define EX_SLL_OP     	11'b00100110010 // Shift value in rs1 by the shift amoount in rs2[4:0]
`define EX_SRL_OP		11'b00100111010
`define EX_SRA_OP		11'b00100111011





`define EX_NOP_OP		11'b00000000000

// AluSel
`define EX_RES_LOGIC	3'b001
`define EX_RES_SHIFT    3'b010
`define EX_RES_ARITH    3'b011
`define EX_RES_NOP		3'b000