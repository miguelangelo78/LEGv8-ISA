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
`define ADD    11'458 /* Add */
`define ADDI   11'488 /* Add Immediate */
`define ADDIS  11'588 /* Add Immediate and Set flags */
`define ADDS   11'558 /* Add and Set Flags */
`define AND    11'450 /* Logical And */
`define ANDI   11'490 /* Logical And Immediate */
`define ANDIS  11'790 /* Logical And Immediate and Set flags */
`define ANDS   11'750 /* Logical And and Set Flags */
`define B      11'0A0 /* Branch unconditionally */
`define BCOND  11'2A0 /* Branch conditionally */
`define BL     11'4A0 /* Branch unconditionally and link (callee address) */
`define BR     11'6B0 /* Branch unconditionally using register's value as the address */
`define CBNZ   11'5A8 /* Conditional Branch if Not Zero */
`define CBZ    11'5A0 /* Conditional Branch if Zero */
`define EOR    11'650 /* Logical Exclusive Or */
`define EORI   11'690 /* Logical Exclusive Or Immediate */
`define LDUR   11'7C2 /* Load double word (64 bits) into Register with Unscaled Offset (offset is of atomic size/not aligned, e.g. 1 byte) */
`define LDURB  11'1C2 /* Load Byte into Register with Unscalled Offset */
`define LDURH  11'3C2 /* Load Half Word (16 bits) into Register with Unscaled Offset */
`define LDURSW 11'5C4 /* Load Signed Word (32 bits signed) into Register with Unscaled Offset */
`define LDXR   11'642 /* Load Exclusive Register */
`define LSL    11'69B /* Logical Shift Left */
`define LSR    11'69A /* Logical Shift Right */
`define MOVK   11'794 /* Move Wide with Keep (without removing the 1's from the register) */
`define MOVZ   11'694 /* Move Wide with Zero (removes all 1's) */
`define ORR    11'550 /* Logical Inclusive Or */
`define ORRI   11'590 /* Logical Inclusive Or Immediate */
`define STUR   11'7C0 /* Store Register's Double Word (64 bits) into Memory with Unscaled Offset (on the mem's address) */
`define STURB  11'1C0 /* Store Register's Byte into Memory with Unscaled Offset */
`define STURH  11'3C0 /* Store Register's Half Word (16 bits) into Memory with Unscaled Offset */
`define STURW  11'5C0 /* Store Register's Word (32 bits) into Memory with Unscaled Offset */
`define STXR   11'640 /* Store Exclusive Register */
`define SUB    11'658 /* Subtract */
`define SUBI   11'688 /* Subtract Immediate  */
`define SUBIS  11'788 /* Subtract Immediate and Set Flags */
`define SUBS   11'758 /* Subtract and Set Flags */
`define MUL    11'4D8 /* Multiply */
`define SDIV   11'4D6 /* Signed Divide */
`define SMULH  11'4DA /* Signed Multiply High */
`define UDIV   11'4D6 /* Unsigned Divide */
`define UMULH  11'4DE /* Unsigned Multiply High */
/*******************************************/

/***** Microcode Unit Defines: ******/
`define CTRL_WIDTH           32
`define FUNC_WIDTH           32
`define CTRL_DEPTH           256
`define SEGMENT_MAXCOUNT     256
`define CTRL_DEPTH_ENC       ($clog2(`CTRL_DEPTH) - 1)
`define SEGMENT_MAXCOUNT_ENC ($clog2(`SEGMENT_MAXCOUNT) - 1)
`define CALLSTACK_SIZE       256
/************************************/

`define ALIGN_INSTR(val) ((val) << 2)	

`endif