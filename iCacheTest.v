`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:35:22 09/13/2020
// Design Name:   iCache
// Module Name:   /home/hakaru/Projects/Verilog/PA_Architecture/PA_Architecture/iCacheTest.v
// Project Name:  PA_Architecture
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: iCache
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module iCacheTest;

	// Inputs
	reg clock_i;
	reg reset_i;
	//reg [10:0] blockAddr_i;
	reg writeEnable_i;
	reg [15:0] writeAddress_i;
	reg [BLOCK_SIZE * BITS_PER_BYTE - 1:0] writeBlock_i;
	
	reg [15:0] PC;
	
	// Outputs
	wire [BLOCK_SIZE * BITS_PER_BYTE - 1:0] block_o;
	wire enable_o;
	

	// Instantiate the Unit Under Test (UUT)
	FetchStage1 uut (
		.clock_i(clock_i), 
		.reset_i(reset_i), 
		.blockAddr_i(PC[15:5]), 
		.writeEnable_i(writeEnable_i), 
		.writeAddress_i(writeAddress_i), 
		.writeBlock_i(writeBlock_i), 
		.block_o(block_o), 
		.enable_o(enable_o)
	);
	
	wire backDisable;
	wire [3:0] nextByteOffset;
	wire [63:0] InstructionA, InstructionB;
	wire InstructionAFormat, InstructionBFormat;
	wire stage2enable, stage2enable;
	
	FetchStage2 stage2(
		//inputs
		.clock_i(clock_i), 
		.reset_i(reset_i),
		.enable_i(enable_o),
		.byteAddr_i(PC[4:0]),
		//outputs
		.block_i(block_o),
		.backDisable_o(backDisable),
		.nextByteOffset_o(nextByteOffset),
		.InstructionA_o(InstructionA), .InstructionB_o(InstructionB),
		.InstructionAFormat_o(InstructionAFormat), .InstructionBFormat_o(InstructionBFormat),
		.enableA_o(stage2enable), enableB_o(stage2enable)
	);
	
parameter BLOCK_SIZE = 32;//32 bytes per block
parameter BITS_PER_BYTE = 8;
parameter CACHE_LINES = 256;
integer i;
parameter NUM_CLOCKS = 10;

	initial begin
		// Initialize Inputs
		PC = 0;
		clock_i = 0;
		reset_i = 0;
		//blockAddr_i = 0;
		writeEnable_i = 15'h0;
		writeAddress_i = 0;
		writeBlock_i = 0;

		// Wait 100 ns for global reset to finish
		#10;
		
		//reset
		reset_i = 1;
		clock_i = 1;
		#1;
		reset_i = 0;
		clock_i = 0;
		#1; 
		PC  = 0;
		
		//clocks
		for(i = 0; i < NUM_CLOCKS; i = i + 1)
		begin
			clock_i = 1;
			#1;
			PC = PC + nextByteOffset;
			clock_i = 0;
			#1;
			//$display("PC: %d, Incrementing PC by: %d", PC, nextByteOffset);
			//$display("Fetched instructionA: %b, format: %b", InstructionA, InstructionAFormat);	
			//$display("Fetched instructionB: %b, format: %b", InstructionB, InstructionBFormat);	
		end


	end
      
endmodule

