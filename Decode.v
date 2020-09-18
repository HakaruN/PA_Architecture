`timescale 1ns / 1ps
`default_nettype none
module Decode(
	//control
	input wire clock_i,
	input wire enable_i,
	input wire flushBack_i, 
	input wire shouldStall_i,
	//input
	input wire isBranch_i,	
	input wire instructionFormat_i,
	input wire [6:0] opcode_i,	
	input wire [4:0] primOperand_i,
	input wire [15:0] secOperand_i,
	
	//control out
	output reg shouldStall_o,
	//output
	output reg [6:0] opcode_o,
	output reg [1:0] functionType_o,	
	output reg [4:0] primOperand_o,
	output reg [15:0] secOperand_o,
	output reg pRead_o, pWrite_o, sRead_o,
	output reg enable_o
);	

always @(posedge clock_i)
begin
	if(flushBack_i == 1)
	begin
		enable_o <= 0;
	end
	else
	begin
		enable_o <= enable_i;		
		if(enable_i == 1  && (shouldStall_i == 0))
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
					0: begin functionType_o <= 0; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//nop
					1: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 0; end//conditional branch +
					2: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 0; end//unconditional branch +
					3: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 0; end//conditional branch -
					4: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 0; end//unconditional branch -
					5: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 0; end//branch forwards on overflow
					6: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 0; end//branch forwards on underflow
					7: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 0; end//branch backwards on overflow
					8: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 0; end//branch backwards on underflow
					endcase
				end
				else//else register-register branch
					begin
					case(opcode_i)
					0: begin functionType_o <= 0; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//nop
					1: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 1; end//conditional branch +
					2: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 1; end//uconditional branch +
					3: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 1; end//conditional branch -
					4: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 1; end//uconditional branch -
					5: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 0; end//branch forwards on overflow
					6: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 0; end//branch forwards on underflow
					7: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 0; end//branch backwards on overflow
					8: begin functionType_o <= 2; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 0; end//branch backwards on underflow
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
					10: begin functionType_o <= 1; pRead_o <= 0; pWrite_o <= 1; sRead_o <= 0; end//load immediate val to reg
					11: begin functionType_o <= 1; pRead_o <= 0; pWrite_o <= 1; sRead_o <= 0; end//load prim from mem @ addr sec
					12: begin functionType_o <= 1; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 0; end//store prim to mem at addr sec	
					//reg stack-frame
					20: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//reg-frame++
					21: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//reg-frame--
					22: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//request new frame (unimplemented)
					23: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//del current stack frame (unimplemented)
					24: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//jump to reg frame at secondary
					25: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//jump to reg frame at primary (unimplemented)
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
					10: begin functionType_o <= 1; pRead_o <= 0; pWrite_o <= 1; sRead_o <= 1; end//load immediate val to reg
					11: begin functionType_o <= 1; pRead_o <= 0; pWrite_o <= 1; sRead_o <= 1; end//load prim from mem @ addr sec
					12: begin functionType_o <= 1; pRead_o <= 1; pWrite_o <= 0; sRead_o <= 1; end//store prim to mem at addr sec	
					//reg stack-frame
					20: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//reg-frame++
					21: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//reg-frame--
					22: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//request new frame (unimplemented)
					23: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 0; end//del current stack frame (unimplemented)
					24: begin functionType_o <= 3; pRead_o <= 0; pWrite_o <= 0; sRead_o <= 1; end//just to reg frame at secondary (unimplemented)
					endcase
				end
			end
		end
	end
end
endmodule
