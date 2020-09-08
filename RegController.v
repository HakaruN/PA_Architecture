`timescale 1ns / 1ps
`default_nettype none
module RegController(
	//Inputs from the decoder
   input wire clock_i, reset_i,
	input wire [5:0] bankSelect_i,//register bank address
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
	
	//inputs for register writeback (Arithmatic)
	input wire wbA_arith_i, wbB_arith_i,
	input wire [4:0] wbAddrA_arith_i, wbAddrB_arith_i,
	input wire [15:0] wbValA_arith_i, wbVAlB_arith_i,
	input wire [1:0] operationStatusA_i, operationStatusB_i,
	
	//inputs for register writeback (LoadStore)
	input wire wbA_ls_i, wbB_ls_i,
	input wire [4:0] wbAddrA_ls_i, wbAddrB_ls_i,
	input wire [15:0] wbValA_ls_i, bwVAlB_ls_i
   );
	
	
	//buffer for the inputs that bypass the reg read 
	reg pwriteA, pwriteB;//writeback flag must be reserved
	reg enableA, enableB;//enables to the exec controler
	reg [4:0] regAddrA, regAddrB;
	reg [6:0] opcodeA, opcodeB;
	reg [1:0] functionTypeA, functionTypeB;
	
	wire [15:0] primOperandA, primOperandB;
	wire [15:0] secOperandA, secOperandB;
	wire [1:0] operationStatusA, operationStatusB;
	
	
	//register file	
	RegisterFile regFile(
	//regfile system control
	.clock_i(clock_i), .reset_i(reset_i), .bankSelect_i(bankSelect_i),
	
	//reg read
	.readAPrimary_i(preadA_i), .readBPrimary_i(preadB_i),
	.readASecondary_i(sreadA_i), .readBSecondary_i(sreadB_i),
	.readAPortAddr1_i(primOperandA_i), .readBPortAddr1_i(primOperandB_i),
	.readAPortAddr2_i(secOperandA_i), .readBPortAddr2_i(secOperandB_i),
	.readAPortData1_o(primOperandA), .readBPortData1_o(primOperandB),
	.readAPortData2_o(secOperandA), .readBPortData2_o(secOperandB),
	.operationStatusA_o(operationStatusA), .operationStatusB_o(operationStatusB),
	
	//writeback inputs (From exec units)
	.writeEnablePortA_i(wbA_arith_i), .writeEnablePortB_i(wbB_arith_i),
	.writeAPortAddr_i(wbAddrA_arith_i), .writeBPortAddr_i(wbAddrB_arith_i),
	.writeAPortData_i(wbValA_arith_i), .writeBPortData_i(wbVAlB_arith_i),
	.operationStatusA_i(operationStatusA_i),.operationStatusB_i(operationStatusB_i),
	
	//writeback from store unit
	.wbALoadStore_i(wbA_ls_i), .wbBLoadStore_i(wbB_ls_i),
	.wbAAddrLS_i(wbAddrA_ls_i), .wbBAddrLS_i(wbAddrB_ls_i),
	.wbADatLS_i(wbValA_ls_i), .wbBDatLS_i(bwVAlB_ls_i)
	);
	 
	 always @(posedge clock_i)
	 begin
		if(flushBack_i)
		begin
			enableA_o <= 0;
			enableA <= 0;
		end
		else
		begin
			//pass through the enables
			enableA_o <= enableA;
			enableA <= enableA_i; 
			if(enableA)//outputs
			begin
				//passing the buffered data to the exec stage
				//outputs to the Exec por
				
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
				
				pwriteA <= pwriteA_i;
				opcodeA <= opcodeA_i;
				regAddrA <= primOperandA_i;//buffer the register address to writeback to
				functionTypeA <= functionTypeA_i;
			
			end
				
			enableB_o <= enableB;
			enableB <= enableB_i;		
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
				pwriteB <= pwriteB_i;
				opcodeB <= opcodeB_i;
				regAddrB <= primOperandB_i;	
				functionTypeB <= functionTypeB_i;			
			end
		end
	 end
endmodule
