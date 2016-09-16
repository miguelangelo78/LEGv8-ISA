/****************************************************************************
 * defines.sv
 ****************************************************************************/

/***** Microcode Unit Defines: ******/
`define CTRL_WIDTH 32
`define FUNC_WIDTH 32
`define CTRL_DEPTH 256
`define SEGMENT_MAXCOUNT 256
`define CTRL_DEPTH_ENC ($clog2(`CTRL_DEPTH) - 1)
`define SEGMENT_MAXCOUNT_ENC ($clog2(`SEGMENT_MAXCOUNT) - 1)
`define CALLSTACK_SIZE 256
/************************************/

module defines; endmodule