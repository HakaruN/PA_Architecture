`timescale 1ns / 1ps
`default_nettype none
module Decode(
	input wire clock_i,
	input wire enable_i,
	
	input wire isBranch_i,	
	input wire instructionFormat_i,
	input wire [6:0] opcode_i,	
	input wire [4:0] primOperand_i,
	input wire [15:0] secOperand_i,
	
	output reg [6:0] opcode_o,
	output reg [1:0] functionType_o,	
	output reg [4:0] primOperand_o,
	output reg [15:0] secOperand_o,
	output reg pRead_o, pWrite_o, sRead_o,
	output reg enable_o
);	
//no instructions with read-after-write dependencies may be less than tollerableLatency cycles appart otherwise the read will perform before the write
parameter tollerableLatency = 3;

always @(posedge clock_i)
begin
	enable_o <= enable_i;
	
	if(enable_i)
	begin
		opcode_o <= opcode_i;
		primOperand_o <= primOperand_i;
		secOperand_o <= secOperand_i;	
		//Function type:
		//0 = arithmatic
		//1 = load/store
		//2 = branch
		//3 = reg
		if(isBranch_i)
			if(instructionFormat_i)//Register-imediate
			begin///PRIMARY IS BRANCH OFFSET, SECONDARY IS CONDITION
				//reg-imm branch
				case(opcode_i)//functionType_o = Arithmatic, Load/Store, Flow control, regfile (0,1,2,3)
				7: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 0; end//conditional branch +
				8: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 0; end//unconditional branch +
				9: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 0; end//conditional branch -
				10: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 0; end//unconditional branch -
				endcase
			end
			else//else register-register branch
				begin
				case(opcode_i)
				7: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 1; end//conditional branch +
				8: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 1; end//uconditional branch +
				9: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 1; end//conditional branch -
				10: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 1; end//uconditional branch -
				endcase
			end
		else
		begin//non branch opcodes
			if(instructionFormat_i)//Register-imediate
			begin
				case(opcode_i)
				//reg-imm arith
				0: begin functionType_o <= 0; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//nop
				1: begin functionType_o <= 0; pRead_o <= 1; pWrite_o <= 1; sRead_o <= 0; end//add
				2: begin functionType_o <= 0; pRead_o <= 1; pWrite_o <= 1; sRead_o <= 0; end//sub
				3: begin functionType_o <= 0; pRead_o <= 1; pWrite_o <= 1; sRead_o <= 0; end//mul
				
				//reg-imm load/store
				4: begin functionType_o <= 1; pRead_o <= 0; pWrite_o <= 1; sRead_o <= 0; end//load immediate val to reg
				5: begin functionType_o <= 1; pRead_o <= 0; pWrite_o <= 1; sRead_o <= 0; end//load prim from mem @ addr sec
				6: begin functionType_o <= 1; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 0; end//store prim to mem at addr sec	
				//reg stack-frame
				11: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//reg-frame++
				12: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//reg-frame--
				13: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//request new frame (unimplemented)
				14: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//del current stack frame (unimplemented)
				endcase
			end
			else//Register-Register
			begin
				case(opcode_i)
				//reg-reg arith
				0: begin functionType_o <= 0; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//nop
				1: begin functionType_o <= 0; pRead_o <= 1; pWrite_o <= 1; sRead_o <= 1; end//add
				2: begin functionType_o <= 0; pRead_o <= 1; pWrite_o <= 1; sRead_o <= 1; end//sub
				3: begin functionType_o <= 0; pRead_o <= 1; pWrite_o <= 1; sRead_o <= 1; end//mul
				
				//reg-reg load/store
				4: begin functionType_o <= 1; pRead_o <= 0; pWrite_o <= 1; sRead_o <= 1; end//load immediate val to reg
				5: begin functionType_o <= 1; pRead_o <= 0; pWrite_o <= 1; sRead_o <= 1; end//load prim from mem @ addr sec
				6: begin functionType_o <= 1; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 1; end//store prim to mem at addr sec	
				//reg stack-frame
				11: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//reg-frame++
				12: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//reg-frame--
				13: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//request new frame (unimplemented)
				14: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//del current stack frame (unimplemented)
				endcase
			end
		end
	end
end
endmodule
