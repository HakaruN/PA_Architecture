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
		
	//icache programing
	reg shiftClk;//comes from the writing device
	reg shiftEn;
	reg [7:0] shiftData;
	reg isAddress;
	reg shiftOutEn;

	// Outputs
	wire [15:0] PC_o;
	wire wbAFinal_o;
	wire [4:0] wbAddrAFinal_o;
	wire [15:0] wbValAFinal_o;
	
	reg [255:0] instruction;//hard coded instrution for the test

	// Instantiate the Unit Under Test (UUT)
	PA_Core uut (
		//state
		.clock_i(clock_i), 
		.reset_i(reset_i), 
		
		//icache programing		
		.shiftClk_i(shiftClk),
		.shiftEn_i(shiftEn),
		.shiftData_i(shiftData),
		.isAddress_i(isAddress),
		.shiftOutEn_i(shiftOutEn),
		
		//output
		.PC_o(PC_o),
		.wbAArith_o(wbAFinal_o), 
		.wbAddrAFinal_o(wbAddrAFinal_o), 
		.wbValAFinal_o(wbValAFinal_o)
	);
	
integer i;
parameter NUM_CLOCK_CYCLES = 3;
	initial begin
		//Initialize Inputs
		clock_i = 0;
		reset_i = 0;		
		
		//set the shift reg state
		shiftClk = 0;
		shiftEn = 0;		
		shiftData = 0;
		isAddress = 0;
		shiftOutEn = 0;
		
		//declare the instruction to go into the reg
		instruction = 256'b1_0_0001010_00001_0000000000000101__1_0_0001010_00010_0000000000001010___0000___1_0_0001010_00011_0000000000001111__1_0_0000000_00000_0000000000000000___0000___0_0_0000010_00001_00010__1_0_0000000_00000_0000000000000000___0000000___0_1_0000110_00011_00010__1_0_0000000_00000_0000000000000000___0000000___0000000000000000;
		
		//reset the core
		reset_i = 1;
		clock_i = 1;
		#1;
		reset_i = 0;
		clock_i = 0;
		#1;
		
		///write the cacheline-write address to the shift reg
		//set the state of the shift reg
		shiftEn = 1;//enable the reg
		shiftOutEn = 0;//disable the output of the reg
		isAddress = 1;//tell the reg, the data is the desination address
		shiftData = 0;//write teh data to cacheline 0
		
		//cycle clock to save the state above
		shiftClk = 1;
		#1;
		shiftClk = 0;
		#1;
		
		isAddress = 0;//now the address has been commited, set the isAddress to 0 so the data will go in the reg
		
		//put the data into the reg
		for( i = 0; i < 32; i = i + 1)
		begin
			shiftData = instruction[(i * 8)+: 8];
			shiftClk = 1;
			#1;
			shiftClk = 0;
			#1;
		end
		
		//enable the output of the shift reg
		shiftOutEn = 1;
		shiftClk = 1;
		#1;
		shiftClk = 0;
		#1;
		
		//Clock the data from the shift reg into the core (at the input side of the i-cache)
		clock_i = 1;
		#1;
		clock_i = 0;
		#1;
		
		//zero out the shift reg state as the core now has the data clocked into it
		shiftEn = 0;
		shiftClk = 0;
		shiftData = 0;
		isAddress = 0;
		shiftOutEn = 0;		
		shiftClk = 1;
		#1;
		shiftClk = 0;
		#1;	

			
		clock_i = 1;
		#1;//cacheline has been written into the i-cache
		clock_i = 0;
		#1;
	
		clock_i = 1;
		#1;//the cacheline has been writen to the output buffer of the cache (not output lines)
		clock_i = 0;
		#1;
		
		clock_i = 1;
		#1;//data is on the output lines of the i-cache/is on the input lines for the next stage
		clock_i = 0;
		#1;
		
		clock_i = 1;
		#1;//fetch 2 cracked the instructions, however they are not yet at the output of the stage
		clock_i = 0;
		#1;
	
		clock_i = 1;
		#1;//Fetch 2 output has the instructions, the parsers have the instructions on their inputs
		clock_i = 0;
		#1;

		clock_i = 1;
		#1;//Parsers outputs have the instructions, the data is at decode
		clock_i = 0;
		#1;
		
		clock_i = 1;
		#1;//decode complete, data at reg controller input
		clock_i = 0;
		#1;
		
		clock_i = 1;
		#1;//data buffered into register controller
		clock_i = 0;
		#1;
		
		clock_i = 1;
		#1;//data buffered into register
		clock_i = 0;
		#1;


		clock_i = 1;
		#1;//data buffered into register
		clock_i = 0;
		#1;
		
		for(i = 0; i < NUM_CLOCK_CYCLES; i = i + 1)//run some clock cycles
		begin
			clock_i = 1;
			#1;
			clock_i = 0;
			#1;
		end
		
		
	end
      
endmodule

