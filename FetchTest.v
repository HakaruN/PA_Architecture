`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:40:49 09/13/2020
// Design Name:   l1i_Cache
// Module Name:   /home/hakaru/Projects/Verilog/PA_Architecture/PA_Architecture/FetchTest.v
// Project Name:  PA_Architecture
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: l1i_Cache
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
	reg writeEnable_i;
	reg [15:0] writeAddress_i;
	reg [255:0] block_i;
	reg shouldBranch_i;
	reg [15:0] branchOffset_i;
	reg branchDirection_i;

	// Outputs
	wire [15:0] PC_o;
	wire [255:0] data_o;
	wire enable_o;

	// Instantiate the Unit Under Test (UUT)
	l1i_Cache uut (
		.clock_i(clock_i),
		.reset_i(reset_i),
		.writeEnable_i(writeEnable_i),
		.writeAddress_i(writeAddress_i),
		.block_i(block_i),
		.shouldBranch_i(shouldBranch_i),
		.branchOffset_i(branchOffset_i),
		.branchDirection_i(branchDirection_i),
		.PC_o(PC_o),
		.data_o(data_o),
		.enable_o(enable_o)
	);
integer i;
parameter NUM_CLOCKS = 66;
	initial begin
		// Initialize Inputs
		clock_i = 0;
		reset_i = 0;
		writeEnable_i = 0;
		writeAddress_i = 0;
		block_i = 0;
		shouldBranch_i = 0;
		branchOffset_i = 0;
		branchDirection_i = 0;

		// Wait 100 ns for global reset to finish
		#16;
		
		//writeEnable_i = 0;
		//writeAddress_i = 10;
      //block_i = 'hFFFFFFFF;

		reset_i = 1;
		clock_i = 1;
		#1;
		reset_i = 0;
		clock_i = 0;
		#1;

		

		for(i = 0; i < NUM_CLOCKS; i = i + 1)
		begin		
			clock_i = 1;
			#1;
			clock_i = 0;
			#1;
		end
		// Add stimulus here

	end
      
endmodule

