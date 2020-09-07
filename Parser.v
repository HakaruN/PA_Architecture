`timescale 1ns / 1ps
`default_nettype none
module Parser(
	 input wire clock_i,
	 input wire enable_i,
    input wire [59:0] instruction_i,	 
	 //2 sets of outputs, one for eac instruction as this is a dual issue machine
	 output reg isBranch_o1,  				output reg isBranch_o2,
	 output reg instructionFormat_o1, 	output reg instructionFormat_o2,
	 output reg [6:0] opcode_o1, 			output reg [6:0] opcode_o2,
	 output reg [4:0] reg_o1,  			output reg [4:0] reg_o2,
	 output reg [15:0] operand_o1, 		output reg [15:0] operand_o2,
	 output reg enable_o1, 					output reg enable_o2	 	 
    );
	 
	 reg instruction1Format;// format = 0 - 19b, format = 1 - 30b	 
	 reg wasEnabled;//this buffers the enable signal that came in with the instruction therefore even if the enable isn't high now, the parser will still parse the instruction that came in
	 reg [58:0] instruction;//used for the second part
	 
	always @(posedge clock_i)//first stage
	begin
		wasEnabled <= enable_i;//buffer the current enable to wasEnabled
		if(enable_i)//if we're enabled then set the instruction buffer and do a partial parse (parse stage 1)
		begin//[include desired bit: 1 past the end]
			instruction <= instruction_i[58:0];//Set the instruction buffer to the instruction taken in
			instruction1Format <= instruction_i[59];//set the buffer for the first instruction so the second stage knows how to divide the buffer		
		end	
	end
	
	always @(posedge clock_i)//second stage
	begin
		enable_o1 <= wasEnabled;
		enable_o2 <= wasEnabled;
		if(wasEnabled)
		begin				
			//parse instruction 1 (this bit can be done independant of the format)
			instructionFormat_o1 <= instruction1Format;//output format for instruction1
			isBranch_o1 <= instruction[58];//set the branch bit
			opcode_o1 <= instruction[57:51];//set the opcode
			reg_o1 <= instruction[50:46];//set the first register operand			
			if(instruction1Format)
			begin
				//parse operand 1 according to instruction 1 being 30b	
				operand_o1 <= instruction[45:30];//take the bottom 16 bits from instruction 1, as its an immediate val	
				//parse instruction 2 according to instruction 1 being 30b
				instructionFormat_o2 <= instruction[29];//set the format
				isBranch_o2 <= instruction[28];//set the branchyness
				opcode_o2 <= instruction[27:21];//set the opcode
				reg_o2 <= instruction[20:16];
				operand_o2 <= instruction[15: 0];					
			end
			else
			begin
				//parse instructions according to instruction 1 being 19b
				operand_o1 <= instruction[45:41];//take the bottom 5 bits from instruction 1, as its an register				
				instructionFormat_o2 <= instruction[40];//set the format
				isBranch_o2 <= instruction[39];//set the branchyness
				opcode_o2 <= instruction[38:32];//set the opcode
				reg_o2 <= instruction[31:27];
				operand_o2 <= instruction[26: 11];
			end		
		end
	end


endmodule
