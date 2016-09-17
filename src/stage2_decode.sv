/****************************************************************************
 * Stage2_Decode.sv
 ****************************************************************************/
`include "defines.sv"

/**
 * Module: Registers
 * 
 * TODO: Add module documentation
 */
module Registers(clk, readreg1, readreg2, writereg, writedata, outA, outB, regwr);
	input clk;
	input [$clog2(`LEGV8_REGISTER_COUNT)-1:0] readreg1, readreg2, writereg;
	input [`LEGV8_INTEGER_SZ-1:0] writedata;
	output reg [`LEGV8_INTEGER_SZ-1:0] outA = 0;
	output reg [`LEGV8_INTEGER_SZ-1:0] outB = 0;
	input regwr;
	
	reg [`LEGV8_INTEGER_SZ-1:0] regfile [0:`LEGV8_REGISTER_COUNT];
	
	always@(clk or regwr) begin
		if(clk) begin
			outA = regfile[readreg1];
			outB = regfile[readreg2];
		end else
		if(regwr) begin
			regfile[writereg] = writedata;
		end
	end
	
	initial begin
		integer i;
		for(i = 0; i < `LEGV8_REGISTER_COUNT; i++) regfile[i] = 0;
	end
endmodule

/**
 * Module: Stage2_Decode
 * 
 * TODO: Add module documentation
 */
module Stage2_Decode(
	input clk, 
	input [`LEGV8_INSTRUCTION_SZ-1:0] instruction, 
	input [`LEGV8_INTEGER_SZ-1:0] writedata, 
	input reg2loc, 
	input regwrite
);
	wire [`LEGV8_INTEGER_SZ-1:0] outA;
	wire [`LEGV8_INTEGER_SZ-1:0] outB;
	wire [`LEGV8_INTEGER_SZ-1:0] sign_ext = {32'b0, instruction};
	Registers registers(clk, instruction[9:5], reg2loc ? instruction[4:0] : instruction[20:16], instruction[4:0], writedata, outA, outB, regwrite);
endmodule
