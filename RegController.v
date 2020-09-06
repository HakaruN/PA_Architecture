`timescale 1ns / 1ps
`default_nettype none
module RegController(
	//Inputs from the decoder
   input clock_i, reset_i,
	input [5:0] bankSelect_i,//register bank address
   input enableA_i, enableB_i,
	input pwriteA_i, preadA_i, sreadA_i, pwriteB_i, preadB_i, sreadB_i,
	input [1:0] functionTypeA_i, functionTypeB_i,
	input [6:0] opcodeA_i, opcodeB_i,
	input [4:0] primOperandA_i, primOperandB_i,
	input [15:0] secOperandA_i, secOperandB_i,
	
	//outputs to the Exec port
	output reg enableA_o, enableB_o,
	output reg wbA_o, wbB_o,//instruct the exec port to writeback to the reg file
	output reg [6:0] opCodeA_o, opCodeB_o,
	output reg [4:0] regAddrA_o, regAddrB_o,
	output reg [15:0] primOperandA_o, primOperandB_o,//as by this point the register read has happened, all operands are resolved valued (literals not reg addrs)
	output reg [15:0] secOperandA_o, secOperandB_o,
	output reg [1:0] functionTypeA_o, functionTypeB_o,
	
	//inputs to register writeback
	input wbA_i, wbB_i,
	input [4:0] wbAddrA_i, wbAddrB_i,
	input [15:0] wbValA_i, bwVAlB_i
   );
	
	
	//buffer for the inputs that bypass the reg read 
	reg pwriteA, pwriteB;//writeback flag must be reserved
	reg enableA, enableB;//enables to the exec controler
	reg [4:0] regAddrA, regAddrB;
	reg [6:0] opcodeA, opcodeB;
	reg [1:0] functionTypeA, functionTypeB;
	
	wire [15:0] primOperandA, primOperandB;
	wire [15:0] secOperandA, secOperandB;
	
	
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
	
	//writeback inputs (From exec units)
	.writeEnablePortA_i(wbA_i), .writeEnablePortB_i(wbB_i),
	.writeAPortAddr_i(wbAddrA_i), .writeBPortAddr_i(wbAddrB_i),
	.writeAPortData_i(wbValA_i), .writeBPortData_i(bwVAlB_i)	
	);

	 
	 
	 always @(posedge clock_i)
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
		end
		
		if(enableB_i)
		begin
			pwriteB <= pwriteB_i;
			opcodeB <= opcodeB_i;
			regAddrB <= primOperandB_i;	
			functionTypeB <= functionTypeB_i;			
		end
	 end
endmodule
