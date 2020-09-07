`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:16:25 09/07/2020
// Design Name:   PA_Core
// Module Name:   /home/hakaru/Projects/Verilog/PA_Architecture/PA_Architecture/coreTest.v
// Project Name:  PA_Architecture
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: PA_Core
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module coreTest;

	// Inputs
	reg clock_i;
	reg reset_i;

	// Outputs
	wire wbAFinal_o;
	wire [4:0] wbAddrAFinal_o;
	wire [15:0] wbValAFinal_o;

	// Instantiate the Unit Under Test (UUT)
	PA_Core uut (
		.clock_i(clock_i), 
		.reset_i(reset_i), 
		.wbAFinal_o(wbAFinal_o), 
		.wbAddrAFinal_o(wbAddrAFinal_o), 
		.wbValAFinal_o(wbValAFinal_o)
	);
integer i;
	initial begin
		// Initialize Inputs
		clock_i = 0;
		reset_i = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		reset_i = 1;
		clock_i = 1;
		#1;
		clock_i = 0;
		reset_i = 0;
		
		#1;
		clock_i = 1;
		#1;
		clock_i = 0;

		
		for(i = 0; i < 10; i = i + 1)
		begin
			#1;
			clock_i = 1;
			#1;
			clock_i = 0;
		end
		
        
		// Add stimulus here

	end
      
endmodule

