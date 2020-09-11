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
			lsOpCodeA_o <= 0; lsOpCodeB_o <= 0;
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
				//setting operands
				pOperandA_o <= pOperandA_i; sOperandA_o <= sOperandA_i; pOperandB_o <= pOperandB_i; sOperandB_o <= sOperandB_i;//arithmatic
				lsPoperandA_o <= pOperandA_i; lsSoperandA_o <= sOperandA_i; lsPoperandB_o <= pOperandB_i; lsSoperandB_o <= sOperandB_i;//load store
				//opcodes
				opCodeA_o <= opCodeA_i; opCodeB_o <= opCodeB_i;
				lsOpCodeA_o <= opCodeA_i; lsOpCodeB_o <= opCodeB_i;
				//writeback addresses
				wbAddressA_o <= wbAddressA_i; wbAddressB_o <= wbAddressB_i;
				lsWbAddressA_o <= wbAddressA_i; lsWbAddressB_o <= wbAddressB_i;
				//iswriteback
				isWbA_o <= isWbA_i; isWbB_o <= isWbB_i;
				isWbLSA_o <= isWbA_i; isWbLSB_o <=isWbB_i;
				
				//branch and reg need inputs buffering in from both pipelines!
				opCode_branch_o <= opCodeA_i; pOperand_branch_o <= pOperandA_i; sOperand_branch_o <= sOperandA_i;//branch on pipeline A only rn
				
				
				
				if(((enableA_i == 1) && (functionalTypeA_i == 2)) | ((enableB_i == 1) && (functionalTypeB_i == 2)))//if either A or B pipelines are a branch
					branchEnable_o <= 1;
				else
				begin
					opStat_branch_o <= 0;//if neither pipeline are branch, dont care about the op status
					branchEnable_o <= 0;
				end
				
				//if both pipelines are active and are branches, discard the instruction	
				if(((enableA_i == 1) && (functionalTypeA_i == 2)) && ((enableB_i == 1) && (functionalTypeB_i == 2)))//if either A or B pipelines are a branch
					branchEnable_o <= 0;
				else//else no branch hazard
				begin
				
					//setting enables for the units
					if(enableA_i == 1)
					begin
						if(functionalTypeA_i == 0)//arith
						begin
							 arithmaticEnableA_o <= enableA_i;
							 branchEnable_o <= 0;
							 loadStoreA_o <= 0;
						end
						else if(functionalTypeA_i == 1)//load store
						begin
							loadStoreA_o <= enableA_i;							
							arithmaticEnableA_o <= 0;						
							branchEnable_o <= 0;
						end
						else if(functionalTypeA_i == 2)//branch
						begin
							arithmaticEnableA_o <= 0;
							opStat_branch_o <= operationStatusA_i;//if pipeline A has the branch, status for pipeline A goes to the branch					
							branchEnable_o <= enableA_i;
						end
					end
					
					if(enableB_i == 1)
					begin
						if(functionalTypeB_i == 0)//arith
						begin
							 arithmaticEnableB_o <= enableB_i;
						end
						else if(functionalTypeB_i == 1)//load store
						begin
							arithmaticEnableB_o <= 0;
							loadStoreB_o <= enableB_i;	
						end
						
						else if(functionalTypeB_i == 2)//branch
						begin
							arithmaticEnableB_o <= 0;
							opStat_branch_o <= operationStatusB_i;//if pipeline B has teh branch, status for pipeline B goes to the branch
						end
					end
				end					
			end
	 end


endmodule
