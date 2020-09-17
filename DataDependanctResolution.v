`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//ATHis units function is to detect data dependencies in the instruction stream and insert nops where needed to prevent RAW hazards
//The way this happens is instructions are submitted to a queue the instructions are checked (coming out of the queue) to see if their data dependencise are ok (by checking if the registers to be read from have a timeout above 0 in the regBlockingFile *see later*
//when all instructions have cleared their dependancies, they are poped from the front of the queue and written to the output.
//
//*see later* - regBlockingFile
//The reg blocking file has an entry for every register (in the current register bank for now), where its address coresponds to an entry in the blockingFile
//if the value at that index is > 0, this means that there is >0 number of clock cycles left before this reg can be read from
//(as a result of an instruction curerntly in flight down the pipeline that will write to that reg)
//////////////////////////////////////////////////////////////////////////////////
module DataDependanctResolution(
	//	control
	input wire clock_i,
	input wire reset_i,
	
	//input
	input wire enableA_i, enableB_i,
	input wire pWriteA_i, pReadA_i, sReadA_i, pWriteB_i, pReadB_i, sReadB_i,
	input wire [1:0] functionTypeA_i, functionTypeB_i,
	input wire [6:0] opcodeA_i, opcodeB_i,
	input wire[4:0] primOperandA_i, primOperandB_i,
	input wire [15:0] secOperandA_i, secOperandB_i,
	input wire shouldStall_i,

	//output
	output reg isStalledA_o,
	output reg isStalledB_o,
	
	output reg enableA_o, enableB_o,
	output reg pwriteA_o, preadA_o, sreadA_o, pwriteB_o, preadB_o, sreadB_o,
	output reg [1:0] functionTypeA_o, functionTypeB_o,
	output reg [6:0] opcodeA_o, opcodeB_o,
	output reg [4:0] primOperandA_o, primOperandB_o,
	output reg [15:0] secOperandA_o, secOperandB_o
    );
	 
	parameter NUM_QUEUE_ENTRIES = 8;//number of entries in the instruction queue
	parameter REG_STALL_DELAY = 8;//how many cycles to block an instruction if it has dependancy	
	
	//instruction queue
	reg [2:0] frontA, backA;					  reg [2:0] frontB, backB;
	reg pEnableA_Q [NUM_QUEUE_ENTRIES -1: 0]; reg pEnableB_Q [NUM_QUEUE_ENTRIES -1: 0];
	reg pWriteA_Q [NUM_QUEUE_ENTRIES -1: 0]; reg pWriteB_Q [NUM_QUEUE_ENTRIES -1: 0];
	reg pReadA_Q [NUM_QUEUE_ENTRIES -1: 0]; reg pReadB_Q [NUM_QUEUE_ENTRIES -1: 0];
	reg sReadA_Q [NUM_QUEUE_ENTRIES -1: 0]; reg sReadB_Q [NUM_QUEUE_ENTRIES -1: 0];
	reg funcTypeA_Q [NUM_QUEUE_ENTRIES -1: 0]; reg funcTypeB_Q [NUM_QUEUE_ENTRIES -1: 0];
	reg [6:0] opcodeA_Q [NUM_QUEUE_ENTRIES -1: 0]; reg [6:0] opcodeB_Q [NUM_QUEUE_ENTRIES -1: 0];
	reg [4:0] pOperandA_Q [NUM_QUEUE_ENTRIES -1: 0]; reg [6:0] pOperandB_Q [NUM_QUEUE_ENTRIES -1: 0];
	reg [15:0] sOperandA_Q [NUM_QUEUE_ENTRIES -1: 0]; reg [15:0] sOperandB_Q [NUM_QUEUE_ENTRIES -1: 0];
	
	//register blocking file
	reg [3:0] regBlockingFile [31:0];
	integer i;
	
	//write instructions into the queue
	always @(posedge clock_i)
	begin
	
		if((enableA_i == 1) && (reset_i == 0))//queue can be written to even if stalled, this allows it to aborb incoming instructions
		begin
			//check if queueA is full
			if(((frontA + 1) % NUM_QUEUE_ENTRIES) > backA)//queue full
			begin
				isStalledA_o <= 1;
				$display("instruction queue A will be full");
			end
			else
			begin
				isStalledA_o <= 0;
				$display("writing instructions to the queue");
				//add elements to the queue
				pEnableA_Q[(backA) % NUM_QUEUE_ENTRIES] <= enableA_i;
				pWriteA_Q[(backA) % NUM_QUEUE_ENTRIES] <= pWriteA_i;
				pReadA_Q[(backA) % NUM_QUEUE_ENTRIES] <= pReadA_i;
				sReadA_Q[(backA) % NUM_QUEUE_ENTRIES] <= sReadA_i;
				funcTypeA_Q[(backA) % NUM_QUEUE_ENTRIES] <= functionTypeA_i;
				opcodeA_Q[(backA) % NUM_QUEUE_ENTRIES] <= opcodeA_i;
				pOperandA_Q[(backA) % NUM_QUEUE_ENTRIES] <= primOperandA_i;
				sOperandA_Q[(backA) % NUM_QUEUE_ENTRIES] <= secOperandA_i;
				backA <= (backA + 1) % NUM_QUEUE_ENTRIES;//increment the back
			end
			
			//check if queueB is full
			if(((frontB + 1) % NUM_QUEUE_ENTRIES) > backB)//queue full
			begin
				isStalledB_o <= 1;
				$display("instruction queue B will be full");
			end
			else
			begin
				isStalledB_o <= 0;
				$display("writing instructions to the queue");
				//add elements to the queue
				pEnableB_Q[(backB) % NUM_QUEUE_ENTRIES] <= enableB_i;
				pWriteB_Q[(backB) % NUM_QUEUE_ENTRIES] <= pWriteB_i;
				pReadB_Q[(backB) % NUM_QUEUE_ENTRIES] <= pReadB_i;
				sReadB_Q[(backB) % NUM_QUEUE_ENTRIES] <= sReadB_i;
				funcTypeB_Q[(backB) % NUM_QUEUE_ENTRIES] <= functionTypeB_i;
				opcodeB_Q[(backB) % NUM_QUEUE_ENTRIES] <= opcodeB_i;
				pOperandB_Q[(backB) % NUM_QUEUE_ENTRIES] <= primOperandB_i;
				sOperandB_Q[(backB) % NUM_QUEUE_ENTRIES] <= secOperandB_i;
				backB <= (backB + 1) % NUM_QUEUE_ENTRIES;//increment the back
			end

		end
		
		
		
		//check the data dependancy for the registers before writing out
		if(shouldStall_i == 0)//if is stalled, can't dequeue
		begin

			if(((pReadA_Q[frontA % NUM_QUEUE_ENTRIES] == 1) && (regBlockingFile[pOperandA_Q[frontA % NUM_QUEUE_ENTRIES]] > 0)) || ((sReadA_Q[frontA % NUM_QUEUE_ENTRIES] == 1) && (regBlockingFile[sOperandA_Q[frontA % NUM_QUEUE_ENTRIES]] > 0) ))//if any reg  is read and is on cooldown; stall
			begin
				$display("Instruction in A has dependancy, stalling for %d or %d (if secondary read) cycles (which ever is greater)", regBlockingFile[pOperandA_Q[frontA % NUM_QUEUE_ENTRIES]], regBlockingFile[sOperandA_Q[frontA % NUM_QUEUE_ENTRIES]]);	
				isStalledA_o <= 1;
			end
			else
				if(frontA == backA)//queue A empty
				begin
					$display("Queue A empty so disable the output");
					enableA_o <= 0;
				end
				else
				begin
					
					//if the instruction wants to do a reg write, set the corresponding entry in the  reg blocking file
					if(pWriteA_Q[frontA % NUM_QUEUE_ENTRIES] == 1)
					begin
						$display("Pipe A dispatching reg write, setting delay on reg %d", pOperandA_Q[frontA % NUM_QUEUE_ENTRIES]);
						regBlockingFile[pOperandA_Q[frontA % NUM_QUEUE_ENTRIES]] <= REG_STALL_DELAY;
					end
					
					enableA_o <= pEnableA_Q[frontA % NUM_QUEUE_ENTRIES];
					pwriteA_o <= pWriteA_Q[frontA % NUM_QUEUE_ENTRIES]; preadA_o <= pReadA_Q[frontA % NUM_QUEUE_ENTRIES]; sreadA_o <= sReadA_Q[frontA % NUM_QUEUE_ENTRIES];
					functionTypeA_o <= funcTypeA_Q[frontA % NUM_QUEUE_ENTRIES]; 
					opcodeA_o <= opcodeA_Q[frontA % NUM_QUEUE_ENTRIES]; 
					primOperandA_o <= pOperandA_Q[frontA % NUM_QUEUE_ENTRIES]; 
					secOperandA_o <= sOperandA_Q[frontA % NUM_QUEUE_ENTRIES]; 
					frontA <= (frontA + 1) % NUM_QUEUE_ENTRIES;	
				end
			end
			begin
			
			if(((pReadB_Q[frontB % NUM_QUEUE_ENTRIES] == 1) && (regBlockingFile[pOperandB_Q[frontB % NUM_QUEUE_ENTRIES]] > 0)) || ((sReadB_Q[frontB % NUM_QUEUE_ENTRIES] == 1) && (regBlockingFile[sOperandB_Q[frontB % NUM_QUEUE_ENTRIES]] > 0) ))//if any reg  is read and is on cooldown; stall
			begin
				$display("Instruction in B has dependancy, stalling for %d or %d (if secondary read) cycles (which ever is greater)", regBlockingFile[pOperandB_Q[frontB % NUM_QUEUE_ENTRIES]], regBlockingFile[sOperandB_Q[frontB % NUM_QUEUE_ENTRIES]]);
				isStalledB_o <= 1;
			end
			else
			begin
				if(frontB == backB)//queue A empty
				begin
					$display("Queue B empty so disable the output");
					enableB_o <= 0;
				end
				else
				begin
					
					//if the instruction wants to do a reg write, set the corresponding entry in the  reg blocking file
					if(pWriteB_Q[frontB % NUM_QUEUE_ENTRIES] == 1)
					begin
						$display("Pipe B dispatching reg write, setting delay on reg %d", pOperandB_Q[frontB % NUM_QUEUE_ENTRIES]);
						regBlockingFile[pOperandB_Q[frontB % NUM_QUEUE_ENTRIES]] <= REG_STALL_DELAY;
					end
				
					enableB_o <= pEnableB_Q[frontB % NUM_QUEUE_ENTRIES];
					pwriteB_o <= pWriteB_Q[frontB % NUM_QUEUE_ENTRIES]; preadB_o <= pReadB_Q[frontB % NUM_QUEUE_ENTRIES]; sreadB_o <= sReadB_Q[frontB % NUM_QUEUE_ENTRIES];
					functionTypeB_o <= funcTypeB_Q[frontB % NUM_QUEUE_ENTRIES];
					opcodeB_o <= opcodeB_Q[frontB % NUM_QUEUE_ENTRIES]; 
					primOperandB_o <= pOperandB_Q[frontB % NUM_QUEUE_ENTRIES]; 
					secOperandB_o <= sOperandB_Q[frontB % NUM_QUEUE_ENTRIES]; 
					frontB <= (frontB + 1) % NUM_QUEUE_ENTRIES;	
				end
			end
			
		end
		
		
		//reset
		if(reset_i == 1)
		begin
			//reset the queue
			frontA <= -1; backA <= 0;
			frontB <= -1; backB <= 0;
			//reset the blocking file
			for(i = 0; i < 32; i = i + 1)
			begin
				regBlockingFile[i] <= 0;
			end
		end
		else
		begin
			for(i = 0; i < 32; i = i + 1)
			begin
				if(regBlockingFile[i] > 0)
					regBlockingFile[i] <= regBlockingFile[i] - 1;
			end
		end
		
	end
endmodule
