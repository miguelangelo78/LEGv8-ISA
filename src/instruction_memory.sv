/****************************************************************************
 * instruction_memory.sv
 ****************************************************************************/
`include "defines.sv"

/**
 * Module: Instruction_Memory
 * 
 * TODO: Add module documentation
 */
module Instruction_Memory(
	input  [`LEGV8_INTEGER_SZ-1:0]     address, 
	output [`LEGV8_INSTRUCTION_SZ-1:0] instruction
);
	reg [7:0] mem [0:256];
	assign instruction = (mem[address + 3] << 24) | (mem[address + 2] << 16) | (mem[address + 1] << 8) | (mem[address]);
	
	/* Write R-Type Instruction: */
	integer write_counter = 0;
	integer aligned_pc    = 0;
	task write_r;
		input [`R_FMT_OPCODE_SZ-1:0] opcode;
		input [`R_FMT_RM_SZ-1:0]     rm;
		input [`R_FMT_SHAMT_SZ-1:0]  shamt;
		input [`R_FMT_RN_SZ-1:0]     rn;
		input [`R_FMT_RD_SZ-1:0]     rd;
	begin
		aligned_pc = `ALIGN_INSTR(write_counter);
		mem[aligned_pc + 3] = {opcode[10:3]};
		mem[aligned_pc + 2] = {opcode[2:0], rm};
		mem[aligned_pc + 1] = {shamt, rn[4:3]};
		mem[aligned_pc]     = {rn[2:0], rd};
		write_counter = write_counter + 1;
	end
	endtask
	
	/* Write I-Type Instruction: */
	task write_i;
		input[`I_FMT_OPCODE_SZ:0] opcode; /* This must be always 11 bits wide */
		input[`I_FMT_ALUI_SZ-1:0] alui;
		input[`I_FMT_RN_SZ-1:0]   rn;
		input[`I_FMT_RD_SZ-1:0]   rd;
	begin
		aligned_pc = `ALIGN_INSTR(write_counter);
		mem[aligned_pc + 3] = {opcode[10:3]};
		mem[aligned_pc + 2] = {opcode[2:1], alui[11:6]};
		mem[aligned_pc + 1] = {alui[5:0], rn[4:3]};
		mem[aligned_pc]     = {rn[2:0], rd};
		write_counter = write_counter + 1;
	end
	endtask
	
	/* Write D-Type Instruction: */
	task write_d;
		input[`D_FMT_OPCODE_SZ-1:0]  opcode;
		input[`D_FMT_DT_ADDR_SZ-1:0] dt_addr;
		input[`D_FMT_OP_SZ-1:0]      op;
		input[`D_FMT_RN_SZ-1:0]      rn;
		input[`D_FMT_RT_SZ-1:0]      rt;
	begin
		aligned_pc = `ALIGN_INSTR(write_counter);
		mem[aligned_pc + 3] = {opcode[10:3]};
		mem[aligned_pc + 2] = {opcode[2:0], dt_addr[8:4]};
		mem[aligned_pc + 1] = {dt_addr[3:0], op, rn[4:3]};
		mem[aligned_pc]     = {rn[2:0], rt};
		write_counter = write_counter + 1;
	end
	endtask

	/* Write B-Type Instruction: */
	/* TODO: Fix the bloody opcode 6 bits versus 8 bits' 0xA0 */
	task write_b;
		input[`R_FMT_OPCODE_SZ-1:0] opcode; /* This must be always 11 bits wide */
		input[`B_FMT_BR_ADDR-1:0]   br_addr;
	begin
		aligned_pc = `ALIGN_INSTR(write_counter);
		mem[aligned_pc + 3] = {opcode[5:0], br_addr[25:24]};
		mem[aligned_pc + 2] = {br_addr[23:16]};
		mem[aligned_pc + 1] = {br_addr[15:8]};
		mem[aligned_pc]     = {br_addr[7:0]};
		write_counter = write_counter + 1;		
	end
	endtask

	/* Write CB-Type Instruction: */
	/* TODO: Fix the bloody opcode 8 bits versus 11 bits' 0x5A8 */
	task write_cb;
		input[`R_FMT_OPCODE_SZ-1:0]        opcode; /* This must be always 11 bits wide */
		input[`CB_FMT_COND_BR_ADDR_SZ-1:0] cond_br_addr;
		input[`CB_FMT_RT_SZ-1:0]           rt;
	begin
		aligned_pc = `ALIGN_INSTR(write_counter);
		mem[aligned_pc + 3] = {opcode[7:0]};
		mem[aligned_pc + 2] = {cond_br_addr[18:11]};
		mem[aligned_pc + 1] = {cond_br_addr[10:3]};
		mem[aligned_pc]     = {cond_br_addr[2:0], rt};
		write_counter = write_counter + 1;		
	end
	endtask
	
	/* Write IW-Type Instruction: */
	task write_iw;
		input[`R_FMT_OPCODE_SZ-1:0] opcode; /* This must be always 11 bits wide */
		input[`IW_FMT_MOVI_SZ-1:0]  movi;
		input[`IW_FMT_RD_SZ-1:0]    rd;
	begin
		aligned_pc = `ALIGN_INSTR(write_counter);
		mem[aligned_pc + 3] = {opcode[10:3]};
		mem[aligned_pc + 2] = {opcode[2:0], movi[15:11]};
		mem[aligned_pc + 1] = {movi[10:3]};
		mem[aligned_pc]     = {movi[2:0], rd};
		write_counter = write_counter + 1;	
	end
	endtask
	
	/****************************************************************/
	/***************** Fill Instruction Memory here *****************/
	/****************************************************************/
	initial begin
		write_iw(0, 'hFEBA, 9);
		write_iw(1, 'hFEBA, 9);

	end
endmodule
