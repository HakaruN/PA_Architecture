`timescale 1ns / 1ps
`default_nettype none

module InstructionDispatch(
		input wire clock_i, reset_i,
		input wire isWbA_i, isWbB_i,
		input wire enableA_i, enableB_i,
		input wire [1:0] functionalTypeA_i, functionalTypeB_i,
		input wire [4:0] wbAddressA_i, wbAddressB_i,
		input wire [6:0] opCodeA_i, opCodeB_i,
		input wire [15:0] pOperandA_i, sOperandA_i, pOperandB_i, sOperandB_i,
		input wire [1:0] operationStatusA_i, operationStatusB_i,
		input wire flushBack_i,
		
		//output to arithmatic units - there are 2 arithmatic units
		output reg arithmaticEnableA_o, arithmaticEnableB_o,
		output reg isWbA_o, isWbB_o,
		output reg [4:0] wbAddressA_o, wbAddressB_o,
		output reg [6:0] opCodeA_o, opCodeB_o,
		output reg [15:0] pOperandA_o, sOperandA_o, pOperandB_o, sOperandB_o,	
		
		
		//output to branch unit - one shared branch unit
		output reg branchEnable_o,
		output reg [1:0] opStat_branch_o,//2 bits which are set according to the pipeline used
		output reg [6:0] opCode_branch_o,
		output reg [15:0] pOperand_branch_o, sOperand_branch_o,
		
		
		//outputs to load-store
		output reg isWbLSA_o, isWbLSB_o,
		output reg loadStoreA_o, loadStoreB_o,
		output reg [4:0] lsWbAddressA_o, lsWbAddressB_o,
		output reg [6:0] lsOpCodeA_o, lsOpCodeB_o,
		output reg [15:0]lsPoperandA_o, lsSoperandA_o, lsPoperandB_o, lsSoperandB_o
    );
	 //if this was oo or superscalar the scheduling datastructure would be here
	 always @(posedge clock_i)
	 begin
			if(flushBack_i == 1)//all outputs set to 0
			begin			
			pOperandA_o <= 0; sOperandA_o <= 0; pOperandB_o <= 0; sOperandB_o <= 0;
			lsPoperandA_o <= 0; lsSoperandA_o <= 0; lsPoperandB_o <= 0; lsSoperandB_o <= 0;
			opCodeA_o <= 0; opCodeB_o <= 0;
			wbAddressA_o <= 0; wbAddressB_o <= 0;
			lsWbAddressA_o <= 0; lsWbAddressB_o <= 0;
			isWbA_o <= 0; isWbB_o <= 0;
			isWbLSA_o <= 0; isWbLSB_o <=0;			
			opCode_branch_o <= 0; pOperand_branch_o <= 0; sOperand_branch_o <= 0;
			opStat_branch_o <= 0;
			loadStoreA_o <= 0; loadStoreB_o <= 0;
			branchEnable_o <= 0;
			arithmaticEnableA_o <= 0;
			opStat_branch_o <= 0;//set overflow/underflow to 0
			end
			else
			begin
				//setting enables for the units
				if(enableA_i == 1)
				begin
					if(functionalTypeA_i == 0)//arith
					begin
						pOperandA_o <= pOperandA_i; sOperandA_o <= sOperandA_i;//operands for arithmatic
						arithmaticEnableA_o <= enableA_i;
						opCodeA_o <= opCodeA_i;
						wbAddressA_o <= wbAddressA_i;
						isWbA_o <= isWbA_i;//is writeback allowed
						
						branchEnable_o <= 0;
						loadStoreA_o <= 0;
					end
					else if(functionalTypeA_i == 1)//load store
					begin
						lsPoperandA_o <= pOperandA_i; lsSoperandA_o <= sOperandA_i;//loaadstore operands
						loadStoreA_o <= enableA_i;//set opcode		
						lsOpCodeA_o <= opCodeA_i;//set loadstore enable
						lsWbAddressA_o <= wbAddressA_i;//set store writeback address
						isWbLSA_o <= isWbA_i;//is writeback allowed
						
						arithmaticEnableA_o <= 0;						
						branchEnable_o <= 0;
					end
					else if(functionalTypeA_i == 2)//branch
					begin
						opCode_branch_o <= opCodeA_i;//branch opcode
						pOperand_branch_o <= pOperandA_i; sOperand_branch_o <= sOperandA_i;//branch operands							
						opStat_branch_o <= operationStatusA_i;//if pipeline A has the branch, status for pipeline A goes to the branch					
						branchEnable_o <= enableA_i;
						
						arithmaticEnableA_o <= 0;
						loadStoreA_o <= 0;//no loadstore enabled for pipe A
					end
				end
				
				if(enableB_i == 1)
				begin
					if(functionalTypeB_i == 0)//arith
					begin
						pOperandB_o <= pOperandB_i; sOperandB_o <= sOperandB_i;//arithmatic operands
						arithmaticEnableB_o <= enableB_i;//enable
						opCodeB_o <= opCodeB_i;//opcode
						wbAddressB_o <= wbAddressB_i;//writeback addr
						isWbB_o <= isWbB_i;//is writeback allowed
						
						loadStoreB_o <= 0;
					end
					else if(functionalTypeB_i == 1)//load store
					begin
						lsPoperandB_o <= pOperandB_i; lsSoperandB_o <= sOperandB_i;//load store
						lsOpCodeB_o <= opCodeB_i;//set opcode						
						loadStoreB_o <= enableB_i;//set loadstore enable
						lsWbAddressB_o <= wbAddressB_i;//set store writeback address
						isWbLSB_o <=isWbB_i;//is writeback allowed
						
						arithmaticEnableB_o <= 0;
						
					end						
					else if(functionalTypeB_i == 2)//branch
					begin
						opCode_branch_o <= opCodeB_i;//branch opcode
						pOperand_branch_o <= pOperandB_i; sOperand_branch_o <= sOperandB_i;//branch operands							
						opStat_branch_o <= operationStatusB_i;//if pipeline A has the branch, status for pipeline A goes to the branch					
						branchEnable_o <= enableB_i;
						
						arithmaticEnableB_o <= 0;
						loadStoreB_o <= 0;				
					end
				end				
			end
	 end


endmodule
