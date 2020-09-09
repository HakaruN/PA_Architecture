`timescale 1ns / 1ps
`default_nettype none

module BranchUnit(
	input wire clock_i, enable_i, reset_i,
	input wire [6:0] opCode_i,
	input wire [15:0] pOperand_i, sOperand_i,
	input wire flushBack_i,
	input wire [1:0] opStat_i,//[1] = overflow, [0] = underflow
	
	output reg flushBack_o,
	//output reg [15:0] pc_o
	
	output reg shouldBranch_o,
	output reg branchDirection_o,
	output reg [15:0] branchOffset_o
    );
	
	always @(posedge clock_i)
	begin
		if(reset_i)//if reset
		begin
			shouldBranch_o <= 0;
			branchDirection_o <= 0;
			branchOffset_o <= 0;
		end
		else//if not reset
		begin
			flushBack_o <= 0;//if we just flushed the pipe, dont do it again
		end
			
		
		
		if(flushBack_i == 1)//if the pipeline was flushed (flushback in is set)
		begin
			flushBack_o <= 0;//if we just flushed the pipe, dont do it again
		end
		else
		begin
			if(enable_i)
			begin			
				branchOffset_o <= pOperand_i;
				shouldBranch_o <= 1;
				flushBack_o <= 1;
				
				case(opCode_i)
				//need conditonal branches and unconditional branch
				1: begin if(sOperand_i > 0) begin	branchDirection_o <= 1; end end//conditional branch-forwards, Jump offset by the primary on the condition of the secondary
				2: begin 									branchDirection_o <= 1; end//conditional branch-forwards Jump offset by the primary on the condition of the secondary
				3: begin if(sOperand_i > 0) begin 	branchDirection_o <= 0; end end//unconditional branch-backwards Jump offset by the primary
				4: begin 									branchDirection_o <= 0; end//unconditional branch-backwards Jump offset by the primary
				
				//overflow/underflow branches
				5: begin if(opStat_i[1] == 1) begin branchDirection_o <= 1; end end//branch forwards on overflow
				6: begin if(opStat_i[0] == 1) begin branchDirection_o <= 1; end end//branch forwards on underflow
				7: begin if(opStat_i[1] == 1) begin branchDirection_o <= 0; end end//branch backwards on overflow
				8: begin if(opStat_i[0] == 1) begin branchDirection_o <= 0; end end//branch backwards on underflow
				endcase
			end
			else//if not enabled, disable any branch and dont flush the pipe
			begin
				shouldBranch_o <= 0;
				flushBack_o <= 0;
			end
		end
	end

endmodule
