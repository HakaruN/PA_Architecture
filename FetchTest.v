`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:45:54 09/10/2020
// Design Name:   Fetch
// Module Name:   /home/hakaru/Projects/Verilog/PA_Architecture/PA_Architecture/FetchTest.v
// Project Name:  PA_Architecture
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Fetch
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FetchTest;

	// Inputs
	reg clock_i;
	reg reset_i;
	reg flushBack_i;
	reg shouldBranch_i;
	reg [15:0] branchOffset_i;
	reg branchDirection_i;

	// Outputs
	wire [59:0] data_o;
	wire enable_o;

	// Instantiate the Unit Under Test (UUT)
	Fetch uut (
		.clock_i(clock_i), 
		.reset_i(reset_i), 
		.flushBack_i(flushBack_i), 
		.shouldBranch_i(shouldBranch_i), 
		.branchOffset_i(branchOffset_i), 
		.branchDirection_i(branchDirection_i), 
		.data_o(data_o), 
		.enable_o(enable_o)
	);

integer i;
	initial begin
		// Initialize Inputs
		clock_i = 0;
		reset_i = 0;
		flushBack_i = 0;
		shouldBranch_i = 0;
		branchOffset_i = 0;
		branchDirection_i = 0;

		// Wait 100 ns for global reset to finish
		#100;
		//reset
		reset_i = 1;
		clock_i = 1;		
		#1;
		reset_i = 0;
		clock_i = 0;
		
		for(i = 0; i < 10; i = i + 1)
		begin
			#1
			clock_i = 1;
			#1;
			clock_i = 0;
		end
		
		//branch forwards
      shouldBranch_i = 1;
		branchOffset_i = 10;//10 places
		branchDirection_i = 1;//forwards
		#1
		clock_i = 1;
		#1;//halt branch
		shouldBranch_i = 0;
		branchOffset_i = 0;
		branchDirection_i = 0;
		clock_i = 0;
		
		#1//continue fetching
		clock_i = 1;
		#1;
		clock_i = 0;
		
		//branch backwards
      shouldBranch_i = 1;
		branchOffset_i = 20;//20 places
		branchDirection_i = 0;//backwards
		#1
		clock_i = 1;
		#1;//halt branch
		shouldBranch_i = 0;
		branchOffset_i = 0;
		branchDirection_i = 0;
		clock_i = 0;
		
		#1//continue fetching
		clock_i = 1;
		#1;
		clock_i = 0;

	end
      
endmodule

