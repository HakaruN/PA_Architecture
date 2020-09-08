`timescale 1ns / 1ps
`default_nettype none

module BranchUnit(
	input wire clock_i, enable_i, reset_i,
	input wire [6:0] opCode_i,
	input wire [15:0] pOperand_i, sOperand_i,
	input wire [15:0] pc_i,
	input wire flushBack_i,
	input wire [1:0] opStat_i,//[1] = overflow, [0] = underflow
	
	output reg flushBack_o,
	output reg [15:0] pc_o
    );
	
	always @(posedge clock_i)
	begin
		if(reset_i)//if not reset
		begin
			pc_o <= 0;
			flushBack_o <= 0;
		end
		else
			pc_o <= pc_i + 1;//increment the pc
			
		
		
		if(flushBack_i == 1)
		begin
			pc_o <= pc_i;
			flushBack_o <= 0;
		end
		else
		begin
			if(enable_i)
			begin			
				case(opCode_i)
				//need conditonal branches and unconditional branch
				1: begin if(sOperand_i > 0) begin flushBack_o <= 1; pc_o <= pc_i + pOperand_i; end end//conditional branch-forwards, Jump offset by the primary on the condition of the secondary
				2: begin pc_o <= pc_i + pOperand_i; flushBack_o <= 1; end//conditional branch-forwards Jump offset by the primary on the condition of the secondary
				3: begin if(sOperand_i > 0) begin flushBack_o <= 1; pc_o <= pc_i - pOperand_i; end end//unconditional branch-backwards Jump offset by the primary
				4: begin flushBack_o <= 1; pc_o <= pc_i - pOperand_i; end//unconditional branch-backwards Jump offset by the primary
				
				//overflow/underflow branches
				5: begin if(opStat_i[1] == 1) begin $display("branch on overflow"); flushBack_o <= 1; pc_o <= pc_i + pOperand_i; end end//branch forwards on overflow
				6: begin if(opStat_i[0] == 1) begin $display("branch on underflow"); flushBack_o <= 1; pc_o <= pc_i + pOperand_i; end end//branch forwards on underflow
				7: begin if(opStat_i[1] == 1) begin $display("branch on overflow"); flushBack_o <= 1; pc_o <= pc_i - pOperand_i; end end//branch backwards on overflow
				8: begin if(opStat_i[0] == 1) begin $display("branch on underflow"); flushBack_o <= 1; pc_o <= pc_i - pOperand_i; end end//branch backwards on underflow
				 
				endcase
				
			end
		end
	end

endmodule
