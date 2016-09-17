`include "defines.sv"

module Microcode(clk, opcode, sos);

/************************* PORT DEFINITIONS *************************/
input clk;
reg [`CTRL_WIDTH:0] ctrl = 0;
input [`R_FMT_OPCODE_SZ-1:0] opcode;
/* End of segment: signals the outer system that its execution is finished, and will wait until a sos signal is received */
wire eos;
assign eos = ctrl[`CTRL_WIDTH]; /* It's the very last bit of the control bus */
/* Start of segment: triggers the execution of the next segment */
input sos;

/************************* LOCAL VARIABLES *************************/
reg [`CTRL_DEPTH_ENC:0] code_ip = 0; /* Microcode instruction pointer */
reg [`CTRL_DEPTH_ENC:0] call_stack[`CALLSTACK_SIZE];
reg [`CTRL_DEPTH_ENC:0] stack_ptr = 0;
reg [`FUNC_WIDTH + `CTRL_WIDTH + 1:0] code [0:`CTRL_DEPTH]; /* Microcode memory */
reg [`SEGMENT_MAXCOUNT_ENC:0] seg_start [`SEGMENT_MAXCOUNT]; /* Start of the segment */
reg [`SEGMENT_MAXCOUNT_ENC:0] int_seg_start [`SEGMENT_MAXCOUNT]; /* Start of the segment (for functional microcode memory) */
integer segment_counter = 0;
integer int_segment_counter = 0;
integer microinstr_ctr = 0;
reg microunit_running = 1;
reg microunit_init = 0;

/************************* FLAGS *************************/
reg flag_jmp = 0;
reg [`CTRL_DEPTH_ENC:0] flag_jmp_addr = ~0;
reg zero = 0;

/************************* SYSTEM PROCESSES *************************/

/** Execute instruction:  **/
reg [1:0] instruction_type = 0;
reg [`FUNC_WIDTH-1:0] func_fmt = 0;

task schedule_jmp;
	input [`CTRL_DEPTH_ENC:0] new_addr;
begin 
	flag_jmp_addr = new_addr;
	flag_jmp = 1;
end endtask

task push_stack;
	input [`CTRL_DEPTH_ENC:0] address;
begin
	call_stack[stack_ptr] = address;
	stack_ptr = stack_ptr + 1;
end endtask

task pop_stack; begin
	if(stack_ptr > 0) begin
		stack_ptr = stack_ptr - 1;
		schedule_jmp(call_stack[stack_ptr]);
	end
end endtask

task exec_microinstruction;
	input [`CTRL_DEPTH_ENC:0] address;
begin
	instruction_type = code[address][`CTRL_WIDTH + 2:`CTRL_WIDTH + 1];
	func_fmt = code[address][`FUNC_WIDTH + `CTRL_WIDTH + 1:(`FUNC_WIDTH + `CTRL_WIDTH + 1) - 30];
	case(func_fmt[`FUNC_WIDTH-1:`FUNC_WIDTH-4])
		4'b0000: begin /* No op */ end
		4'b0001: begin
			/* Jump to OPCODE segment on the next cycle */
			schedule_jmp(seg_start[func_fmt[`FUNC_WIDTH - 6:0]]);
			push_stack(address + 1);
		end
		4'b0010: begin
			/* Jump to INSTRUCTION/FUNCTION segment on the next cycle */
			schedule_jmp(int_seg_start[func_fmt[`FUNC_WIDTH - 6:0]]);
			push_stack(address + 1);
		end 
	endcase
	/* Fetch control from microcode memory: */
	ctrl = code[address][`CTRL_WIDTH:0];
end endtask

always@(posedge clk) begin
	/* Check for invalid/halt opcode: */
	check_microcode_running;
	if(microunit_running && code_ip != 'hFF && !sos && microunit_init) begin
		/* Check flags first: */
		if(flag_jmp) begin /* Jump flag */
			/* We found an inconditional branch (for the microcode unit, not datapath) */
			code_ip = flag_jmp_addr;
			flag_jmp = 0;
		end else begin
			/* Check if we reached End of Segment: */
			if(eos) begin
				/* We need to pop the stack */
				pop_stack;
			end else begin
				/* Otherwise continue sequential execution: */
				code_ip = code_ip + 1;
			end
		end
		/* Execute microinstruction: */
		exec_microinstruction(code_ip);
	end else begin end; /* Microcode unit is frozen. Needs to be restarted */
end

always@(posedge sos) begin
	check_microcode_running;
	microunit_init = 1;
	/* Jump to segment before fetching control: */
	if(microunit_running) begin
		code_ip = seg_start[opcode];
		/* Execute microinstruction: */
		exec_microinstruction(code_ip);
	end
end


/************************* FUNCTIONS *************************/
task check_microcode_running; begin
	microunit_running = opcode == ~6'h0 ? 1'b0 : 1'b1;
end endtask

task microinstr;
	input reg [`CTRL_WIDTH - 1:0] control;
	input reg [`FUNC_WIDTH - 1:0] func;
	input integer is_sos; /* Is start of segment? */
	input integer is_eos; /* Is end of segment? */
	input reg [1:0] seg_type; /* Is this segment dedicated for opcode execution, is it for FSM exec or is it data? */
begin
	/* Create Segment: */
	if(is_sos) begin
		if(!seg_type) begin /* Install into opcode segment: */
			seg_start[segment_counter] = microinstr_ctr;
			segment_counter = segment_counter + 1;
		end else if(seg_type == 1) begin /* Install into function code segment: */
			int_seg_start[int_segment_counter] = microinstr_ctr;
			int_segment_counter = int_segment_counter + 1;	
		end
	end
	
	/* Generate Segment Terminator signal: */
	code[microinstr_ctr] = {func, seg_type, is_eos ? 1'b1 : 1'b0, control};
	microinstr_ctr = microinstr_ctr + 1;
end endtask

task microinstr_finish; begin
	/* Fill the rest with 0s in order to keep the CPU frozen */
	for(microinstr_ctr = microinstr_ctr; microinstr_ctr < `CTRL_DEPTH; microinstr_ctr++) 
		code[microinstr_ctr] = 0;
		
	/* Fill the rest of the segment memory with invalid pointers */
	for(segment_counter = segment_counter; segment_counter < `SEGMENT_MAXCOUNT; segment_counter++)
		seg_start[segment_counter] = ~0;
	for(int_segment_counter = int_segment_counter; int_segment_counter < `SEGMENT_MAXCOUNT; int_segment_counter++)
		int_seg_start[int_segment_counter] = ~0;
end endtask

/************************** MICROCODE BEGIN SECTION **************************/
initial begin
	/* Program Microcode for each instruction here: */
	microinstr(32'b0000000000000100, 0, 1, 0, 0); /* ADD */
	microinstr(32'b0000000000001000, 0, 0, 0, 0); /* ADD */
	microinstr(32'b0000000000000001, 0, 0, 1, 0); /* Then go idle */
	
	microinstr(32'b0000000000000001, {4'b0010, 28'd2}, 1, 0, 1); /* LW and jmp to segment 3 */
	microinstr(32'b0000000000000001, 0, 0, 1, 1); /* then return (pop stack) */
	
	microinstr(32'b0000000000000001, {4'b0010, 28'd0}, 1, 0, 1); /* LW and jmp to segment 1 */
	microinstr(32'b0000000000000001, 0, 0, 1, 1); /* then return (pop stack) */
	
	microinstr(32'b0000000000000001, 0, 1, 1, 1); /* LW then return (pop stack) */
	
	microinstr(32'b0000000001001010, 0, 1, 1, 0); /* SW */
	/* ADD */
	/* SUB */
	/* AND */
	/* OR */
	/* SLT */
	/* BEQ */
	/* JMP */
	microinstr_finish;
end
endmodule
