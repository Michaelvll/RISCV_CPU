// Code by Evensgn
// Last Modify: 2017-12-16

// ============ ID instruction related ===============
// opcode related
`define OP_LUI      7'b0110111
`define OP_AUIPC    7'b0010111
`define OP_JAL      7'b1101111
`define OP_JALR     7'b1100111
`define OP_BRANCH   7'b1100011
`define OP_LOAD     7'b0000011
`define OP_STORE    7'b0100011
`define OP_OPI		7'b0010011
`define OP_OP       7'b0110011
`define OP_MISC_MEM 7'b0001111

// funct3
// JALR
`define FUNCT3_JALR 3'b000
// BRANCH
`define FUNCT3_BEQ  3'b000
`define FUNCT3_BNE  3'b001
`define FUNCT3_BLT  3'b100
`define FUNCT3_BGE  3'b101
`define FUNCT3_BLTU 3'b110
`define FUNCT3_BGEU 3'b111
// LOAD
`define FUNCT3_LB   3'b000
`define FUNCT3_LH   3'b001
`define FUNCT3_LW   3'b010
`define FUNCT3_LBU  3'b100
`define FUNCT3_LHU  3'b101
// STORE
`define FUNCT3_SB   3'b000
`define FUNCT3_SH   3'b001
`define FUNCT3_SW   3'b010
// OP-IMM
`define FUNCT3_ADDI      3'b000
`define FUNCT3_SLTI      3'b010
`define FUNCT3_SLTIU     3'b011
`define FUNCT3_XORI      3'b100
`define FUNCT3_ORI       3'b110
`define FUNCT3_ANDI      3'b111
`define FUNCT3_SLLI      3'b001
`define FUNCT3_SRLI_SRAI 3'b101
// OP
`define FUNCT3_ADD_SUB 3'b000
`define FUNCT3_SLL     3'b001
`define FUNCT3_SLT     3'b010
`define FUNCT3_SLTU    3'b011
`define FUNCT3_XOR     3'b100
`define FUNCT3_SRL_SRA 3'b101
`define FUNCT3_OR      3'b110
`define FUNCT3_AND     3'b111
// MISC-MEM
`define FUNCT3_FENCE  3'b000
`define FUNCT3_FENCEI 3'b001

// funct7
`define FUNCT7_SLLI 7'b0000000
// SRLI_SRAI
`define FUNCT7_SRLI 7'b0000000
`define FUNCT7_SRAI 7'b0100000
// ADD_SUB
`define FUNCT7_ADD  7'b0000000
`define FUNCT7_SUB  7'b0100000
`define FUNCT7_SLL  7'b0000000
`define FUNCT7_SLT  7'b0000000
`define FUNCT7_SLTU 7'b0000000
`define FUNCT7_XOR  7'b0000000
// SRL_SRA
`define FUNCT7_SRL 7'b0000000
`define FUNCT7_SRA 7'b0100000
`define FUNCT7_OR  7'b0000000
`define FUNCT7_AND 7'b0000000
