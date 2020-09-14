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

module FetchStage1(
	//control
	input wire clock_i,
	input wire reset_i,
	input wire [10:0] blockAddr_i,
	
	//instruction write
	input wire writeEnable_i,
	input wire [15:0] writeAddress_i,
	input wire [255:0] writeBlock_i,	
	
	//fetch out
	output reg [255:0] block_o,
	output reg enable_o
    );
 
	parameter BLOCK_SIZE = 32;
	parameter BITS_PER_BYTE = 8;
	parameter CACHE_LINES = 256;

	reg [BLOCK_SIZE * BITS_PER_BYTE - 1:0] iCache [CACHE_LINES -1 :0];//128 entry i-cache where each cacheline is 50 bits wide (1 instruction)
	
	//instruction write
	reg writeEnable;
	reg [15:0] writeAddress;
	reg [10:0] blockAddress;
	reg [BLOCK_SIZE * BITS_PER_BYTE - 1:0] writeBlock;		
	reg [BLOCK_SIZE * BITS_PER_BYTE - 1:0] block;//32 byte wide block of cach
	reg enable;
	integer i;
	
	//fetch	
	//Reset for simulation only
	always @(posedge clock_i)
	begin
		if((reset_i == 0) && (writeEnable == 0))
		begin
			block <= iCache[blockAddress];
			enable <= 1;
		end		
		else if(reset_i == 1)
		begin
			enable <= 0;//if reset, enable = 0
			for(i = 0; i < CACHE_LINES; i = i + 1)
			begin
				iCache[i] <= 256'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
				//block <= 256'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
				//i;//60'b1_0_0000000_00000_0000000000000000__1_0_0000000_00000_0000000000000000;
			end
			//IF FORMAT = 1, REG-IMM. FORMAT = 0 REG-REG
			//First bit: Format - Second bit: branch - Next 7 bits: opcode - Next 5 bits: Primary operand - Last 5/16 bits: Secondary operand
			iCache[0] <= 256'b1_0_0001010_00001_0000000000000101__1_0_0001010_00010_0000000000001010___0000___1_0_0001010_00011_0000000000001111__1_0_0000000_00000_0000000000000000___0000___0_0_0000010_00001_00010__1_0_0000000_00000_0000000000000000___0000000___0_1_0000110_00011_00010__1_0_0000000_00000_0000000000000000___0000000___0000000000000000;
			//iCache[2] <= 60'b1_0_0001010_00011_0000000000001111__0_0_0000000_00000_0000000000000000;//load the jump offsets to reg 3 (reg 3 has a 15 jump offset) and a nop
			//iCache[3] <= 60'b0_0_0000010_00001_00010__0_0_0000000_00000_0000000000000000;//A = A - B, nop
			//iCache[9] <= 60'b0_1_0000110_00011_00010__0_0_0000000_00000_0000000000000000;//branch up ahead if underflow using offset in reg 3
			//iCache[12] <= 60'b1_0_0001010_00011_0000000000000011__1_0_0001010_00010_0000000000001010;//if the branch was not taken, put 3 in reg 3
			//iCache[15] <= 60'b0_1_0000010_00100_00000_00000000000__000000000000000000000000000000;//branch up ahead			
			/*
			iCache[0] <= 256'b1_0_0001010_00001_0000000000000101__1_0_0001010_00010_000000000000101000001_0_0001010_00011_0000000000001111__0_0_0000000_00000_000000000000000000000_0_0000010_00001_00010_00000000000__00000000000000000000000000000000000_1_0000110_00011_00010_00000000000__0000000000000000000000000000000001;//load val 10 to reg 1 and load val 5 to reg 2, then load the jump offsets to reg 3 (reg 3 has a 15 jump offset) and a nop, then A = A - B & nop, thenbranch up ahead if underflow using offset in reg 3				
			iCache[12] <= 60'b1_0_0001010_00011_0000000000000011__1_0_0001010_00010_0000000000001010;//if the branch was not taken, put 3 in reg 3
			iCache[15] <= 60'b0_1_0000010_00100_00000_00000000000__000000000000000000000000000000;//branch up ahead			
			iCache[19] <= 60'b1_0_0001010_00011_0000000000000001__1_0_0001010_00010_0000000000001010;//put 1 in reg 3		
			//iCache[0] <= 60'b1_0_0001011_00000_0000000000000000__1_0_0000000_00000_0000000000000000;//increment bank select (select bank 1)		
			*/
		end	
		else if(writeEnable == 1)
		begin
			iCache[writeAddress] <= writeBlock;
			enable <= 0;
		end			
		
	end
	

	
	//update fetch state
	always @(posedge clock_i)
	begin	
		if((reset_i == 0) && (writeEnable_i == 0))
		begin		
			//read/write to/from buffers 
			blockAddress <= blockAddr_i;
			block_o <= block;
			enable_o <= enable;
			writeEnable <= writeEnable_i;
			writeAddress <= writeAddress_i;
			writeBlock <= writeBlock_i;	
		end		
	end

endmodule
