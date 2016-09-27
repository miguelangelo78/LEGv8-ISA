/****************************************************************************
 * stage1_fetch.sv
 ****************************************************************************/
`include "defines.sv"
`include "instruction_memory.sv"

/**
 * Module: Program_Counter
 * 
 * TODO: Add module documentation
 */
module Program_Counter(
	input [`LEGV8_INTEGER_SZ-1:0]  addr_in, 
	input                          wr,
	input                          reset,
	output [`LEGV8_INTEGER_SZ-1:0] addr_out
);
	reg [`LEGV8_INTEGER_SZ-1:0] latched_addr = 0;
	always@(wr or reset) begin
		if(wr)
			latched_addr = addr_in;
		else if(reset)
			latched_addr = 0;
	end
	assign addr_out = latched_addr;
endmodule

/**
 * Module: Stage1_Fetch
 * 
 * TODO: Add module documentation
 */
module Stage1_Fetch(
	input [`LEGV8_INTEGER_SZ-1:0] new_pc,
	input reset,
	input next,
	input branch_flag,
	input uncond_branch_flag,
	input zero_flag
);
	wire[`LEGV8_INSTRUCTION_SZ-1:0] instruction;
	wire[`LEGV8_INTEGER_SZ-1:0]     pc_out;
	
	Program_Counter pc(((branch_flag & zero_flag) | uncond_branch_flag) ? new_pc : pc_out + 4, next, reset, pc_out);
	Instruction_Memory imem(pc_out, instruction);
	
	/* 1st Stage's Pipeline buffers: */
	reg[`LEGV8_INSTRUCTION_SZ+`LEGV8_INTEGER_SZ-1:0]pipe_in;
	reg[`LEGV8_INSTRUCTION_SZ+`LEGV8_INTEGER_SZ-1:0]pipe_out;
	
	always@(next) begin
		pipe_out = pipe_in;
		pipe_in  = {instruction, pc_out};
	end
endmodule
