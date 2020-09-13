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
	input wire [BLOCK_SIZE * BITS_PER_BYTE - 1:0]block_i,
	
	//operation control
	//input wire [3:0] fetchedBundleSize_i,

	//branch control
	input wire shouldBranch_i,
	input wire [15:0] branchOffset_i,
	input wire branchDirection_i,	 

	//output to parse unit (stage 1)
	output reg [15:0] PC_o,
	
	//output reg [BLOCK_SIZE * BITS_PER_BYTE - 1:0] data_o,
	output reg [BITS_PER_BYTE - 1:0] data_o,
	output reg enable_o
    );
	 
	//cache specs
	parameter BLOCK_SIZE = 32;//32 bytes per block
	parameter BITS_PER_BYTE = 8;
	parameter CACHE_LINES = 256;

	reg [BLOCK_SIZE * BITS_PER_BYTE - 1:0] iCache [CACHE_LINES -1 :0];//128 entry i-cache where each cacheline is 50 bits wide (1 instruction)
	
	//control
	//reg flushBack;
	
	//branch control
	reg shouldBranch;
	reg [15:0] branchOffset;
	reg branchDirection;
	
	//instruction write
	reg writeEnable;
	reg [15:0] writeAddress;
	reg [BLOCK_SIZE * BITS_PER_BYTE - 1:0] block;	
	
	reg [15:0] PC;
	reg [4:0] PC_LOW;
	reg [BLOCK_SIZE * BITS_PER_BYTE - 1:0] data;//32 byte wide block of cache
	integer i;
	//fetch
	
	//Reset for simulation only
	always @(posedge clock_i)
	begin
		if((reset_i == 0) && (writeEnable == 0))
		begin
			//$display("Fetching %b at :%d", iCache[PC], PC);
			//data <= iCache[PC];
			data <= iCache[PC[15:6]];
			$display("Fetching: %d", iCache[PC[15:6]]);
		end
		else if(reset_i)
		begin
			//data <= 60'b000000000000000000000000000000000000000000000000000000000000;	
			//PC <= 0;//reset the pc to 0
			//data_o <= 60'b000000000000000000000000000000000000000000000000000000000000;
			for(i = 0; i < CACHE_LINES; i = i + 1)
			begin
				iCache[i] <= i;//60'b1_0_0000000_00000_0000000000000000__1_0_0000000_00000_0000000000000000;
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
		else
			data <= 0;
			
	end
	

	
	//update fetch state
	always @(posedge clock_i)
	begin
		if(writeEnable)
		begin
			iCache[writeAddress] <= block;
			enable_o <= 0;
		end		
		else if(reset_i)//reset
		begin
			PC <= 0;
			PC_LOW <= 0;
			enable_o <= 0;
		end
		else
		begin			
			//update the state
			PC <= PC + 1;
			$display("incrementing PC: %d", PC + 1);
			//set the reads
			PC_LOW <= PC[4:0];
			data_o <= data[PC_LOW];
			enable_o <= 1;
			PC_o <= PC;
			
			//set the writes
			writeEnable <= writeEnable_i;
			writeAddress <= writeAddress_i;
			block <= block_i;
			
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
