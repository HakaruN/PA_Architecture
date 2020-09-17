`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
//
//Its function is to provide an interface between the register file and the core
//Instructions from decode come to the register file with 3 flags, an opcode and 2 operands. 
//The flags indicate if the first (primary) operand is to be read from, written to and if the second operand is to be read from
//If the primary operand is to be written to this is a writeback (after execution, EG $A = $A + $B)
//If the primary operand is to be read from, this indicates that the instruction requires the value stored in the primary operand (reg)
//If the second operand it to be read from, this indicatates that the instruction requires the value stored in the secondary operand (therefore is a register address)
//If the secondary operand is not to be read from, this indicates that the data passed in as the secondary operand is not a register value and therefore is an immediate value.
//
//The reg controller also provides an interface for data to be written back to the reg file, with one writeback port for each pipeline (A and B)
//

//////////////////////////////////////////////////////////////////////////////////
module RegController(
	//Inputs from the decoder
   input wire clock_i, reset_i,
   input wire enableA_i, enableB_i,
	
	//generic inputs
	input wire pwriteA_i, preadA_i, sreadA_i, pwriteB_i, preadB_i, sreadB_i,
	input wire[1:0] functionTypeA_i, functionTypeB_i,
	input wire [6:0] opcodeA_i, opcodeB_i,
	input wire[4:0] primOperandA_i, primOperandB_i,
	input wire [15:0] secOperandA_i, secOperandB_i,
	input wire flushBack_i, 
	
	//control out
	output reg shouldAStall_o,
	output reg shouldBStall_o,
	
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
	
	//number of entries in the instruction queue
	parameter NUM_QUEUE_ENTRIES = 8;
	parameter REG_STALL_DELAY = 6;//how many cycles to block a reg read on a reg write for. (goes in the blocking table)
	
	integer i;

	//reg file bypass buffer
	reg bypassPWriteA, bypassPWriteB;
	reg bypassEnableA, bypassEnableB;
	reg [4:0] bypassRegAddrA, bypassRegAddrB;
	reg [6:0] bypassOpcodeA, bypassOpcodeB;
	reg [1:0] bypassFunctionTypeA, bypassFunctionTypeB;
	reg bypassSReadA, bypassSReadB;
	//non-bypassed return
	wire [15:0] primOperandReturnA, primOperandReturnB;
	wire [15:0] secOperandReturnA, secOperandReturnB;
	
	//register assignment
	reg isSecReadA, isSecReadB;
	reg assignEnableA, assignEnableB;
	reg [4:0] assignAddrA, assignAddrB;
	reg [15:0] assignDatA, assignDatB;
	
	
	
	//status register
	reg [1:0] operationStatusA, operationStatusB;//bits 1 pipe-A overflow, bit 0 underflow.
	//selected bank
	reg [5:0] bankSelect = 0;
	
	
	//register file	
	registerFile regFile(
	//clock in
	.clock_i(clock_i), .reset_i(reset_i),
	
	//bank selection
	.bankSelect_i(bankSelect),
	
	//generic port writes (writeback)
	.portAWriteEnable_i(wbA_i), .portBWriteEnable_i(wbB_i),
	.portAWriteAddress_i(wbAddrA_i), .portBWriteAddress_i(wbAddrB_i),
	.portAWriteData_i(wbValA_i), .portBWriteData_i(wbVAlB_i),
	
	
	//generic port reads (prim regs)
	.portAReadPrimEnable_i(preadA_i), .portBReadPrimEnable_i(preadB_i),
	.portAReadPrimAddr_i(primOperandA_i), .portBReadPrimAddr_i(primOperandB_i),
	.portAReadPrimOutput_o(primOperandReturnA), .portBReadPrimOutput_o(primOperandReturnB),
	
	//generic port reads (sec regs)
	.portASecRead_i(sreadA_i), .portBSecRead_i(sreadB_i),
	.portAReadSecEnable_i(enableA_i), .portBReadSecEnable_i(enableB_i),
	.portAReadSecAddr_i(secOperandA_i), .portBReadSecAddr_i(secOperandB_i),
	.portAReadSecOutput_o(secOperandReturnA), .portBReadSecOutput_o(secOperandReturnB),
	
	//port writes (reg assignment)
	.portASecReadAssign_i(isSecReadA), .portBSecReadAssign_i(isSecReadB),
	.regAssignAEnable_i(assignEnableA), .regAssignBEnable_i(assignEnableB),
	.regAssignAAddress_i(assignAddrA), .regAssignBAddress_i(assignAddrB),
	.regAssignAData_i(assignDatA), .regAssignBData_i(assignDatB)
	
	);
	 
	 always @(posedge clock_i)
	 begin
	 	
		if((flushBack_i == 1) || (reset_i == 1))//if flushback or reset
		begin//disable the outputs
			enableA_o <= 0;
			enableB_o <= 0;
		end
		
		//assign outputs (if the instruction was resolved here (eg reg assign), a nop was inserted into these buffers that are being dumped out)
		enableA_o <= bypassEnableA; 				enableB_o <= bypassEnableB;
		wbA_o <= bypassPWriteA; 					wbB_o <= bypassPWriteB;
		opCodeA_o <= bypassOpcodeA; 				opCodeB_o <= bypassOpcodeB;
		regAddrA_o <= bypassRegAddrA; 			regAddrB_o <= bypassRegAddrB;
		primOperandA_o <= primOperandReturnA; 	primOperandB_o <= primOperandReturnB;
		secOperandA_o <= secOperandReturnA; 	secOperandB_o <= secOperandReturnB;
		functionTypeA_o <= bypassFunctionTypeA; functionTypeB_o <= bypassFunctionTypeB;
		operationStatusA_o <=  operationStatusA; operationStatusB_o <=  operationStatusB;
		
		
		
		//examine instructions coming out of the queue, if theyre resolveble here then resolve them here, otherwise dump em out onto the output
		if(functionTypeA_i == 3 && opcodeA_i == 20)//if bank instruction (reg frame++)
		begin
			bankSelect <= bankSelect + 1;
			assignEnableA <= 0; //dissable direct reg assignment
		end
		else if(functionTypeA_i == 3 && opcodeA_i == 21)//if bank instruction (reg frame--)
		begin
			bankSelect <= bankSelect - 1;
			assignEnableA <= 0; //dissable direct reg assignment
		end
		else if(functionTypeA_i == 1 && (opcodeA_i == 10 || opcodeA_i == 0) && pwriteA_i)//if a load/store instruction and if its a reg assignment
		begin
			$display("Pipe A direct reg assignment");
			$display("Reg addr: %d", primOperandA_i);
			$display("Assign value: %d", secOperandA_i);
			$display("is secondary read: %d", sreadA_i);
			//perform the direct reg assignment
			assignEnableA <= 1; 
			assignAddrA <= primOperandA_i;
			assignDatA <= secOperandA_i;
			isSecReadA <= sreadA_i;		
			
			//insert a nop in place of this instruction as its retiring here
			bypassEnableA <= 1;
			bypassOpcodeA <= 0;
			functionTypeA <= 0;			
		end
		else
		begin
			assignEnableA <= 0; //dissable direct reg assignment
			//assign bypass buffers
			bypassEnableA <= enableA_i;
			bypassPWriteA <= pwriteA_i;
			bypassRegAddrA <= primOperandA_i;
			bypassOpcodeA <= opcodeA_i;
			bypassFunctionTypeA <= functionTypeA_i;
			bypassSReadA <= sreadA_i; 	
		end
		
		
		//examine instructions coming out of the queue, if theyre resolveble here then resolve them here, otherwise dump em out onto the output
		if(functionTypeB_i == 3 && opcodeB_i == 20)//if bank instruction (reg frame++)
		begin
			bankSelect <= bankSelect + 1;
			assignEnableB <= 0; //dissable direct reg assignment
		end
		else if(functionTypeB_i == 3 && opcodeB_i == 21)//if bank instruction (reg frame--)
		begin
			bankSelect <= bankSelect - 1;
			assignEnableB <= 0; //dissable direct reg assignment
		end
		else if(functionTypeB_i == 1 && (opcodeB_i == 10 || opcodeB_i == 0) && pwriteB_i)//if a load/store instruction and if its a reg assignment
		begin
			$display("Pipe B direct reg assignment");
			$display("Reg addr: %d", primOperandB_i);
			$display("Assign value: %d", secOperandB_i);
			$display("is secondary read: %d", sreadB_i);
			//perform the direct reg assignment
			assignEnableB <= 1; 
			assignAddrB <= primOperandB_i;
			assignDatB <= secOperandB_i;
			isSecReadB <= sreadB_i;		
			
			//insert a nop in place of this instruction as its retiring here
			bypassEnableB <= 1;
			bypassOpcodeB <= 0;
			functionTypeB <= 0;		
		end
		else
		begin
			assignEnableB <= 0; //dissable direct reg assignment
			//assign bypass buffers
			bypassEnableB <= enableB_i;
			bypassPWriteB <= pwriteB_i;
			bypassRegAddrB <= primOperandB_i;		
			bypassOpcodeB <= opcodeB_i;
			bypassFunctionTypeB <= functionTypeB_i;
			bypassSReadB <= sreadB_i; 	
		end
		
	end
endmodule
