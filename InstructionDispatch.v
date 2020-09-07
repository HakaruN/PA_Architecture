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
		input wire [5:0] regBankSelect_i,
		
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
		output reg loadEnableA_o, loadEnableB_o,
		output reg storeEnableA_o, storeEnableB_o

    );
	 
	 //if this was oo or superscalar the scheduling datastructure would be here
	 
	 always @(posedge clock_i)
	 begin
			arithmaticEnableA_o <= 0; arithmaticEnableB_o <= 0;
			branchEnable_o <= 0;
			loadEnableA_o <= 0;
			regEnable_regUnit_o <= 0;
	 
		 if(enableA_i)
		 begin			
			case(functionalTypeA_i)//functionType_o = Arithmatic, Load/Store, Flow control, regfile (0,1,2,3)
			0:begin arithmaticEnableA_o <= 1; isWbA_o <= isWbA_i; wbAddressA_o <= wbAddressA_i; opCodeA_o <= opCodeA_i; pOperandA_o <= pOperandA_i; sOperandA_o <= sOperandA_i; end//Arithmatic unit invoked
			1:begin end//load/store unit
			2:begin branchEnable_o <= 1; opCode_branch_o <= opCodeA_i; pOperand_branch_o <= pOperandA_i; sOperand_branch_o <= sOperandA_i; end//flow control/branch
			3:begin regEnable_regUnit_o <= 1; opCode_regUnit_o <= opCodeA_i; end//reg stack
			endcase
			
		 end
		 
		 if(enableB_i)
		 begin			
			case(functionalTypeB_i)//functionType_o = Arithmatic, Load/Store, Flow control, regfile (0,1,2,3)
			0:begin arithmaticEnableB_o <= 1; isWbB_o <= isWbB_i; wbAddressB_o <= wbAddressB_i; opCodeB_o <= opCodeB_i; pOperandB_o <= pOperandB_i; sOperandB_o <= sOperandB_i; end//Arithmatic unit invoked
			1:begin end//load/store unit
			2:begin branchEnable_o <= 1; opCode_branch_o <= opCodeB_i; pOperand_branch_o <= pOperandB_i; sOperand_branch_o <= sOperandB_i; end//flow control/branch
			3:begin regEnable_regUnit_o <= 1; opCode_regUnit_o <= opCodeB_i; end//reg stack
			endcase
			
		 end
	 end


endmodule
