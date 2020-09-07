`timescale 1ns / 1ps
`default_nettype none

module BranchUnit(
	input wire clock_i, enable_i, reset_i,
	input wire [6:0] opCode_i,
	input wire [15:0] pOperand_i, sOperand_i,
	input wire [15:0] pc_i,
	
	output reg [15:0] pc_o
    );
	
	always @(posedge clock_i)
	begin
	
		if(reset_i)//if not reset
			pc_o <= 0;
		else
			pc_o <= pc_i + 1;//increment the pc
			
		if(enable_i)
		begin			
			case(opCode_i)
			//need conditonal branches and unconditional branch
			7: begin if(sOperand_i > 0) begin pc_o <= pc_i + pOperand_i; end end//conditional branch-backwards Jump offset by the primary on the condition of the secondary
			8: begin pc_o <= pc_i + pOperand_i; end//conditional branch-forwards Jump offset by the primary on the condition of the secondary
			9: begin if(sOperand_i > 0) begin pc_o <= pc_i - pOperand_i; end end//unconditional branch-backwards Jump offset by the primary
			10: begin pc_o <= pc_i - pOperand_i; end//unconditional branch-forwards Jump offset by the primary
			endcase
			
		end
	end

endmodule
