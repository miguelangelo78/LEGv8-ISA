/****************************************************************************
 * top.sv
 ****************************************************************************/
`include "legv8.sv"

/*
 * Module: top
 */
module top;
	reg clk = 0, restart_cpu = 0;
	always begin #1 clk = ~clk; end
	
	LEGv8 legv8(clk, restart_cpu);
	
	initial begin
		$dumpfile("top.vcd");
		$dumpvars(0, legv8);
		restart_cpu = 1;
		#1;
		restart_cpu = 0;
		#50; $finish;
	end
endmodule
