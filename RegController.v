`timescale 1ns / 1ps
`default_nettype none
module RegController(
	//Inputs from the decoder
   input wire clock_i, reset_i,
   input wire enableA_i, enableB_i,
	input wire pwriteA_i, preadA_i, sreadA_i, pwriteB_i, preadB_i, sreadB_i,
	input wire[1:0] functionTypeA_i, functionTypeB_i,
	input wire [6:0] opcodeA_i, opcodeB_i,
	input wire[4:0] primOperandA_i, primOperandB_i,
	input wire [15:0] secOperandA_i, secOperandB_i,
	input wire flushBack_i, 
	
	//outputs to the Exec port
	output reg enableA_o, enableB_o,
	output reg wbA_o, wbB_o,//instruct the exec port to writeback to the reg file
	output reg [6:0] opCodeA_o, opCodeB_o,
	output reg [4:0] regAddrA_o, regAddrB_o,
	output reg [15:0] primOperandA_o, primOperandB_o,//as by this point the register read has happened, all operands are resolved valued (literals not reg addrs)
	output reg [15:0] secOperandA_o, secOperandB_o,
	output reg [1:0] functionTypeA_o, functionTypeB_o,
	output reg [1:0] operationStatusA_o, operationStatusB_o,
	
	//inputs for register writeback (loadstore and arithmatic) from the FIFO
	input wire wbA_i, wbB_i,
	input wire [4:0] wbAddrA_i, wbAddrB_i,
	input wire [15:0] wbValA_i, wbVAlB_i,
	input wire [1:0] operationStatusA_i, operationStatusB_i
   );	
	
	//buffer for the inputs that bypass the reg read 
	reg pwriteA, pwriteB;//writeback flag must be preserved
	reg enableA, enableB;//enables to the exec controler
	reg [4:0] regAddrA, regAddrB;
	reg [6:0] opcodeA, opcodeB;
	reg [1:0] functionTypeA, functionTypeB;
	
	wire [15:0] primOperandA, primOperandB;
	wire [15:0] secOperandA, secOperandB;	
	
	//register assignment
	reg assignEnableA, assignEnableB;
	reg [4:0] assignAddrA, assignAddrB;
	reg [15:0] assignDatA, assignDatB;
	reg isSecReadA, isSecReadB;	
	
	//status register
	reg [1:0] operationStatusA, operationStatusB;//bits 1 pipe-A overflow, bit 0 underflow.
	
	//selected bank
	reg [5:0] bankSelect;
	
	
	//register file	
	registerFile regFile(
	//clock in
	.clock_i(clock_i), .reset_i(reset_i),
	
	//bank selection
	.bankSelect_i(bankSelect),	
	
	//generic port writes
	.portAWriteEnable_i(wbA_i), .portBWriteEnable_i(wbB_i),
	.portAWriteAddress_i(wbAddrA_i), .portBWriteAddress_i(wbAddrB_i),
	.portAWriteData_i(wbValA_i), .portBWriteData_i(wbVAlB_i),
	
	//generic port reads (prim regs on pos edge)
	.portAReadPrimEnable_i(preadA_i), .portBReadPrimEnable_i(preadB_i),
	.portAReadPrimAddr_i(primOperandA_i), .portBReadPrimAddr_i(primOperandB_i),
	.portAReadPrimOutput_o(primOperandA), .portBReadPrimOutput_o(primOperandB),
	
	//generic port reads (sec regs on neg edge)
	.portASecRead_i(sreadA_i), .portBSecRead_i(sreadB_i),
	.portAReadSecEnable_i(enableA_i), .portBReadSecEnable_i(enableB_i),
	.portAReadSecAddr_i(secOperandA_i), .portBReadSecAddr_i(secOperandB_i),
	.portAReadSecOutput_o(secOperandA), .portBReadSecOutput_o(secOperandB),
	
	//port writes (reg assignment/loadStore writes on neg edge)
	.portASecReadAssign_i(isSecReadA), .portBSecReadAssign_i(isSecReadB),
	.regAssignAEnable_i(assignEnableA), .regAssignBEnable_i(assignEnableB),
	.regAssignAAddress_i(assignAddrA), .regAssignBAddress_i(assignAddrB),
	.regAssignAData_i(assignDatA), .regAssignBData_i(assignDatB)
	);
	 
	 always @(posedge clock_i)
	 begin
		if(reset_i == 1)
		begin
			//operationStatusA <= 0;
			//operationStatusB <= 0;
			bankSelect <= 0;
		end
			
		if(flushBack_i)
		begin
			enableA_o <= 0;
			enableA <= 0;
			assignEnableA <= 0;
		end
		else
		begin
			
			
			//pass through the enables
			enableA_o <= enableA;
			enableA <= enableA_i; 
			assignEnableA <= 0;
			if(wbA_i)//if arithmatic writeback
				operationStatusA <= operationStatusA_i;//then set the status reg
			if(wbB_i)//if arithmatic writeback
				operationStatusB <= operationStatusB_i;//then set the status reg
			
			if(enableA)//outputs
			begin
				//passing the buffered data to the exec stage
				//outputs to the Exec port				
				wbA_o <= pwriteA;
				opCodeA_o <= opcodeA;
				regAddrA_o <= regAddrA;//buffer the register address to writeback to
				primOperandA_o <= primOperandA;
				secOperandA_o <= secOperandA;
				functionTypeA_o <= functionTypeA;
				operationStatusA_o <= operationStatusA;
			end
			
			if(enableA_i)//inputs
			begin			
				//the operands aren't buffered through here as they are buffered in the reg file so go directly to the output (of here) from the reg file
				//buffering the inputs that go around the reg read - the other inputs are either droped in the reg file or are buffered through the reg file
				if(functionTypeA_i == 1 && (opcodeA_i == 10 || opcodeA_i == 0) && pwriteA_i)//if a load/store instruction and if its a reg assignment
				begin
						//perform the direct reg assignment
						assignEnableA <= enableA_i; 
						assignAddrA <= primOperandA_i;
						assignDatA <= secOperandA_i;
						isSecReadA <= sreadA_i;						
						
						//insert a nop in place of this instruction as its retiring here
						pwriteA <= 0;
						opcodeA <= 0;
						regAddrA <= 0;//buffer the register address to writeback to
						functionTypeA <= 0;
				end
				else if(functionTypeA_i == 3 && opcodeA_i == 20)//if bank instruction (reg frame++)
				begin
					bankSelect <= bankSelect + 1;
				end
				else if(functionTypeA_i == 3 && opcodeA_i == 21)//if bank instruction (reg frame--)
				begin
					bankSelect <= bankSelect - 1;
				end
				else
				begin
					
					pwriteA <= pwriteA_i;
					opcodeA <= opcodeA_i;
					regAddrA <= primOperandA_i;//buffer the register address to writeback to
					functionTypeA <= functionTypeA_i;
				end
			end
				
			enableB_o <= enableB;
			enableB <= enableB_i;	
			assignEnableB <= 0;			
			if(enableB)
			begin			
				wbB_o <= pwriteB;
				opCodeB_o <= opcodeB;			
				regAddrB_o <= regAddrB;
				primOperandB_o <= primOperandB;
				secOperandB_o <= secOperandB;
				functionTypeB_o <= functionTypeB;
				operationStatusB_o <= operationStatusB;
			end
			
			if(enableB_i)
			begin
			if(functionTypeB_i == 1 && (opcodeB_i == 10 || opcodeB_i == 0) && pwriteB_i)//if a load/store instruction and if its a reg assignment op, and the primary writeback is enabled
				begin
					//perform the direct reg assignment
					assignEnableB <= enableB_i; 
					assignAddrB <= primOperandB_i;
					assignDatB <= secOperandB_i;
					isSecReadB <= sreadB_i;	
					
					//insert a nop in place of this instruction as its retiring here
					pwriteB <= 0;
					opcodeB <= 0;
					regAddrB <= 0;	
					functionTypeB <= 0;
				end
				else
				begin
					pwriteB <= pwriteB_i;
					opcodeB <= opcodeB_i;
					regAddrB <= primOperandB_i;	
					functionTypeB <= functionTypeB_i;			
				end
			end
		end
	 end
endmodule
