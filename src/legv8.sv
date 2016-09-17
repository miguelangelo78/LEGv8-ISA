/****************************************************************************
 * legv8.sv
 ****************************************************************************/
`include "microcode.sv"
`include "stage1_fetch.sv"
`include "stage2_decode.sv"
`include "stage3_execute.sv"
`include "stage4_memory_access.sv"
`include "stage5_writeback.sv"
`include "pipeline_buffers.sv"

/**
 * Module: legv8
 * 
 * TODO: Add module documentation
 */
module LEGv8(input clk, input restart_cpu);
	/***********************************************/
	/******** Declarations and Assignments: ********/
	/***********************************************/
	
	/* Microcode Unit Declaration (aka Control Unit): */
	reg microcode_restart;
	Microcode ucode(clk, stage1_fetch.instruction[31:21], microcode_restart);
	
	/* Stage 1: Fetch */
	Stage1_Fetch stage1_fetch(stage3_execute.add_uncond, restart_cpu, ucode.ctrl[0], ucode.ctrl[1], ucode.ctrl[2], stage3_execute.zero);
	
	/* Stage 2: Decode / Register File Read */
	Stage2_Decode stage2_decode(clk, stage1_fetch.instruction, stage5_writeback.writeback_data, ucode.ctrl[3], ucode.ctrl[4]);
	
	/* Stage 3: Execute */
	Stage3_Execute stage3_execute(stage2_decode.outA, stage2_decode.outB, stage2_decode.sign_ext, {ucode.ctrl[5],ucode.ctrl[6]}, stage1_fetch.instruction[31:21], ucode.ctrl[7]);
	
	/* Stage 4: Memory Access */
	Stage4_Memory_Access stage4_memory_access(stage3_execute.result, stage2_decode.outB, ucode.ctrl[8], ucode.ctrl[9]);
	
	/* Stage 5: Writeback */
	Stage5_Writeback stage5_writeback(stage3_execute.result, stage4_memory_access.data_out, ucode.ctrl[10]);
	
	/*******************************/
	/********** Behaviour: *********/
	/*******************************/
	always@(clk or restart_cpu) begin
		if(restart_cpu) begin
			microcode_restart <= 1;
		end else
		if(clk) begin
			if(ucode.ctrl[0])
				microcode_restart <= 1;
		end else begin
			microcode_restart <= 0;
		end
	end
endmodule