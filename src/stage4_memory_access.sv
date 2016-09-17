/****************************************************************************
 * stage4_memory_access.sv
 ****************************************************************************/
`include "defines.sv"

/**
 * Module: Data_Memory
 * 
 * TODO: Add module documentation
 */
module Data_Memory(address, data_in, data_out, memread, memwrite);
	input  [`LEGV8_INTEGER_SZ-1:0] address;
	input  [`LEGV8_INTEGER_SZ-1:0] data_in;
	output [`LEGV8_INTEGER_SZ-1:0] data_out;
	input memread, memwrite;
	
	reg [`LEGV8_INTEGER_SZ-1:0] memory [0:256];
	
	assign data_out = memread ? memory[address] : 'hZ;
	always@(posedge memwrite) memory[address] = data_in;
		
	initial begin
		memory[0] = 1;
		memory[1] = 3;
		memory[2] = 5;
		memory[3] = 7;
		memory[4] = 9;
	end
endmodule

/**
 * Module: Stage4_Memory_Access
 * 
 * TODO: Add module documentation
 */
module Stage4_Memory_Access(
	input [`LEGV8_INTEGER_SZ-1:0] address,
	input [`LEGV8_INTEGER_SZ-1:0] data_in,
	input                         memwrite,
	input                         memread
);
	wire [`LEGV8_INTEGER_SZ-1:0] data_out;
	Data_Memory data_memory(address, data_in, data_out, memread, memwrite);
endmodule
