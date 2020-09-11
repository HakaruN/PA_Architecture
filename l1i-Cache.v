`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:46:49 09/11/2020 
// Design Name: 
// Module Name:    l1i-Cache 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module l1i_Cache(
//control
	input wire clock_i,
	input wire reset_i,
	//input wire flushBack_i,
	//input wire halt_i,
	
	//instruction write
	input wire writeEnable_i,
	input wire [15:0] writeAddress_i,
	input wire [59:0] instruction_i,
	
	//operation control
	//input wire [3:0] fetchedBundleSize_i,

	//branch control
	input wire shouldBranch_i,
	input wire [15:0] branchOffset_i,
	input wire branchDirection_i,	 

	//output to parse unit (stage 1)
	output reg [15:0] PC_o,
	output reg [59:0] data_o,
	output reg enable_o
    );

	parameter numCacheEntries = 257;
	reg [59:0] iCache [numCacheEntries -1 :0];//128 entry i-cache where each cacheline is 50 bits wide (1 instruction)
	
	//control
	reg reset;
	//reg flushBack;
	//reg halt;
	
	//branch control
	reg shouldBranch;
	reg [15:0] branchOffset;
	reg branchDirection;
	
	//instruction write
	reg writeEnable;
	reg [15:0] writeAddress;
	reg [59:0] instruction;
	
	
	reg [15:0] PC;
	reg [59:0] data;
	
	always @(posedge clock_i)
	begin
		if(!reset)
		begin
			data <= iCache[PC];
		end		
	end
	
	always @(posedge clock_i)
	begin
		if(writeEnable)
			iCache[writeAddress] <= instruction;
	end
	
	always @(posedge clock_i)
	begin
		//update the state
		PC <= PC + 1;
		reset <= reset_i;
		
		//set the reads
		data_o <= data;
		enable_o <= 1;
		
		//set the writes
		writeEnable <= writeEnable_i;
		writeAddress <= writeAddress_i;
		instruction <= instruction_i;
		
		//set the branch state
		shouldBranch <= shouldBranch_i;
		branchOffset <= branchOffset_i;
		branchDirection <= branchDirection_i;
			
		if(shouldBranch)
		begin
			case(branchDirection_i)
				0: begin PC <= PC - (branchOffset_i); end//has an aditional offset of 7 as this takes into acount the latency
				1: begin PC <= PC + (branchOffset_i); end
			endcase
		end


		
	end

endmodule
