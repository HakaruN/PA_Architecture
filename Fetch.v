`timescale 1ns / 1ps
`default_nettype none
module Fetch(
	//control
	input wire clock_i,
	input wire reset_i,
	input wire flushBack_i,
	input wire halt_i,
	
	//instruction write
	input wire writeEnable_i,
	input wire [15:0] writeAddress_i,
	input wire [59:0] instruction_i,
	
	//operation control
	input wire [3:0] fetchedBundleSize_i,

	//branch control
	input wire shouldBranch_i,
	input wire [15:0] branchOffset_i,
	input wire branchDirection_i,	 

	//output to parse unit (stage 1)
	output reg [59:0] data_o,
	output reg enable_o
   );
	parameter numCacheEntries = 256;
	reg [59:0] iCache [numCacheEntries -1 :0];//128 entry i-cache where each cacheline is 50 bits wide (1 instruction)
	integer i;	
	reg [15:0] PC;
	
	always @ (posedge clock_i)
	begin		
		if(halt_i)
		begin
			if(writeEnable_i)
			begin
				iCache[writeAddress_i] <= instruction_i;
			end
			else if(reset_i)
			begin
				$display("Resetting");
				PC <= 'h0000;//reset the pc to 0
				data_o <= 60'b000000000000000000000000000000000000000000000000000000000000;
				for(i = 0; i < numCacheEntries; i = i + 1)
				begin
					iCache[i] <= 60'b1_0_0000000_00000_0000000000000000__1_0_0000000_00000_0000000000000000;
				end
				//IF FORMAT = 1, REG-IMM. FORMAT = 0 REG-REG
				//First bit: Format - Second bit: branch - Next 7 bits: opcode - Next 5 bits: Primary operand - Last 5/16 bits: Secondary operand
				iCache[0] <= 60'b1_0_0001010_00001_0000000000000101__1_0_0001010_00010_0000000000001010;//load val 10 to reg 1 and load val 5 to reg 2										
				iCache[1] <= 60'b1_0_0001010_00011_0000000000001111__0_0_0000000_00000_0000000000000000;//load the jump offsets to reg 3 (reg 3 has a 15 jump offset) and a nop
				iCache[2] <= 60'b0_0_0000010_00001_00010_00000000000__000000000000000000000000000000;//A = A - B, nop
				iCache[8] <= 60'b0_1_0000110_00011_00010_00000000000__000000000000000000000000000000;//branch up ahead if underflow using offset in reg 3
				iCache[12] <= 60'b1_0_0001010_00011_0000000000000011__1_0_0001010_00010_0000000000001010;//if the branch was not taken, put 3 in reg 3
				iCache[14] <= 60'b0_1_0000010_00100_00000_00000000000__000000000000000000000000000000;//branch up ahead			
				iCache[18] <= 60'b1_0_0001010_00011_0000000000000001__1_0_0001010_00010_0000000000001010;//put 1 in reg 3		
				//iCache[0] <= 60'b1_0_0001011_00000_0000000000000000__1_0_0000000_00000_0000000000000000;//increment bank select (select bank 1)		
			end
		end
		else if(flushBack_i)
		begin
			$display("Flushing pipe");
			enable_o <= 0;
		end
		else if(shouldBranch_i)//if branching
		begin
			$display("branching");
			case(branchDirection_i)
				0: begin PC <= PC - (branchOffset_i); enable_o <= 1; data_o <= iCache[PC - branchOffset_i ]; end//has an aditional offset of 7 as this takes into acount the latency
				1: begin PC <= PC + (branchOffset_i); enable_o <= 1; data_o <= iCache[PC + branchOffset_i ]; end
			endcase
		end
		else//else operating normaly
		begin
			PC <= PC + 1;
			enable_o <= 1;
			data_o <= iCache[PC];
			$display("fetching: %b at: %d", iCache[PC], PC);
			//could add a stall notice, if there is a stall, halt fetching
		end
	end
endmodule
