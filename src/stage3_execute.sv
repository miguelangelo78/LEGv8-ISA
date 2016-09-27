/****************************************************************************
 * stage3_execute.sv
 ****************************************************************************/
`include "defines.sv"

/**
 * Module: ALU
 * 
 * TODO: Add module documentation
 */
module ALU(opA, opB, func, zero, result);
	input [`LEGV8_INTEGER_SZ-1:0] opA, opB;
	input [3:0] func;
	output zero;
	output [`LEGV8_INTEGER_SZ-1:0] result;
	assign result = 
		func == 4'b0000 ? opA & opB : 
		func == 4'b0001 ? opA | opB :
		func == 4'b0010 ? opA + opB :
		func == 4'b0110 ? opA - opB :
		func == 4'b0111 ? (opA < opB ? 1 : 0) :
		func == 4'b1100 ? ~(opA | opB) : 'hX;
	assign zero = !result ? 1 : 0;
endmodule

/**
 * Module: Stage3_Execute
 * 
 * TODO: Add module documentation
 */
module Stage3_Execute(
	input [`LEGV8_INTEGER_SZ-1:0] opA,
	input [`LEGV8_INTEGER_SZ-1:0] opB,
	input [`LEGV8_INTEGER_SZ-1:0] pc,
	input [`LEGV8_INTEGER_SZ-1:0] sign_ext,
	input [1:0]                   aluop,
	input [10:0]                  opcode,
	input                         alusrc
);
	wire zero;
	wire [`LEGV8_INTEGER_SZ-1:0] result;
	wire [`LEGV8_INTEGER_SZ-1:0] add_uncond = `ALIGN_INSTR(sign_ext) + pc;
	
	ALU alu(opA, alusrc ? sign_ext : opB, 4'b0, zero, result);
endmodule
