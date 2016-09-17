`ifndef DEFINES_SV_
`define DEFINES_SV_
	
/****************************************************************************
 * defines.sv
 ****************************************************************************/

/***** LEGv8 Instruction Set Defines:  *****/
`define LEGV8_INSTRUCTION_SZ   32
`define LEGV8_INTEGER_SZ       64
`define LEGV8_REGISTER_COUNT   32
	
`define R_FMT_OPCODE_SZ        11
`define R_FMT_RM_SZ            5
`define R_FMT_SHAMT_SZ         6
`define R_FMT_RN_SZ            5
`define R_FMT_RD_SZ            5

`define I_FMT_OPCODE_SZ        10
`define I_FMT_ALUI_SZ          12
`define I_FMT_RN_SZ            5
`define I_FMT_RD_SZ            5

`define D_FMT_OPCODE_SZ        11
`define D_FMT_DT_ADDR_SZ       9
`define D_FMT_OP_SZ            2
`define D_FMT_RN_SZ            5
`define D_FMT_RT_SZ            5

`define B_FMT_OPCODE_SZ        6
`define B_FMT_BR_ADDR          26

`define CB_FMT_OPCODE_SZ       8
`define CB_FMT_COND_BR_ADDR_SZ 19
`define CB_FMT_RT_SZ           5

`define IW_FMT_OPCODE_SZ       11
`define IW_FMT_MOVI_SZ         16
`define IW_FMT_RD_SZ           5
	
/* Instruction Opcodes: */
`define ADD 11'458
`define ADDI 11'488
`define ADDIS 11'588
`define ADDS 11'558
`define AND 11'450
`define ANDI 11'490
`define ANDIS 11'790
`define ANDS 11'750
`define B 11'0A0
`define BCOND 11'2A0
`define BL 11'4A0
`define BR 11'6B0
`define CBNZ 11'5A8
`define CBZ 11'5A0
`define EOR 11'650
`define EORI 11'690
`define LDUR 11'7C2
`define LDURB 11'1C2
`define LDURH 11'3C2
`define LDURSW 11'5C4
`define LDXR 11'642
`define LSL 11'69B
`define LSR 11'69A
`define MOVK 11'794
`define MOVZ 11'694
`define ORR 11'550
`define ORRI 11'590
`define STUR 11'7C0
`define STURB 11'1C0
`define STURH 11'3C0
`define STURW 11'5C0
`define STXR 11'640
`define SUB 11'658
`define SUBI 11'688
`define SUBIS 11'788
`define SUBS 11'758
`define MUL 11'4D8
`define SDIV 11'4D6
`define SMULH 11'4DA
`define STURS 11'7E2
`define STURD 11'7E0
`define UDIV 11'4D6
`define UMULH 11'4DE
/*******************************************/

/***** Microcode Unit Defines: ******/
`define CTRL_WIDTH 32
`define FUNC_WIDTH 32
`define CTRL_DEPTH 256
`define SEGMENT_MAXCOUNT 256
`define CTRL_DEPTH_ENC ($clog2(`CTRL_DEPTH) - 1)
`define SEGMENT_MAXCOUNT_ENC ($clog2(`SEGMENT_MAXCOUNT) - 1)
`define CALLSTACK_SIZE 256
/************************************/

`define ALIGN_INSTR(val) ((val) << 2)	

`endif