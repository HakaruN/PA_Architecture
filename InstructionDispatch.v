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
		
		//output to arithmatic units - there are 2 arithmatic units
		output reg arithmaticEnableA_o, arithmaticEnableB_o,
		output reg isWbA_o, isWbB_o,
		output reg [4:0] wbAddressA_o, wbAddressB_o,
		output reg [6:0] opCodeA_o, opCodeB_o,
		output reg [15:0] pOperandA_o, sOperandA_o, pOperandB_o, sOperandB_o,	
		
		
		//output to branch unit - one shared branch unit
		output reg branchEnable_o,
		output reg [6:0] opCode_branch_o,
		output reg [15:0] pOperand_branch_o, sOperand_branch_o,
		
		//output to reg-stack unit
		output reg regEnable_regUnit_o,		
		output reg [6:0] opCode_regUnit_o,
		
		
		//outputs to load-store
		output reg loadEnable_o, storeEnable_o,
		output reg isWbLSA_o, isWbLSB_o, lsEnableA_o, lsEnableB_o,
		output reg [4:0] lsWbAddressA_o, lsWbAddressB_o,
		output reg [6:0] lsOpCodeA_o, lsOpCodeB_o,
		output reg [15:0]lsPoperandA_o, lsSoperandA_o, lsPoperandB_o, lsSoperandB_o
	
    );
	 //if this was oo or superscalar the scheduling datastructure would be here
	 always @(posedge clock_i)
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
			opCode_regUnit_o <= opCodeA_i;//reg unit
			
			
			if(((enableA_i == 1) && (functionalTypeA_i == 1)) | ((enableB_i == 1) && (functionalTypeB_i == 1)))//if either A or B pipelines are a load store
			begin
				storeEnable_o <= 1;
				loadEnable_o <= 1;
			end
			else
			begin
				storeEnable_o <= 0;
				loadEnable_o <= 0;
			end
			
			if(((enableA_i == 1) && (functionalTypeA_i == 2)) | ((enableB_i == 1) && (functionalTypeB_i == 2)))//if either A or B pipelines are a branch
				branchEnable_o <= 1;
			else
				branchEnable_o <= 0;
			
			
			//setting enables for the units
			if(enableA_i == 1)
			begin
				if(functionalTypeA_i == 0)//arith
				begin
					 arithmaticEnableA_o <= enableA_i;
					 
					 //storeEnable_o <= 0;
					 //loadEnable_o <= 0;
					 lsEnableA_o <= 0;
					 
					 branchEnable_o <= 0;
					 regEnable_regUnit_o <= 0;
				end
				else if(functionalTypeA_i == 1)//load store
				begin
					arithmaticEnableA_o <= 0;
					
					//storeEnable_o <= enableA_i;
					//loadEnable_o <= enableA_i;
					lsEnableA_o <= enableA_i;
					
					branchEnable_o <= 0;
					regEnable_regUnit_o <= 0;
				end
				else if(functionalTypeA_i == 2)//branch
				begin
					arithmaticEnableA_o <= 0;
					
					//storeEnable_o <= 0;
					//loadEnable_o <= 0;
					lsEnableA_o <= 0;
					
					branchEnable_o <= enableA_i;
					regEnable_regUnit_o <= 0;
				end
				else if(functionalTypeA_i == 3)//reg
				begin
					arithmaticEnableA_o <= 0;
					
					//loadEnable_o <= 0;
					//storeEnable_o <= 0;
					lsEnableA_o <= 0;
					
					branchEnable_o <= 0;
					regEnable_regUnit_o <= enableA_i;
				end
			end
			
			if(enableB_i == 1)
			begin
				if(functionalTypeB_i == 0)//arith
				begin
					 arithmaticEnableB_o <= enableB_i;
					 
					 //storeEnable_o <= 0;
					 //loadEnable_o <= 0;
					 lsEnableB_o <= 0;
					 
				end
				else if(functionalTypeB_i == 1)//load store
				begin
					arithmaticEnableB_o <= 0;
					
					//storeEnable_o <= enableB_i;
					//loadEnable_o <= enableB_i;
					lsEnableB_o <= enableB_i;
					
				end
				
				else if(functionalTypeB_i == 2)//branch
				begin
					arithmaticEnableB_o <= 0;
					
					//storeEnable_o <= 0;
					//loadEnable_o <= 0;
					lsEnableB_o <= 0;
									
				end
				else if(functionalTypeB_i == 3)//reg
				begin
					arithmaticEnableB_o <= 0;
					
					//storeEnable_o <= 0;
					//loadEnable_o <= 0;
					lsEnableB_o <= 0;
					
				end
			end	

	 end


endmodule
