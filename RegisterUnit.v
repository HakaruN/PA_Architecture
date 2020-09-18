`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//This is the register unit
//////////////////////////////////////////////////////////////////////////////////
module RegisterUnit(
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


	//register file
	parameter NUM_REGISTERS_PER_BANK = 32, NUM_REG_BANKS = 1;
	reg [15:0] regFile [(NUM_REGISTERS_PER_BANK * NUM_REG_BANKS)-1:0];//512 16bit registers, each register window has 32 registers so we can have 10 stack frames/processes/programs with registers allocated at once
	
		//status register
	reg [1:0] operationStatusA, operationStatusB;//bits 1 pipe-A overflow, bit 0 underflow.
	//selected bank
	reg [5:0] bankSelect;
	
	integer i;	
	
	//input buffers
	//inputs from decode
	reg enableA_ib, enableB_ib;
	reg pwriteA_ib, preadA_ib, sreadA_ib, pwriteB_ib, preadB_ib, sreadB_ib;
	reg [1:0] functionTypeA_ib, functionTypeB_ib;
	reg [6:0] opcodeA_ib, opcodeB_ib;
	reg [4:0] primOperandA_ib, primOperandB_ib;
	reg [15:0] secOperandA_ib, secOperandB_ib;
	
	//inputs for register writeback (loadstore and arithmatic) from the FIFO
	reg wbA_ib, wbB_ib;
	reg [4:0] wbAddrA_ib, wbAddrB_ib;
	reg [15:0] wbValA_ib, wbVAlB_ib;
	reg [1:0] operationStatusA_ib, operationStatusB_ib;
	
	//output buffers
	//stall out
	//reg shouldAStall, shouldBStall;
	
	//outputs to the Exec port
	reg enableA_ob, enableB_ob;
	reg wbA_ob, wbB_ob;
	reg [6:0] opCodeA_ob, opCodeB_ob;
	reg [4:0] regAddrA_ob, regAddrB_ob;
	reg [15:0] primOperandA_ob, primOperandB_ob;
	reg [15:0] secOperandA_ob, secOperandB_ob;
	reg [1:0] functionTypeA_ob, functionTypeB_ob;
	
	always @(posedge clock_i)
	begin
		//assign input buffers
		//input from decode
		enableA_ib <= enableA_i; enableB_ib <= enableB_i;
		pwriteA_ib <= pwriteA_i; preadA_ib <= preadA_i; sreadA_ib <= sreadA_i; pwriteB_ib <= pwriteB_i; preadB_ib <= preadB_i; sreadB_ib <= sreadB_i;
		functionTypeA_ib <= functionTypeA_i; functionTypeB_ib <= functionTypeB_i;
		opcodeA_ib <= opcodeA_i; opcodeB_ib <= opcodeB_i;
		primOperandA_ib <= primOperandA_i; primOperandB_ib <= primOperandB_i;
		secOperandA_ib <= secOperandA_i; secOperandB_ib <= secOperandB_i;
	
		//input from reg writeback
		wbA_ib <= wbA_i; wbB_ib <= wbB_i;
		wbAddrA_ib <= wbAddrA_i; wbAddrB_ib <= wbAddrB_i;		
		wbValA_ib <= wbValA_i; wbVAlB_ib <= wbVAlB_i;
		operationStatusA_ib <= operationStatusA_i; operationStatusB_ib <= operationStatusB_i;
		
		//on reset, the reg file goes to zero
		if(reset_i == 1)
		begin
			bankSelect <= 0;
			for(i = 0; i < NUM_REGISTERS_PER_BANK * NUM_REG_BANKS; i = i + 1)
				regFile[i] <= 0;
		end


		//access the registerfil
		if(wbA_ib)//Port A write (primary)
		begin
			regFile[wbAddrA_ib + (bankSelect * NUM_REGISTERS_PER_BANK)] <= wbValA_ib;
			operationStatusA <= operationStatusA_ib;
		end

		if(enableA_ib == 1)//if pipe A is enabled
		begin
		
			//reg frame instruction
			if(functionTypeA_ib == 3 && opcodeA_ib == 20)//if bank instruction (reg frame++)
			begin
				bankSelect <= bankSelect + 1;//decrement selected bank
				enableA_ob <= 0;//disable output buffers
			end
			else if(functionTypeA_ib == 3 && opcodeA_ib == 21)//if bank instruction (reg frame--)
			begin
				bankSelect <= bankSelect - 1;//decrement selected bank
				enableA_ob <= 0;//disable output buffers
			end
			else if(functionTypeA_ib == 3 && opcodeA_ib == 24)//jump reg back to secondary immediate
			begin
				bankSelect <= secOperandA_ib;
				enableA_ob <= 0;//disable output buffers
			end
			//direct reg assignment
			else if(functionTypeA_ib == 1 && (opcodeA_ib == 10 || opcodeA_ib == 0) && pwriteA_ib)
			begin
				if(sreadA_ib)//if the secondary is a read, its a reg address		
					regFile[primOperandA_ib + (bankSelect * NUM_REGISTERS_PER_BANK)] <= regFile[secOperandA_ib + (bankSelect * NUM_REGISTERS_PER_BANK)];
				else
					regFile[primOperandA_ib + (bankSelect * NUM_REGISTERS_PER_BANK)] <= secOperandA_ib;
				enableA_ob <= 0;//disable output buffers
			end
			else
			begin		
				if(preadA_ib)//Port A read (prim regs)
					primOperandA_ob <= regFile[primOperandA_ib + (bankSelect * NUM_REGISTERS_PER_BANK)];

				if(sreadA_ib)//Port A read (secondary)
					secOperandA_ob <= regFile[secOperandA_ib + (bankSelect * NUM_REGISTERS_PER_BANK)];
				else if(sreadA_ib == 0)//if not sreadA, then its an immediate val
					secOperandA_ob <= secOperandA_ib;
				enableA_ob <= 1;
			end
			
		end

	
		if(wbB_ib)//Port B write (primary)
			regFile[wbAddrB_ib + (bankSelect * NUM_REGISTERS_PER_BANK)] <= wbVAlB_ib;
			operationStatusB <= operationStatusB_ib;
			
		if(enableB_ib == 1)//if pipe B is enabled
		begin
		
			//reg frame instruction
			if(functionTypeB_ib == 3 && opcodeB_ib == 20)//if bank instruction (reg frame++)
			begin
				bankSelect <= bankSelect + 1;//decrement selected bank
				enableB_ob <= 0;//disable output buffers
			end
			else if(functionTypeB_ib == 3 && opcodeB_ib == 21)//if bank instruction (reg frame--)
			begin
				bankSelect <= bankSelect - 1;//decrement selected bank
				enableB_ob <= 0;//disable output buffers
			end
			else if(functionTypeB_ib == 3 && opcodeB_ib == 24)//jump reg back to secondary immediate
			begin
				bankSelect <= secOperandB_ib;
				enableB_ob <= 0;//disable output buffers
			end
			//direct reg assignment
			else if(functionTypeB_ib == 1 && (opcodeB_ib == 10 || opcodeB_ib == 0) && pwriteB_ib)
			begin
				if(sreadB_ib)//if the secondary is a read, its a reg address		
					regFile[primOperandB_ib + (bankSelect * NUM_REGISTERS_PER_BANK)] <= regFile[secOperandB_ib + (bankSelect * NUM_REGISTERS_PER_BANK)];
				else
					regFile[primOperandB_ib + (bankSelect * NUM_REGISTERS_PER_BANK)] <= secOperandB_ib;
				enableB_ob <= 0;//disable output buffers
			end
			else
			begin		
				if(preadB_ib)//Port B read (prim regs)
					primOperandB_ob <= regFile[primOperandB_ib + (bankSelect * NUM_REGISTERS_PER_BANK)];

				if(sreadB_ib)//Port B read (secondary)
					secOperandB_ob <= regFile[secOperandB_ib + (bankSelect * NUM_REGISTERS_PER_BANK)];
				else if(sreadB_ib == 0)//if not sreadA, then its an immediate val
					secOperandB_ob <= secOperandB_ib;
				enableB_ob <= 1;
			end			
		end
		
		//update the output buffers
		wbA_ob <= pwriteA_ib; wbB_ob <= pwriteB_ib;
		opCodeA_ob <= opcodeA_ib; opCodeB_ob <= opcodeB_ib;	
		regAddrA_ob <= primOperandA_ib; regAddrB_ob <= primOperandB_ib;
		functionTypeA_ob <= functionTypeA_ib; functionTypeB_ob <= functionTypeB_ib;	
		//operationStatusA_ob <= operationStatusA; operationStatusB_ob <= operationStatusB;
		
		//write to out the output buffers
		enableA_o <= enableA_ob; enableB_o <= enableB_ob;
		wbA_o <= wbA_ob; wbB_o <= wbB_ob;
		opCodeA_o <= opCodeA_ob; opCodeB_o <= opCodeB_ob;
		regAddrA_o <= regAddrA_ob; regAddrB_o <= regAddrB_ob;
		primOperandA_o <= primOperandA_ob; primOperandB_o <= primOperandB_ob;
		secOperandA_o <= secOperandA_ob; secOperandB_o <= secOperandB_ob;
		functionTypeA_o <= functionTypeA_ob; functionTypeB_o <= functionTypeB_ob;
		operationStatusA_o <= operationStatusA; operationStatusB_o <= operationStatusB;

	end

endmodule
