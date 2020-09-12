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

	parameter numCacheEntries = 1000;//
	reg [59:0] iCache [numCacheEntries -1 :0];//128 entry i-cache where each cacheline is 50 bits wide (1 instruction)
	
	//control
	//reg flushBack;
	
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
	//integer i;
	//fetch
	
	//Reset for simulation only
	always @(posedge clock_i)
	begin
		if(!reset_i && (!writeEnable))
		begin
			//$display("Fetching %b at :%d", iCache[PC], PC);
			data <= iCache[PC];
		end
		/*
		else if(reset_i)
			begin
				//PC <= 0;//reset the pc to 0
				data_o <= 60'b000000000000000000000000000000000000000000000000000000000000;
				for(i = 0; i < numCacheEntries; i = i + 1)
				begin
					iCache[i] <= 60'b1_0_0000000_00000_0000000000000000__1_0_0000000_00000_0000000000000000;
				end
				//IF FORMAT = 1, REG-IMM. FORMAT = 0 REG-REG
				//First bit: Format - Second bit: branch - Next 7 bits: opcode - Next 5 bits: Primary operand - Last 5/16 bits: Secondary operand
				iCache[1] <= 60'b1_0_0001010_00001_0000000000000101__1_0_0001010_00010_0000000000001010;//load val 10 to reg 1 and load val 5 to reg 2										
				iCache[2] <= 60'b1_0_0001010_00011_0000000000001111__0_0_0000000_00000_0000000000000000;//load the jump offsets to reg 3 (reg 3 has a 15 jump offset) and a nop
				iCache[3] <= 60'b0_0_0000010_00001_00010_00000000000__000000000000000000000000000000;//A = A - B, nop
				iCache[9] <= 60'b0_1_0000110_00011_00010_00000000000__000000000000000000000000000000;//branch up ahead if underflow using offset in reg 3
				iCache[12] <= 60'b1_0_0001010_00011_0000000000000011__1_0_0001010_00010_0000000000001010;//if the branch was not taken, put 3 in reg 3
				iCache[15] <= 60'b0_1_0000010_00100_00000_00000000000__000000000000000000000000000000;//branch up ahead			
				iCache[19] <= 60'b1_0_0001010_00011_0000000000000001__1_0_0001010_00010_0000000000001010;//put 1 in reg 3		
				//iCache[0] <= 60'b1_0_0001011_00000_0000000000000000__1_0_0000000_00000_0000000000000000;//increment bank select (select bank 1)		
			end
			*/
	end
	

	
	//update fetch state
	always @(posedge clock_i)
	begin
		if(writeEnable)
		begin
			iCache[writeAddress] <= instruction;
			enable_o <= 0;
		end		
		else if(reset_i)//reset
		begin
			PC <= 0;
			enable_o <= 0;
		end
		else
		begin
				
			//update the state
			PC <= PC + 1;
			
			//set the reads
			data_o <= data;
			enable_o <= 1;
			PC_o <= PC;
			
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
				case(branchDirection)
					0: begin PC <= PC - (branchOffset); end//has an aditional offset of 7 as this takes into acount the latency
					1: begin PC <= PC + (branchOffset); end
				endcase
			end
		end		
	end

endmodule
