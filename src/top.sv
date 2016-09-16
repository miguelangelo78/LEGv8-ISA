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
		$dumpvars(0, top);
		#50; $finish;
	end
endmodule
