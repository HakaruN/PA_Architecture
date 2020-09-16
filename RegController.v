`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
//The reg controller has a number of functions
//Its first function is to provide an interface between the register file and the core
//Instructions from decode come to the register file with 3 flags, an opcode and 2 operands. 
//The flags indicate if the first (primary) operand is to be read from, written to and if the second operand is to be read from
//If the primary operand is to be written to this is a writeback (after execution, EG $A = $A + $B)
//If the primary operand is to be read from, this indicates that the instruction requires the value stored in the primary operand (reg)
//If the second operand it to be read from, this indicatates that the instruction requires the value stored in the secondary operand (therefore is a register address)
//If the secondary operand is not to be read from, this indicates that the data passed in as the secondary operand is not a register value and therefore is an immediate value.
//
//The reg controller also provides an interface for data to be written back to the reg file, with one writeback port for each pipeline (A and B)
//
//Another function of the reg controller is to detect data dependencies in the instruction stream and insert nops where needed to prevent RAW hazards
//The way this happens is instructions are submitted to a queue on entry to the control unit.
//once its their turn, the instructions are checked to see if their data dependencise are ok (by checking if the registers to be read from have a timeout above 0 in the regBlockingFile *see later*
//when all instructions have cleared their dependancies, they are poped from the front of the queue and placed into a buffer
//(actually multiple buffers, one for each component of the instruction, these buffers are known as the "post queue buffers")
//From, this buffer, the parts of the instruction that need access to the reg file are passed to the regfile, the parts that do not need regfile acces are put into
//another buffer called the "reg file bypass buffer" where they are held for the cycle until the rest of the instruction returns from the regfile (with the register values resolved)
//with the instruction all together, they are sent to the reg controller output to go to the next pipeline stage
//
//*see later* - regBlockingFile
//The reg blocking file has an entry for every register (in the current register bank for now), where its address coresponds to an entry in the blockingFile
//if the value at that index is > 0, this means that there is >0 number of clock cycles left before this reg can be read from
//(as a result of an instruction curerntly in flight down the pipeline that will write to that reg)
//////////////////////////////////////////////////////////////////////////////////
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
	
	//post queue buffers
	reg enableA, enableB;
	reg pwriteA, pwriteB;
	reg preadA, preadB;
	reg sreadA, sreadB;
	reg [1:0] functionTypeA, functionTypeB;
	reg [6:0] opcodeA, opcodeB;
	reg [4:0] primOperandA, primOperandB;
	reg [15:0] secOperandA, secOperandB;
	
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
	//register blocking file
	reg [3:0] regBlockingFile [31:0];
	//selected bank
	reg [5:0] bankSelect = 0;
	
	
	//instruction queue
	reg [3:0] frontA, backA;					  reg [3:0] frontB, backB;
	reg pWriteA_Q [NUM_QUEUE_ENTRIES -1: 0]; reg pWriteB_Q [NUM_QUEUE_ENTRIES -1: 0];
	reg pReadA_Q [NUM_QUEUE_ENTRIES -1: 0]; reg pReadB_Q [NUM_QUEUE_ENTRIES -1: 0];
	reg sReadA_Q [NUM_QUEUE_ENTRIES -1: 0]; reg sReadB_Q [NUM_QUEUE_ENTRIES -1: 0];
	reg funcTypeA_Q [NUM_QUEUE_ENTRIES -1: 0]; reg funcTypeB_Q [NUM_QUEUE_ENTRIES -1: 0];
	reg [6:0] opcodeA_Q [NUM_QUEUE_ENTRIES -1: 0]; reg [6:0] opcodeB_Q [NUM_QUEUE_ENTRIES -1: 0];
	reg [4:0] pOperandA_Q [NUM_QUEUE_ENTRIES -1: 0]; reg [6:0] pOperandB_Q [NUM_QUEUE_ENTRIES -1: 0];
	reg [15:0] sOperandA_Q [NUM_QUEUE_ENTRIES -1: 0]; reg [15:0] sOperandB_Q [NUM_QUEUE_ENTRIES -1: 0];
	
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
	
	//generic port reads (prim regs)
	.portAReadPrimEnable_i(preadA), .portBReadPrimEnable_i(preadB),
	.portAReadPrimAddr_i(primOperandA), .portBReadPrimAddr_i(primOperandB),
	.portAReadPrimOutput_o(primOperandReturnA), .portBReadPrimOutput_o(primOperandReturnB),
	
	
	//generic port reads (sec regs)
	.portASecRead_i(sreadA), .portBSecRead_i(sreadB),
	.portAReadSecEnable_i(enableA_i), .portBReadSecEnable_i(enableB_i),
	.portAReadSecAddr_i(secOperandA), .portBReadSecAddr_i(secOperandB),
	.portAReadSecOutput_o(secOperandReturnA), .portBReadSecOutput_o(secOperandReturnB),
	
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
			//reset the status registers
			operationStatusA <= 0;
			operationStatusB <= 0;
			//reset the bank selection
			bankSelect <= 0;			
			//reset the queues
			frontA <= 0; frontB <= 0;
			backA <= 0; backB <= 0;
			//reset the blocking file
			for(i = 0; i < 32; i = i + 1)
			begin
				regBlockingFile[i] <= 0;
			end
		end
			
		if(flushBack_i)
		begin//if flushback
			enableA_o <= 0;
			enableA <= 0;
			enableB_o <= 0;
			enableB <= 0;
			assignEnableA <= 0;
			assignEnableB <= 0;
			//empty the queues
			frontA <= 0; frontB <= 0;
			backA <= 0; backB <= 0;
			//reset the blocking file
			for(i = 0; i < 32; i = i + 1)
			begin
				regBlockingFile[i] <= 0;
			end
		end
		else
		begin	
	
			if(((frontA + 2) % NUM_QUEUE_ENTRIES) > backA)//queue full
			begin
				shouldAStall_o <= 1;
				//$display("instruction queue will be full");
			end
			if(((frontB + 2) % NUM_QUEUE_ENTRIES) > backB)//queue full
			begin
				shouldBStall_o <= 0;
				//$display("instruction queue will be full");
			end			
		
			////Pushing instructions from decode to the queues		
			if(enableA_i == 1)//if A is eneabled, enqueue A
			begin
				//$display("Pushing to queue A");
				//add a new entry to the queue
				pWriteA_Q[(backA) % NUM_QUEUE_ENTRIES] <= pwriteA_i;
				pReadA_Q[(backA) % NUM_QUEUE_ENTRIES] <= preadA_i;
				sReadA_Q[(backA) % NUM_QUEUE_ENTRIES] <= sreadA_i;
				funcTypeA_Q[(backA) % NUM_QUEUE_ENTRIES] <= functionTypeA_i;
				opcodeA_Q[(backA) % NUM_QUEUE_ENTRIES] <= opcodeA_i;
				pOperandA_Q[(backA) % NUM_QUEUE_ENTRIES] <= primOperandA_i;
				sOperandA_Q[(backA) % NUM_QUEUE_ENTRIES] <= secOperandA_i;
				//push back the back by 1
				backA <= (backA + 1) % NUM_QUEUE_ENTRIES;
			end
			
			if(enableB_i == 1)//if B is eneabled, enqueue B
			begin
				//$display("Pushing to queue B");
				//add a new entry to the queue
				pWriteB_Q[(backB) % NUM_QUEUE_ENTRIES] <= pwriteB_i;
				pReadB_Q[(backB) % NUM_QUEUE_ENTRIES] <= preadB_i;
				sReadB_Q[(backB) % NUM_QUEUE_ENTRIES] <= sreadB_i;
				funcTypeB_Q[(backB) % NUM_QUEUE_ENTRIES] <= functionTypeB_i;
				opcodeB_Q[(backB) % NUM_QUEUE_ENTRIES] <= opcodeB_i;
				pOperandB_Q[(backB) % NUM_QUEUE_ENTRIES] <= primOperandB_i;
				sOperandB_Q[(backB) % NUM_QUEUE_ENTRIES] <= secOperandB_i;
				//push back the back by 1
				backB <= (backB + 1) % NUM_QUEUE_ENTRIES;
			end

			
			///Poping instructions from the queues
			if(frontA == backA)//FIFO empty
			begin
				//$display("instruction queue A empty");
				//$display("A front: %d, Back: %d", frontA, backA);
				shouldAStall_o <= 0;//unstall if were empty so we can take instructions in
				enableA <= 0;//if empty, make sure were not stalled
			end
			else
			begin
				//$display("A - Register access patterns: %d, %d", pReadA_Q[frontA % NUM_QUEUE_ENTRIES], sReadA_Q[frontA % NUM_QUEUE_ENTRIES]);
				//$display("A - Register depenancy: %d, %d", regBlockingFile[pOperandA_Q[frontA % NUM_QUEUE_ENTRIES]], regBlockingFile[sOperandA_Q[frontA % NUM_QUEUE_ENTRIES]]);
				if((pReadA_Q[frontA % NUM_QUEUE_ENTRIES] == 1) && (sReadA_Q[frontA % NUM_QUEUE_ENTRIES] == 1))//if we need to read both registers
				begin
					if((regBlockingFile[pOperandA_Q[frontA % NUM_QUEUE_ENTRIES]] > 0) || (regBlockingFile[sOperandA_Q[frontA % NUM_QUEUE_ENTRIES]] > 0))
					begin//if the entry at the front needs to read registers that are currently blocking, stall
						//stall
						enableA <= 0;
						//$display("A has RAW dependency");
						shouldAStall_o <= 1;//stall if we have dependancy
					end
					else if((regBlockingFile[pOperandA_Q[frontA % NUM_QUEUE_ENTRIES]] == 0) && (regBlockingFile[sOperandA_Q[frontA % NUM_QUEUE_ENTRIES]] == 0))
					begin//if the entry at the front of the queue wants to read registers that are not blocking, pop from the queue
						//pop from queue
						enableA <= 1;
						pwriteA <= pWriteA_Q[frontA % NUM_QUEUE_ENTRIES];
						preadA <= pReadA_Q[frontA % NUM_QUEUE_ENTRIES];
						sreadA <= sReadA_Q[frontA % NUM_QUEUE_ENTRIES];
						functionTypeA <= funcTypeA_Q[frontA % NUM_QUEUE_ENTRIES];
						opcodeA <= opcodeA_Q[frontA % NUM_QUEUE_ENTRIES];
						primOperandA <= pOperandA_Q[frontA % NUM_QUEUE_ENTRIES];
						secOperandA <= sOperandA_Q[frontA % NUM_QUEUE_ENTRIES];
						//incrementing the front
						frontA <= frontA + 1; 	
						//$display("Poping A");
						shouldAStall_o <= 0;//unstall is we can pop
						
					end
					
				end
				else if((pReadA_Q[frontA % NUM_QUEUE_ENTRIES] == 1) && (sReadA_Q[frontA % NUM_QUEUE_ENTRIES] == 0))//if we need to the prim register
				begin
					if(regBlockingFile[pOperandA_Q[frontA % NUM_QUEUE_ENTRIES]] > 0)
					begin//if the entry at the front needs to read the primary reg which is blocking, stall
						//stall
						enableA <= 0;
						//$display("A has RAW dependecny");
						shouldAStall_o <= 1;//stall if we have dependancy
					end
					else if(regBlockingFile[pOperandA_Q[frontA % NUM_QUEUE_ENTRIES]] == 0)
					begin//if the entry at the front of the queue wants to the prim reg that is not blocking, pop from the queue
						//pop from queue
						enableA <= 1;
						pwriteA <= pWriteA_Q[frontA % NUM_QUEUE_ENTRIES];
						preadA <= pReadA_Q[frontA % NUM_QUEUE_ENTRIES];
						sreadA <= sReadA_Q[frontA % NUM_QUEUE_ENTRIES];
						functionTypeA <= funcTypeA_Q[frontA % NUM_QUEUE_ENTRIES];
						opcodeA <= opcodeA_Q[frontA % NUM_QUEUE_ENTRIES];
						primOperandA <= pOperandA_Q[frontA % NUM_QUEUE_ENTRIES];
						secOperandA <= sOperandA_Q[frontA % NUM_QUEUE_ENTRIES];
						//incrementing the front
						frontA <= frontA + 1; 	
						//$display("Poping A");	
						shouldAStall_o <= 0;//unstall is we can pop						
					end
					
				end
				else if((pReadA_Q[frontA % NUM_QUEUE_ENTRIES] == 0) && (sReadA_Q[frontA % NUM_QUEUE_ENTRIES] == 1))//if we need to the sec register
				begin
					if(regBlockingFile[sOperandA_Q[frontA % NUM_QUEUE_ENTRIES]] > 0)
					begin//if the entry at the front needs to read the sec reg which is blocking, stall
						//stall
						enableA <= 0;
						//$display("A has RAW dependecny");
						shouldAStall_o <= 1;//stall if we have dependancy
					end
					else if(regBlockingFile[sOperandA_Q[frontA % NUM_QUEUE_ENTRIES]] == 0)
					begin//if the entry at the front of the queue wants to the sec reg that is not blocking, pop from the queue
						//pop from queue
						enableA <= 1;
						pwriteA <= pWriteA_Q[frontA % NUM_QUEUE_ENTRIES];
						preadA <= pReadA_Q[frontA % NUM_QUEUE_ENTRIES];
						sreadA <= sReadA_Q[frontA % NUM_QUEUE_ENTRIES];
						functionTypeA <= funcTypeA_Q[frontA % NUM_QUEUE_ENTRIES];
						opcodeA <= opcodeA_Q[frontA % NUM_QUEUE_ENTRIES];
						primOperandA <= pOperandA_Q[frontA % NUM_QUEUE_ENTRIES];
						secOperandA <= sOperandA_Q[frontA % NUM_QUEUE_ENTRIES];
						//incrementing the front
						frontA <= frontA + 1; 			
						//$display("Poping A");
						shouldAStall_o <= 0;//unstall is we can pop	
					end
					
				end
				else if((pReadA_Q[frontA % NUM_QUEUE_ENTRIES] == 0) && (sReadA_Q[frontA % NUM_QUEUE_ENTRIES] == 0))//if we need no reg reads
				begin//ino dependancies
					//pop from queue
					enableA <= 1;
					pwriteA <= pWriteA_Q[frontA % NUM_QUEUE_ENTRIES];
					preadA <= pReadA_Q[frontA % NUM_QUEUE_ENTRIES];
					sreadA <= sReadA_Q[frontA % NUM_QUEUE_ENTRIES];
					functionTypeA <= funcTypeA_Q[frontA % NUM_QUEUE_ENTRIES];
					opcodeA <= opcodeA_Q[frontA % NUM_QUEUE_ENTRIES];
					primOperandA <= pOperandA_Q[frontA % NUM_QUEUE_ENTRIES];
					secOperandA <= sOperandA_Q[frontA % NUM_QUEUE_ENTRIES];
					//incrementing the front
					frontA <= frontA + 1; 			
					//$display("Poping A");
					shouldAStall_o <= 0;//unstall is we can pop	
				end
				
			end
			
			if(frontB == backB)//FIFO empty
			begin
				//$display("instruction queue B empty");
				//$display("A front: %d, Back: %d", frontB, backB);
				shouldBStall_o <= 0;//unstall if were empty so we can take instructions in
				enableB <= 0;
			end
			else
			begin
				if((pReadB_Q[frontB % NUM_QUEUE_ENTRIES] == 1) && (sReadB_Q[frontB % NUM_QUEUE_ENTRIES] == 1))//if we need to read both registers
				begin
					if((regBlockingFile[pOperandB_Q[frontB % NUM_QUEUE_ENTRIES]] > 0) || (regBlockingFile[sOperandB_Q[frontB % NUM_QUEUE_ENTRIES]] > 0))
					begin//if the entry at the front needs to read registers that are currently blocking, stall
						//stall
						enableB <= 0;
						//$display("B has RAW dependecny");
						shouldBStall_o <= 1;//stall if we have dependancy
					end
					else if((regBlockingFile[pOperandB_Q[frontB % NUM_QUEUE_ENTRIES]] == 0) && (regBlockingFile[sOperandB_Q[frontB % NUM_QUEUE_ENTRIES]] == 0))
					begin//if the entry at the front of the queue wants to read registers that are not blocking, pop from the queue
						//pop from queue
						enableB <= 1;
						pwriteB <= pWriteB_Q[frontB % NUM_QUEUE_ENTRIES];
						preadB <= pReadB_Q[frontB % NUM_QUEUE_ENTRIES];
						sreadB <= sReadB_Q[frontB % NUM_QUEUE_ENTRIES];
						functionTypeB <= funcTypeB_Q[frontB % NUM_QUEUE_ENTRIES];
						opcodeB <= opcodeB_Q[frontB % NUM_QUEUE_ENTRIES];
						primOperandB <= pOperandB_Q[frontB % NUM_QUEUE_ENTRIES];
						secOperandB <= sOperandB_Q[frontB % NUM_QUEUE_ENTRIES];
						//incrementing the front
						frontB <= frontB + 1; 	
						//$display("Poping B");
						shouldBStall_o <= 0;//unstall is we can pop	
					end
					
				end
				else if((pReadB_Q[frontB % NUM_QUEUE_ENTRIES] == 1) && (sReadB_Q[frontB % NUM_QUEUE_ENTRIES] == 0))//if we need to the prim register
				begin
					if(regBlockingFile[pOperandB_Q[frontB % NUM_QUEUE_ENTRIES]] > 0)
					begin//if the entry at the front needs to read the primary reg which is blocking, stall
						//stall
						enableB <= 0;
						//$display("B has RAW dependecny");
						shouldBStall_o <= 1;//stall if we have dependancy
					end
					else if(regBlockingFile[pOperandB_Q[frontB % NUM_QUEUE_ENTRIES]] == 0)
					begin//if the entry at the front of the queue wants to the prim reg that is not blocking, pop from the queue
						//pop from queue
						enableB <= 1;
						pwriteB <= pWriteB_Q[frontB % NUM_QUEUE_ENTRIES];
						preadB <= pReadB_Q[frontB % NUM_QUEUE_ENTRIES];
						sreadB <= sReadB_Q[frontB % NUM_QUEUE_ENTRIES];
						functionTypeB <= funcTypeB_Q[frontB % NUM_QUEUE_ENTRIES];
						opcodeB <= opcodeB_Q[frontB % NUM_QUEUE_ENTRIES];
						primOperandB <= pOperandB_Q[frontB % NUM_QUEUE_ENTRIES];
						secOperandB <= sOperandB_Q[frontB % NUM_QUEUE_ENTRIES];
						//incrementing the front
						frontB <= frontB + 1;
						//$display("Poping B");
						shouldBStall_o <= 0;//unstall is we can pop						
					end
					
				end
				else if((pReadB_Q[frontB % NUM_QUEUE_ENTRIES] == 0) && (sReadB_Q[frontB % NUM_QUEUE_ENTRIES] == 1))//if we need to the sec register
				begin
					if(regBlockingFile[sOperandB_Q[frontB % NUM_QUEUE_ENTRIES]] > 0)
					begin//if the entry at the front needs to read the sec reg which is blocking, stall
						//stall
						enableB <= 0;
						//$display("B has RAW dependecny");
						shouldBStall_o <= 1;//stall if we have dependancy
					end
					else if(regBlockingFile[sOperandB_Q[frontB % NUM_QUEUE_ENTRIES]] == 0)
					begin//if the entry at the front of the queue wants to the sec reg that is not blocking, pop from the queue
						//pop from queue
						enableB <= 1;
						pwriteB <= pWriteB_Q[frontB % NUM_QUEUE_ENTRIES];
						preadB <= pReadB_Q[frontB % NUM_QUEUE_ENTRIES];
						sreadB <= sReadB_Q[frontB % NUM_QUEUE_ENTRIES];
						functionTypeB <= funcTypeB_Q[frontB % NUM_QUEUE_ENTRIES];
						opcodeB <= opcodeB_Q[frontB % NUM_QUEUE_ENTRIES];
						primOperandB <= pOperandB_Q[frontB % NUM_QUEUE_ENTRIES];
						secOperandB <= sOperandB_Q[frontB % NUM_QUEUE_ENTRIES];
						//incrementing the front
						frontB <= frontB + 1;
						//$display("Poping B");
						shouldBStall_o <= 0;//unstall is we can pop
					end					
				end
				else if((pReadB_Q[frontB % NUM_QUEUE_ENTRIES] == 0) && (sReadB_Q[frontB % NUM_QUEUE_ENTRIES] == 0))//if we need no reg reads
				begin//no dependancies
					//pop from queue
					enableB <= 1;
					pwriteB <= pWriteB_Q[frontB % NUM_QUEUE_ENTRIES];
					preadB <= pReadB_Q[frontB % NUM_QUEUE_ENTRIES];
					sreadB <= sReadB_Q[frontB % NUM_QUEUE_ENTRIES];
					functionTypeB <= funcTypeB_Q[frontB % NUM_QUEUE_ENTRIES];
					opcodeB <= opcodeB_Q[frontB % NUM_QUEUE_ENTRIES];
					primOperandB <= pOperandB_Q[frontB % NUM_QUEUE_ENTRIES];
					secOperandB <= sOperandB_Q[frontB % NUM_QUEUE_ENTRIES];
					//incrementing the front
					frontB <= frontB + 1; 			
					//$display("Poping B");
					shouldBStall_o <= 0;//unstall is we can pop
				end
				
			end
			///END OF QUEUE
			
			//apply blocking entry where needed
			if(pwriteA == 1)//if the preg is going to be writen back to
			begin//apply the delay to the corresponding reg entry in the blockingFile
				regBlockingFile[primOperandA] <= REG_STALL_DELAY;
			end
			if(pwriteB == 1)
			begin
				regBlockingFile[primOperandB] <= REG_STALL_DELAY;
			end
			
			//examine instructions coming out of the queue, if theyre resolveble here then resolve them here, otherwise dump em out onto the output
			if(bypassFunctionTypeA == 3 && bypassOpcodeA == 20)//if bank instruction (reg frame++)
			begin
				bankSelect <= bankSelect + 1;
				assignEnableA <= 0; //dissable direct reg assignment
			end
			else if(bypassFunctionTypeA == 3 && bypassOpcodeA == 21)//if bank instruction (reg frame--)
			begin
				bankSelect <= bankSelect - 1;
				assignEnableA <= 0; //dissable direct reg assignment
			end
			else if(bypassFunctionTypeA == 1 && (bypassOpcodeA == 10 || bypassOpcodeA == 0) && bypassPWriteA)//if a load/store instruction and if its a reg assignment
			begin
				$display("Pipe A direct reg assignment");
				$display("Reg addr: %d", bypassRegAddrA);
				$display("Assigned value: %d", secOperandReturnA);
				$display("is secondary read: %d", bypassSReadA);
				//perform the direct reg assignment
				assignEnableA <= 1; 
				assignAddrA <= bypassRegAddrA;
				assignDatA <= secOperandReturnA;
				isSecReadA <= bypassSReadA;		
				
				//insert a nop in place of this instruction as its retiring here
				enableA_o <= bypassEnableA;
				pwriteA <= 0;
				opcodeA <= 0;
				functionTypeA <= 0;
				enableA <= 0;
				
			end
			else
			begin
				assignEnableA <= 0; //dissable direct reg assignment
				//assign outputs
				enableA_o <= bypassEnableA;
				wbA_o <= bypassPWriteA;
				opCodeA_o <= bypassOpcodeA;
				regAddrA_o <= 	bypassRegAddrA;//address for writeback
				primOperandA_o <= primOperandReturnA;
				secOperandA_o <= secOperandReturnA;
				functionTypeA_o <= bypassFunctionTypeA;
				operationStatusA_o <= operationStatusA;
			end
	

			
			//examine instructions coming out of the queue, if theyre resolveble here then resolve them here, otherwise dump em out onto the output
			if(bypassFunctionTypeB == 3 && bypassOpcodeB == 20)//if bank instruction (reg frame++)
			begin
				bankSelect <= bankSelect + 1;
				assignEnableB <= 0; //dissable direct reg assignment
			end
			else if(bypassFunctionTypeB == 3 && bypassOpcodeB == 21)//if bank instruction (reg frame--)
			begin
				bankSelect <= bankSelect - 1;
				assignEnableB <= 0; //dissable direct reg assignment
			end
			else if(bypassFunctionTypeB == 1 && (bypassOpcodeB == 10 || bypassOpcodeB == 0) && bypassPWriteB)//if a load/store instruction and if its a reg assignment
			begin
				$display("Pipe B direct reg assignment");
				$display("Reg addr: %d", bypassRegAddrB);
				$display("Assigned value: %d", secOperandReturnB);/////NOT SET
				$display("is secondary read: %d", bypassSReadB);
				//perform the direct reg assignment
				assignEnableB <= 1; 
				assignAddrB <= bypassRegAddrB;
				assignDatB <= secOperandReturnB;
				isSecReadB <= bypassSReadB;		
				
				//insert a nop in place of this instruction as its retiring here
				enableA_o <= bypassEnableB;
				pwriteB <= 0;
				opcodeB <= 0;
				functionTypeB <= 0;
				enableB <= 0;
			end
			else
			begin
				assignEnableB <= 0; //dissable direct reg assignment
				//assign outputs
				enableB_o <= bypassEnableB;
				wbB_o <= bypassPWriteB;
				opCodeB_o <= bypassOpcodeB;
				regAddrB_o <= 	bypassRegAddrB;//address for writeback
				primOperandB_o <= primOperandReturnB;
				secOperandB_o <= secOperandReturnB;
				functionTypeB_o <= bypassFunctionTypeB;
				operationStatusB_o <= operationStatusB;
			end
			
			
			//set the bypass registers
			bypassPWriteA <= pwriteA;
			bypassEnableA <= enableA;
			bypassRegAddrA <= primOperandA;
			bypassOpcodeA <= opcodeA;
			bypassFunctionTypeA <= functionTypeA;
			bypassSReadA <= sreadA;
			
			bypassPWriteB <= pwriteB;
			bypassEnableB <= enableB;
			bypassRegAddrB <= primOperandB;
			bypassOpcodeB <= opcodeB;
			bypassFunctionTypeB <= functionTypeB;
			bypassSReadB <= sreadB;

		
			if(wbA_i)//if arithmatic writeback
				operationStatusA <= operationStatusA_i;//then set the status reg
			if(wbB_i)//if arithmatic writeback
				operationStatusB <= operationStatusB_i;//then set the status reg
		end
	end
endmodule
