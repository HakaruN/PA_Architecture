`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//Stage 2 takes in a cacheline and pulls out a quad word (64 bits) from the cacheline (block) and returns that.
//The quad word is there beacuse the largest VLIW instruction will be 60 bits (round to upper byte) is 64 bits
//therefore the bandwidth has the capacity to handle the largest VLIW instructions
//////////////////////////////////////////////////////////////////////////////////

module FetchStage2(
	//control
	input wire clock_i,
	input wire reset_i,
	input wire enable_i,
	input wire [4:0] byteAddr_i,//address of the byte in the block (given by PC[4:0])
	input wire [0:255] block_i,
	
	//fetch out
	output reg backDisable_o,
	output reg [3:0] nextByteOffset_o,//number of bytes to increment the pc by to get to the next vliw bundle
	output reg [31:0] InstructionA_o, InstructionB_o,
	output reg InstructionAFormat_o, InstructionBFormat_o,
	output reg enableA_o, enableB_o
    );
		
	//instruction buffers
	reg [31:0] InstructionA, InstructionB;
	reg InstructionAFormat, InstructionBFormat;//1 = 30bit, 0 = 19bit
	
	always @(posedge clock_i)
	begin
		if(enable_i == 1)
		begin
			//$display("\nFetching at byte: %d", byteAddr_i);	
			//$display("Working on word: %b", block_i);
				enableA_o <= 1;
				enableB_o <= 1;
			if(reset_i == 1)
			begin
				//$display("Stalling");
				enableA_o <= 0;
				enableB_o <= 0;
				nextByteOffset_o <= 0;
			end
			else if(block_i[byteAddr_i * 8] == 1)//if instruction A in the VLIW bundle is a 30b instruction
			begin
				//$display("A is 30 bits");
				//$display("InstructionA: %b", block_i[(byteAddr_i * 8) +: 30]);
				InstructionA <= block_i[(byteAddr_i * 8) +: 30];
				InstructionAFormat <= 1;
				if(block_i[(byteAddr_i * 8) + (30)] == 1)//check second instructions size, if its 30b
				begin
					//$display("B is 30 bits");
					//$display("InstructionB: %b", block_i[((byteAddr_i * 8) + 30) +: 30]);
					InstructionB <= block_i[((byteAddr_i * 8) + 30) +: 30];
					InstructionBFormat <= 1;
					nextByteOffset_o <= 8;
				end
				else if(block_i[(byteAddr_i * 8) + (30)] == 0)//else its 19 bit
				begin
					//$display("B is 19 bits");
					//$display("InstructionB: %b", block_i[((byteAddr_i * 8) + 30) +: 19]);					
					InstructionB <= block_i[((byteAddr_i * 8) + 30) +: 19];
					InstructionBFormat <= 0;
					nextByteOffset_o <= 7;
				end
			end
			else if(block_i[byteAddr_i * 8] == 0)//else its a 19b instruction
			begin
				//$display("A is 19 bits");
				//$display("InstructionA: %b", block_i[(byteAddr_i * 8) +: 19]);
				InstructionAFormat <= 0;
				InstructionA <= block_i[(byteAddr_i * 8) +: 19];//parse instruction A
				
				if(block_i[(byteAddr_i * 8) + 19] == 1)//check second instructions size, if its 30b
				begin
					//$display("B is 30 bits");
					//$display("InstructionB: %b", block_i[((byteAddr_i * 8) + 19) +: 30]);
					InstructionB <= block_i[((byteAddr_i * 8) + 19) +: 30];
					InstructionBFormat <= 1;
					nextByteOffset_o <= 7;
				end
				else if(block_i[(byteAddr_i * 8) + 19] == 0)//else its 19 bit
				begin
					//$display("B is 19 bits");
					//$display("InstructionB: %b", block_i[((byteAddr_i * 8) + 19) +: 19]);
					InstructionB <= block_i[((byteAddr_i * 8) + 19) +: 19];//parse instruction B
					InstructionBFormat <= 0;
					nextByteOffset_o <= 5;
				end			
			end
			else//if its not 1 or 0, its undefined so dont increment PC
				nextByteOffset_o <= 0;
				
			InstructionA_o <= InstructionA; InstructionB_o <= InstructionB;
			InstructionAFormat_o <= InstructionAFormat; InstructionBFormat_o <= InstructionBFormat;
		end
	end
endmodule
