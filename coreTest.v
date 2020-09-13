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
	reg icacheWriteEnable_i;
	reg [15:0] writeAddress_i;
	reg[256:0] instruction_i;

	// Outputs
	wire [15:0] PC_o;
	wire wbAFinal_o;
	wire [4:0] wbAddrAFinal_o;
	wire [15:0] wbValAFinal_o;

	// Instantiate the Unit Under Test (UUT)
	PA_Core uut (
		//state
		.clock_i(clock_i), 
		.reset_i(reset_i), 
		
		//icache programing
		.icacheWriteEnable_i(icacheWriteEnable_i),
		.writeAddress_i(writeAddress_i),
		.instruction_i(instruction_i),
		
		//output
		.PC_o(PC_o),
		.wbAArith_o(wbAFinal_o), 
		.wbAddrAFinal_o(wbAddrAFinal_o), 
		.wbValAFinal_o(wbValAFinal_o)
	);
integer i;
parameter NUM_CLOCK_CYCLES = 20;
	initial begin
		//Initialize Inputs
		//initialise i-cache
		#10;
		icacheWriteEnable_i = 0;
		/*
		//set write enable to load instructions to the cache
		icacheWriteEnable_i = 1;
		
		//set the cache address to write to
		writeAddress_i = 5;
		instruction_i = 60'b1_0_0001010_00001_0000000000000101__1_0_0001010_00010_0000000000001010;//load val 10 to reg 1 and load val 5 to reg 2	
		clock_i = 1;//clock the instruction in
		#1;
		clock_i = 0;
		#1;
		
		//next instruction
		writeAddress_i = 6;
		instruction_i = 60'b1_0_0001010_00011_0000000000001111__0_0_0000000_00000_0000000000000000;//load the jump offsets to reg 3 (reg 3 has a 15 jump offset) and a nop
		clock_i = 1;//clock the instruction in
		#1;
		clock_i = 0;
		#1;
		
		//next instruction
		writeAddress_i = 7;
		instruction_i = 60'b0_0_0000010_00001_00010_00000000000__000000000000000000000000000000;//A = A - B, nop
		clock_i = 1;//clock the instruction in
		#1;
		clock_i = 0;
		#1;
		
		//next instruction
		writeAddress_i = 13;
		instruction_i = 60'b0_1_0000110_00011_00010_00000000000__000000000000000000000000000000;//branch up ahead if underflow using offset in reg 3
		clock_i = 1;//clock the instruction in
		#1;
		clock_i = 0;
		#1;
		
		//next instruction
		writeAddress_i = 17;
		instruction_i = 60'b1_0_0001010_00011_0000000000000011__1_0_0001010_00010_0000000000001010;//if the branch was not taken, put 3 in reg 3
		clock_i = 1;//clock the instruction in
		#1;
		clock_i = 0;
		#1;
		
		//next instruction
		writeAddress_i = 21;
		instruction_i = 60'b1_0_0001010_00011_0000000000000001__1_0_0001010_00010_0000000000001010;//put 1 in reg 3		
		clock_i = 1;//clock the instruction in
		#1;
		clock_i = 0;
		icacheWriteEnable_i = 0;//disable the instruction cache write
		#1;
	
		*/
		//reset
		reset_i = 1;
		clock_i = 1;
		// Wait 100 ns for global reset to finish
		#1;
		reset_i = 0;
		clock_i = 0;
		
		for(i = 0; i < NUM_CLOCK_CYCLES; i = i + 1)
		begin
			#1;
			clock_i = 1;
			#1;
			clock_i = 0;
		end
	end
      
endmodule

