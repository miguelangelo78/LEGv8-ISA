/****************************************************************************
 * stage5_writeback.sv
 ****************************************************************************/
`include "defines.sv"

/**
 * Module: Stage5_Writeback
 * 
 * TODO: Add module documentation
 */
module Stage5_Writeback(
	input [`LEGV8_INTEGER_SZ-1:0] val_stage3_execute, 
	input [`LEGV8_INTEGER_SZ-1:0] val_stage4_memacc,
	input memtoreg
);
	wire [`LEGV8_INTEGER_SZ-1:0] writeback_data = memtoreg ? val_stage4_memacc : val_stage3_execute;
endmodule


