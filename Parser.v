`timescale 1ns / 1ps
`default_nettype none
module Parser(
	input wire clock_i,
	input wire enable_i,
	input wire [31:0] Instruction_i,
	input wire InstructionFormat_i,
	
	output reg instructionFormat_o,
	output reg isBranch_o,	
	output reg [6:0] opcode_o,
	output reg [4:0] primOperand_o,
	output reg [15:0] secOperand_o,
	output reg enable_o
	);
	
	always @(posedge clock_i)
	begin
		if(enable_i == 1)
		begin
			if(Instruction_i[27:21] != 0)//if not a nop
			begin
				//set the format, branch, opcode and prim operand
				instructionFormat_o <= InstructionFormat_i;
				isBranch_o <= Instruction_i[28];//set the is branch flag based on the branch bit
				opcode_o <= Instruction_i[27:21];//set the opcode
				primOperand_o <= Instruction_i[20:16];//set the first register operand		
				
				//set second operand
				if(InstructionFormat_i == 1)//if 30 bit instruction
				begin
					secOperand_o <= Instruction_i[15:0];//take the bottom 16 bits from instruction 1, as its an immediate val
				end
				else//else a 19 bit instruction
				begin
					secOperand_o <= Instruction_i[15:11];//take the bottom 5 bits from instruction 1, as its an register	
				end
				enable_o <= 1;				
			end
			else//else its a nop
				enable_o <= 0;
		end
	end
endmodule
