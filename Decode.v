`timescale 1ns / 1ps
`default_nettype none
module Decode(
	input clock_i,
	input enable_i,
	
	input isBranch_i,	
	input instructionFormat_i,
	input [6:0] opcode_i,	
	input [4:0] primOperand_i,
	input [15:0] secOperand_i,
	
	output reg [6:0] opcode_o,
	output reg [1:0] functionType_o,	
	output reg [4:0] primOperand_o,
	output reg [15:0] secOperand_o,
	output reg pRead_o, pWrite_o, sRead_o,
	output reg enable_o
);	
	
always @(posedge clock_i)
begin
	enable_o <= enable_i;
	
	if(enable_i)
	begin
		opcode_o <= opcode_i;
		primOperand_o <= primOperand_i;
		secOperand_o <= secOperand_i;	
		if(isBranch_i)
			if(instructionFormat_i)//Register-imediate
			begin
				case(opcode_i)//functionType_o = Arithmatic, Load/Store, Flow control (1,2,3. 0 nop)
				0: begin functionType_o <= 0; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end
				1: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 1; end//sec val (imm) is the branch offset
				2: begin functionType_o <= 3; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 1; end//prim is condition reg, sec val (imm) is offset
				endcase
			end
			else//else register-register
				begin
				case(opcode_i)
				0: begin functionType_o <= 0; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end
				1: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 1; end//sec reg is the branch offset
				2: begin functionType_o <= 3; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 1; end//prim is condition reg, sec reg is the branch offset
				endcase
			end
		else
		begin//non branch opcodes
			if(instructionFormat_i)//Register-imediate
			begin
				case(opcode_i)
				//reg-imm arith
				0: begin functionType_o <= 0; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end
				1: begin functionType_o <= 1; pRead_o <= 1; pWrite_o <= 1; sRead_o <= 0; end//add
				2: begin functionType_o <= 1; pRead_o <= 1; pWrite_o <= 1; sRead_o <= 0; end//sub
				3: begin functionType_o <= 1; pRead_o <= 1; pWrite_o <= 1; sRead_o <= 0; end//mul
				//reg-imm load/store
				4: begin functionType_o <= 2; pRead_o <= 0; pWrite_o <= 1; sRead_o <= 0; end//load
				5: begin functionType_o <= 2; pRead_o <= 0; pWrite_o <= 1; sRead_o <= 0; end//store
				endcase
			end
			else//Register-Register
			begin
				case(opcode_i)
				//reg-reg arith
				0: begin functionType_o <= 0; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end
				1: begin functionType_o <= 1; pRead_o <= 1; pWrite_o <= 1; sRead_o <= 1; end//add
				2: begin functionType_o <= 1; pRead_o <= 1; pWrite_o <= 1; sRead_o <= 1; end//sub
				3: begin functionType_o <= 1; pRead_o <= 1; pWrite_o <= 1; sRead_o <= 1; end//mul
				//reg-reg load/store
				4: begin functionType_o <= 2; pRead_o <= 0; pWrite_o <= 1; sRead_o <= 1; end//load
				5: begin functionType_o <= 2; pRead_o <= 0; pWrite_o <= 1; sRead_o <= 1; end//store
				endcase
			end
		end
	end
end
endmodule
