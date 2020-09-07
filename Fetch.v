`timescale 1ns / 1ps
`default_nettype none
module Fetch(
    input wire clock_i,
	 input wire reset_i,
    input wire [15:0] PC,
    output reg [59:0] data_o,
    output reg enable_o
    );
	parameter numCacheEntries = 100;
	reg [59:0] iCache [numCacheEntries -1 :0];//128 entry i-cache where each cacheline is 50 bits wide (1 instruction)
	integer i;
	
	reg [15:0] oldPC;
	
	always @ (posedge clock_i)
	begin	
		if(reset_i)//if not reset
		begin
			oldPC <= 'hFFFF;//old pc is set to 0xFFFF
			//$display("resetting i cache");
			for(i = 0; i < numCacheEntries; i = i + 1)
			begin
				iCache[i] <= 60'b1_0_0000000_00000_0000000000000000__1_0_0000000_00000_0000000000000000;
			end
			//IF FORMAT = 1, REG-IMM. FORMAT = 0 REG-REG
			//reg-reg not branch opcode: 1111111, prim-reg: 11111, second reg 11110
			//First bit: Format - Second bit: branch - Next 7 bits: opcode - Next 5 bits: Primary operand - Last 5/16 bits: Secondary operand
										//first instruction					//second instruction
			//iCache[0] <= 60'b1_0_0000100_00001_0000000000001010__1_0_0000100_00010_0000000000000101;//load val 10 to reg 1 and load val 5 to reg 2										
			//iCache[5] <= 60'b0_0_0000001_00001_00010_00000000000__000000000000000000000000000000;//A = A + B
			//iCache[0] <= 60'b1_0_0001011_00000_0000000000000000__1_0_0000000_00000_0000000000000000;//increment bank select (select bank 1)
			iCache[0] <= 60'b1_0_0000100_00001_0000000000001010__1_0_0000100_00010_0000000000000101;//load val 10 to reg 1 and load val 5 to reg 2			
			//iCache[1] <= 60'b0_1_0001000_00001_00010_00000000000__000000000000000000000000000000;//branch up ahead
			iCache[6] <= 60'b0_0_0000001_00001_00010_00000000000__000000000000000000000000000000;//A = A + B
			
						
		end
		else 
		if(oldPC != PC)//if the pc hasn't been updates since last cycle, the i cache detected a stall and halts
		begin	
			oldPC <= PC;
			data_o <= iCache[PC];//fetch the address of the pc into data_o
			enable_o <= 1;//set enable_o to 1
		end
		else//otherwise do nothing and set enable_o to 0
			enable_o <= 0;
		
	end
endmodule
