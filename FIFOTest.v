`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:04:47 09/12/2020
// Design Name:   WritebackFIFO
// Module Name:   /home/hakaru/Projects/Verilog/PA_Architecture/PA_Architecture/FIFOTest.v
// Project Name:  PA_Architecture
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: WritebackFIFO
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FIFOTest;

	// Inputs
	reg clock_i;
	reg reset_i;
	reg ArithAEnable_i;
	reg ArithBEnable_i;
	reg [4:0] ArithWriteAddressA_i;
	reg [4:0] ArithWriteAddressB_i;
	reg [15:0] ArithWriteDataA_i;
	reg [15:0] ArithWriteDataB_i;
	reg [1:0] ArithWriteStatusA_i;
	reg [1:0] ArithWriteStatusB_i;
	reg StoreAEnable_i;
	reg StoreBEnable_i;
	reg [4:0] StoreAWriteAddress_i;
	reg [4:0] StoreBWriteAddress_i;
	reg [15:0] StoreAWriteData_i;
	reg [15:0] StoreBWriteData_i;

	// Outputs
	wire enableA_o;
	wire enableB_o;
	wire [4:0] AddressA_o;
	wire [4:0] AddressB_o;
	wire [15:0] DataA_o;
	wire [15:0] DataB_o;
	wire [1:0] statusA_o;
	wire [1:0] statusB_o;

	// Instantiate the Unit Under Test (UUT)
	WritebackFIFO uut (
		.clock_i(clock_i), 
		.reset_i(reset_i), 
		.ArithAEnable_i(ArithAEnable_i), 
		.ArithBEnable_i(ArithBEnable_i), 
		.ArithWriteAddressA_i(ArithWriteAddressA_i), 
		.ArithWriteAddressB_i(ArithWriteAddressB_i), 
		.ArithWriteDataA_i(ArithWriteDataA_i), 
		.ArithWriteDataB_i(ArithWriteDataB_i), 
		.ArithWriteStatusA_i(ArithWriteStatusA_i), 
		.ArithWriteStatusB_i(ArithWriteStatusB_i), 
		.StoreAEnable_i(StoreAEnable_i), 
		.StoreBEnable_i(StoreBEnable_i), 
		.StoreAWriteAddress_i(StoreAWriteAddress_i), 
		.StoreBWriteAddress_i(StoreBWriteAddress_i), 
		.StoreAWriteData_i(StoreAWriteData_i), 
		.StoreBWriteData_i(StoreBWriteData_i), 
		.enableA_o(enableA_o), 
		.enableB_o(enableB_o), 
		.AddressA_o(AddressA_o), 
		.AddressB_o(AddressB_o), 
		.DataA_o(DataA_o), 
		.DataB_o(DataB_o), 
		.statusA_o(statusA_o), 
		.statusB_o(statusB_o)
	);

	initial begin
		// Initialize Inputs
		clock_i = 0;
		reset_i = 0;
		ArithAEnable_i = 0;
		ArithBEnable_i = 0;
		ArithWriteAddressA_i = 0;
		ArithWriteAddressB_i = 0;
		ArithWriteDataA_i = 0;
		ArithWriteDataB_i = 0;
		ArithWriteStatusA_i = 0;
		ArithWriteStatusB_i = 0;
		StoreAEnable_i = 0;
		StoreBEnable_i = 0;
		StoreAWriteAddress_i = 0;
		StoreBWriteAddress_i = 0;
		StoreAWriteData_i = 0;
		StoreBWriteData_i = 0;

		// Wait 100 ns for global reset to finish
		#10;
		//rest
		clock_i = 1;
		reset_i = 1;
		#1;
		clock_i = 0;
		reset_i = 0;
		#1;
		
		clock_i = 1;
		#1;
		clock_i = 0;
		#1;
		
		ArithAEnable_i = 1;
		ArithBEnable_i = 1;
		ArithWriteAddressA_i = 1;
		ArithWriteAddressB_i = 2;
		ArithWriteDataA_i = 1;
		ArithWriteDataB_i = 2;
		ArithWriteStatusA_i = 1;
		ArithWriteStatusB_i = 1;
		StoreAEnable_i = 1;
		StoreBEnable_i = 1;
		StoreAWriteAddress_i = 3;
		StoreBWriteAddress_i = 4;
		StoreAWriteData_i = 3;
		StoreBWriteData_i = 4;
		
		clock_i = 1;
		#1;
		clock_i = 0;
		#1;
		
		ArithAEnable_i = 0;
		ArithBEnable_i = 0;
		StoreAEnable_i = 0;
		StoreBEnable_i = 0;
		
		ArithWriteAddressA_i = 0;
		ArithWriteAddressB_i = 0;
		ArithWriteDataA_i = 0;
		ArithWriteDataB_i = 0;
		ArithWriteStatusA_i = 0;
		ArithWriteStatusB_i = 0;
		StoreAWriteAddress_i = 3;
		StoreBWriteAddress_i = 4;
		StoreAWriteData_i = 3;
		StoreBWriteData_i = 4;
		
		clock_i = 1;
		#1;
		clock_i = 0;
		#1;
		$display("FIFO output: Address: %d, %d, data: %d, %d, enable: %d, %d", AddressA_o, AddressB_o, DataA_o, DataB_o, enableA_o, enableB_o);
		
		clock_i = 1;
		#1;
		clock_i = 0;
		#1;
		$display("FIFO output: Address: %d, %d, data: %d, %d, enable: %d, %d", AddressA_o, AddressB_o, DataA_o, DataB_o, enableA_o, enableB_o);
		clock_i = 1;
		#1;
		clock_i = 0;
		#1;
		$display("FIFO output: Address: %d, %d, data: %d, %d, enable: %d, %d", AddressA_o, AddressB_o, DataA_o, DataB_o, enableA_o, enableB_o);
		clock_i = 1;
		#1;
		clock_i = 0;
		#1;
        $display("FIFO output: Address: %d, %d, data: %d, %d, enable: %d, %d", AddressA_o, AddressB_o, DataA_o, DataB_o, enableA_o, enableB_o);
		// Add stimulus here

	end
      
endmodule

