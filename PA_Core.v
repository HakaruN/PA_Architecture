`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Josh "Hakaru" Cantwelel
// 
// Create Date:    20:08:00 09/06/2020 
// Design Name: PA Architecture
// Module Name:    PA_Core 
// Project Name: PA Architecture
// Target Devices: Xilinx core3s500e
// Description: A VLIW-2 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module PA_Core(
		//core state
		input wire clock_i,
		input wire reset_i,
		
		//icache programing
		input wire shiftRegWriteClock_i,//comes from the writing device
		input wire icacheWriteEnable_i,
		input wire enable_i,
		input wire  writeAddress_i,
		input wire [7:0] shiftRegData_i,
		//output
		output reg [15:0] PC_o,
		output reg wbAArith_o,
		output reg [4:0] wbAddrAFinal_o,
		output reg [15:0] wbValAFinal_o
    );	
	 
	parameter BLOCK_SIZE = 32;//32 bytes per cacheline
	parameter BITS_PER_BYTE = 8;//8 bits to a byte
	parameter CACHE_LINES = 256;//256 cachelines
	
	//instruction cache write
	wire icacheWriteEnable;
	wire [7:0] writeAddress;
	wire [BLOCK_SIZE * BITS_PER_BYTE - 1:0] cachelineWrite;
	
	cachWriteShiftReg cacheWriteRegister(
		.iCacheWriteEnable_i(icacheWriteEnable_i), 
		.regEnable_i(enable_i),
		.reset_i(reset_i),
		.shiftClock_i(shiftRegWriteClock_i), 
		.shiftByte_i(shiftRegData_i),		
		.addressEnable_i(writeAddress_i), 
		
		.icacheWriteEnable_o(icacheWriteEnable), 
		.writeAddress_o(writeAddress), 
		.instruction_o(cachelineWrite)
	);
	 
	//i-cache output - fetch input
	reg [15:0] PC;
	wire flushBack;//flush line that indicates all pipelines before the branch unit are to flush the stages
		
	//branch control - used by the PA_Core module
	wire shouldBranch;
	wire [15:0] branchOffset;
	wire branchDirection;
	
	//fetch 1 out, fetch 2 in
	wire [BLOCK_SIZE * BITS_PER_BYTE - 1:0] cacheline;
	wire fetch1enable;	
	
	FetchStage1 fetch1(
	//control
	.clock_i(clock_i),
	.reset_i(reset_i),	
	//inputs
	.blockAddr_i(PC[15:5]), 
	.writeEnable_i(icacheWriteEnable), 
	.writeAddress_i(writeAddress), 
	.writeBlock_i(cachelineWrite), 	
	//outputs
	.block_o(cacheline), 
	.enable_o(fetch1enable)	
	);
	
	//fetch 2 out, parse in
	wire backDisable;
	wire [3:0] nextByteOffset;
	wire [31:0] InstructionA, InstructionB;
	wire InstructionAFormat, InstructionBFormat;
	wire fetchAEnableO, fetchBEnableO;
	
	FetchStage2 fetch2(
	//control
	.clock_i(clock_i),
	.reset_i(reset_i),
	.enable_i(fetch1enable),
	//input
	.byteAddr_i(PC[4:0]),
	.block_i(cacheline),	
	//output
	.backDisable_o(backDisable),//disables the first fetch unit
	.nextByteOffset_o(nextByteOffset),
	.InstructionA_o(InstructionA), .InstructionB_o(InstructionB),
	.InstructionAFormat_o(InstructionAFormat), .InstructionBFormat_o(), 
	.enableA_o(fetchAEnableO), .enableB_o(fetchBEnableO)
	);
	
	//parse out - decode in
	wire instructionAFormat_po, instructionBFormat_po;
	wire isBranchA_po, isBranchB_po;
	wire [6:0] opcodeA_po, opcodeB_po;
	wire [4:0] primOperandA_po, primOperandB_po;
	wire [15:0] secOperandA_po,secOperandB_po;
	wire enableA_po, enableB_po;
	
	Parser parseA(
		//control
		.clock_i(clock_i), .enable_i(fetchAEnableO),
		//input
		.Instruction_i(InstructionA), .InstructionFormat_i(InstructionAFormat),
		//output
		.instructionFormat_o(instructionAFormat_po), .isBranch_o(isBranchA_po), .opcode_o(opcodeA_po),
		.primOperand_o(primOperandA_po), .secOperand_o(secOperandA_po), .enable_o(enableA_po)
	);
	
	Parser parseB(
		//control
		.clock_i(clock_i), .enable_i(fetchBEnableO),
		//input
		.Instruction_i(InstructionB), .InstructionFormat_i(InstructionBFormat),
		//output
		.instructionFormat_o(instructionBFormat_po), .isBranch_o(isBranchB_po), .opcode_o(opcodeB_po),
		.primOperand_o(primOperandB_po), .secOperand_o(secOperandB_po), .enable_o(enableB_po)
	);
	
	//Decode out - (dep unit in) Reg reg in
	wire [6:0] opcodeA, opcodeB;
	wire [1:0] functionTypeA, functionTypeB;//function type for A and B pipeline (Arithmatic, Load/Store, Flow control (1,2,3. 0 invalid))
	wire [4:0] primOperandA, primOperandB;
	wire [15:0] secOperandA, secOperandB;
	wire pWriteA, pReadA, sReadA, pWriteB, pReadB, sReadB;
	wire decodeOEnableA, decodeOEnableB;
	
	
	///decode units
	Decode decodeUnit_A(.clock_i(clock_i), .enable_i(enableA_po), .flushBack_i(flushBack), .isBranch_i(isBranchA_po), 
	.instructionFormat_i(instructionAFormat_po), .opcode_i(opcodeA_po), .primOperand_i(primOperandA_po), .secOperand_i(secOperandA_po),
	/*.stall_i(isStalledFrontEnd),*/
	.opcode_o(opcodeA), .functionType_o(functionTypeA), .primOperand_o(primOperandA), .secOperand_o(secOperandA),
	.pWrite_o(pWriteA), .pRead_o(pReadA), .sRead_o(sReadA), .enable_o(decodeOEnableA));
	
	Decode decodeUnit_B(.clock_i(clock_i), .enable_i(enableB_po), .flushBack_i(flushBack), .isBranch_i(isBranchB_po), 
	.instructionFormat_i(instructionBFormat_po), .opcode_i(opcodeB_po), .primOperand_i(primOperandB_po), .secOperand_i(secOperandB_po),
	/*.stall_i(isStalledFrontEnd),*/
	.opcode_o(opcodeB), .functionType_o(functionTypeB), .primOperand_o(primOperandB), .secOperand_o(secOperandB),
	.pWrite_o(pWriteB), .pRead_o(pReadB), .sRead_o(sReadB), .enable_o(decodeOEnableB));
	
	//Reg read out - dispatch in
	wire enableExecA, enableExecB;//enables for the exec units
	wire isWbA, isWbB;//writeback flags
	wire [4:0] regAddrA, regAddrB;//register address to writeback to
	wire [6:0] opCodeExecA, opCodeExecB;
	wire [15:0] ApOperand, BpOperand;
	wire [15:0] AsOperand, BsOperand;
	wire [1:0] functionTypeA_dispatch, functionTypeB_dispatch;
	wire [1:0] operationStatusA_dispatch, operationStatusB_dispatch;
	
	
	//inputs to the reg file from the writeback FIFO
	wire writebackA, writebackB;
	wire [4:0] writebackAddrA, writebackAddrB;
	wire [15:0] writebackDataA, writebackDataB;
	wire [1:0] writebackStatusA, writebackStatusB;
	
	///register file
	RegController registers(
	//control hardware
	.clock_i(clock_i), .reset_i(reset_i), 
	
	//data in - from decode
	.enableA_i(decodeOEnableA), .enableB_i(decodeOEnableB),//enable from decode
	.pwriteA_i(pWriteA), .preadA_i(pReadA), .sreadA_i(sReadA), .pwriteB_i(pWriteB), .preadB_i(pReadB), .sreadB_i(sReadB),//register accesses
	.opcodeA_i(opcodeA), .opcodeB_i(opcodeB),
	.primOperandA_i(primOperandA), .primOperandB_i(primOperandB),
	.secOperandA_i(secOperandA), .secOperandB_i(secOperandB),
	.flushBack_i(flushBack),
	.functionTypeA_i(functionTypeA), .functionTypeB_i(functionTypeB),
	
	//data out - to reservation station
	.enableA_o(enableExecA), .enableB_o(enableExecB),
	.wbA_o(isWbA), .wbB_o(isWbB),
	.regAddrA_o(regAddrA), .regAddrB_o(regAddrB),
	.opCodeA_o(opCodeExecA), .opCodeB_o(opCodeExecB), 
	.primOperandA_o(ApOperand), .primOperandB_o(BpOperand),
	.secOperandA_o(AsOperand), .secOperandB_o(BsOperand),
	.functionTypeA_o(functionTypeA_dispatch), .functionTypeB_o(functionTypeB_dispatch),
	.operationStatusA_o(operationStatusA_dispatch), .operationStatusB_o(operationStatusB_dispatch),
	
	//reg writes in from the writeback FIFO
	.wbA_i(writebackA), .wbB_i(writebackB),
	.wbAddrA_i(writebackAddrA), .wbAddrB_i(writebackAddrB),
	.wbValA_i(writebackDataA), .wbVAlB_i(writebackDataB),
	.operationStatusA_i(writebackStatusA), .operationStatusB_i(writebackStatusB)
   );
	
	//Dispatch out - Arithmatic unit in
	wire arithmaticEnableA_arith, arithmaticEnableB_arith;
	wire isWbA_arith, isWbB_arith;
	wire [4:0] wbAddressA_arith, wbAddressB_arith;
	wire [6:0] opCodeA_arith, opCodeB_arith;
	wire [15:0] pOperandA_arith, sOperandA_arith, pOperandB_arith, sOperandB_arith;
	
	//Dispatch out - Branch unit in
	wire branchEnable;
	wire [1:0] opStat_branch;
	wire [6:0] opCode_branch;
	wire [15:0] pOperand_branch, sOperand_branch;
	
	//dispatch out - load store unit in
	wire loadStoreA, loadStoreB;
	wire isWbLSA, isWbLSB;
	wire [4:0] lsWbAddressA, lsWbAddressB;
	wire [6:0] lsOpCodeA, lsOpCodeB;
	wire [15:0]lsPoperandA, lsSoperandA, lsPoperandB, lsSoperandB;
	

	
	InstructionDispatch instructionDispatch(
	//inputs to the dispatch unit
	.clock_i(clock_i), .reset_i(reset_i),
	.isWbA_i(isWbA), .isWbB_i(isWbB), 
	.enableA_i(enableExecA), .enableB_i(enableExecB),
	.functionalTypeA_i(functionTypeA_dispatch), .functionalTypeB_i(functionTypeB_dispatch),
	.wbAddressA_i(regAddrA), .wbAddressB_i(regAddrB),
	.opCodeA_i(opCodeExecA), .opCodeB_i(opCodeExecB), 
	.pOperandA_i(ApOperand), .sOperandA_i(AsOperand), .pOperandB_i(BpOperand), .sOperandB_i(BsOperand), 
	.operationStatusA_i(operationStatusA_dispatch), .operationStatusB_i(operationStatusB_dispatch),

	.flushBack_i(flushBack),
	
	//outputs to the arithmatic units
	.arithmaticEnableA_o(arithmaticEnableA_arith), .arithmaticEnableB_o(arithmaticEnableB_arith),
	.isWbA_o(isWbA_arith), .isWbB_o(isWbB_arith),
	.wbAddressA_o(wbAddressA_arith), .wbAddressB_o(wbAddressB_arith), 
	.opCodeA_o(opCodeA_arith), .opCodeB_o(opCodeB_arith), 
	.pOperandA_o(pOperandA_arith), .sOperandA_o(sOperandA_arith), .pOperandB_o(pOperandB_arith), .sOperandB_o(sOperandB_arith),

	//outputs to the branch unit
	.branchEnable_o(branchEnable), 
	.opStat_branch_o(opStat_branch),
	.opCode_branch_o(opCode_branch), .pOperand_branch_o(pOperand_branch), .sOperand_branch_o(sOperand_branch),
	
	//output to the load store unit
	.isWbLSA_o(isWbLSA), .isWbLSB_o(isWbLSB), 
	.loadStoreA_o(loadStoreA), .loadStoreB_o(loadStoreB),
	.lsWbAddressA_o(lsWbAddressA), .lsWbAddressB_o(lsWbAddressB),
	.lsOpCodeA_o(lsOpCodeA), .lsOpCodeB_o(lsOpCodeB), 
	.lsPoperandA_o(lsPoperandA), .lsSoperandA_o(lsSoperandA), .lsPoperandB_o(lsPoperandB), .lsSoperandB_o(lsSoperandB)
	);
	

	
	///exec units
	//arithmatic unit out - reg write in
	wire wbAArith, wbBArith;
	wire [4:0] wbAddrAArithmatic, wbAddrBArithmatic;
	wire [15:0] wbValAArithmatic, wbValBArithmatic;
	wire [1:0] statusWritebackA, statusWritebackB;
	ArithmaticUnit ArithmaticA(
	//inputs
	.clock_i(clock_i), .isWb_i(isWbA_arith), .enable_i(arithmaticEnableA_arith), 
	.wbAddress_i(wbAddressA_arith), .opCode_i(opCodeA_arith),
	.pOperand_i(pOperandA_arith), .sOperand_i(sOperandA_arith),	
	//outputs
	.wbEnable_o(wbAArith), .wbAddress_o(wbAddrAArithmatic), .wbData_o(wbValAArithmatic),
	.statusWriteback_o(statusWritebackA)//bits 3 and 2 go to the arithmatic unit A
	);
	
	ArithmaticUnit ArithmaticB(
	//inputs
	.clock_i(clock_i), .isWb_i(isWbB_arith), .enable_i(arithmaticEnableB_arith), 
	.wbAddress_i(wbAddressB_arith), .opCode_i(opCodeB_arith),
	.pOperand_i(pOperandB_arith), .sOperand_i(sOperandB_arith),	
	//outputs
	.wbEnable_o(wbBArith), .wbAddress_o(wbAddrBArithmatic), .wbData_o(wbValBArithmatic),
	.statusWriteback_o(statusWritebackB)//bits 1 and 0 go to the arithmatic unit B
	);
	
	BranchUnit branchUnit(
	//inputs
	.clock_i(clock_i), .enable_i(branchEnable), .reset_i(reset_i),
	.opCode_i(opCode_branch), .pOperand_i(pOperand_branch), .sOperand_i(sOperand_branch), 
	.flushBack_i(flushBack), .flushBack_o(flushBack), .opStat_i(opStat_branch),
	//outputs to the fetch unit
	.shouldBranch_o(shouldBranch), .branchDirection_o(branchDirection), .branchOffset_o(branchOffset)
	);

	
	//load/store unit out - reg write in
	wire wbALoadStore, wbBLoadStore;
	wire [4:0] wbAddrALoadStore, wbAddrBLoadStore;
	wire [15:0] wbValALoadStore, wbValBLoadStore;
	

	//LoadStore loadStore(
	l1d_Cache l1d(
	//inputs
	.clock_i(clock_i), .isWbA_i(isWbLSA), .isWbB_i(isWbLSB), 
	.loadStoreA_i(loadStoreA), .loadStoreB_i(loadStoreB),
	.wbAddressA_i(lsWbAddressA), .wbAddressB_i(lsWbAddressB),
	.opCodeA_i(lsOpCodeA), .opCodeB_i(lsOpCodeB),
	.pOperandA_i(lsPoperandA), .sOperandA_i(lsSoperandA), .pOperandB_i(lsPoperandB), .sOperandB_i(lsSoperandB),
	
	//outputs
	.wbEnableA_o(wbALoadStore), .wbEnableB_o(wbBLoadStore),
	.wbAddressA_o(wbAddrALoadStore), .wbAddressB_o(wbAddrBLoadStore), 
	.wbDataA_o(wbValALoadStore), .wbDataB_o(wbValBLoadStore)
	);		
	
	
	WritebackFIFO writebackFifo(
	.clock_i(clock_i), .reset_i(reset_i),
	//input data from the Arithmatic units
	.ArithAEnable_i(wbAArith), .ArithBEnable_i(wbBArith),
	.ArithWriteAddressA_i(wbAddrAArithmatic), .ArithWriteAddressB_i(wbAddrBArithmatic),
	.ArithWriteDataA_i(wbValAArithmatic), .ArithWriteDataB_i(wbValBArithmatic),
	.ArithWriteStatusA_i(statusWritebackA), .ArithWriteStatusB_i(statusWritebackB),

	//input data from the store unit
	.StoreAEnable_i(wbALoadStore), .StoreBEnable_i(wbBLoadStore),
	.StoreAWriteAddress_i(wbAddrALoadStore), .StoreBWriteAddress_i(wbAddrBLoadStore),
	.StoreAWriteData_i(wbValALoadStore), .StoreBWriteData_i(wbValBLoadStore),

	//two output ports (two dequeues per cycle)
	.enableA_o(writebackA), .enableB_o(writebackB),
	.AddressA_o(writebackAddrA), .AddressB_o(writebackAddrB),
	.DataA_o(writebackDataA), .DataB_o(writebackDataB),
	.statusA_o(writebackStatusA), .statusB_o(writebackStatusB)
	);
	
	always@ (posedge clock_i)
	begin
			if(reset_i)
			begin
				$display("Resetting core");
				wbAArith_o <= 0;
				wbAddrAFinal_o <= 0;
				wbValAFinal_o <= 0;
				PC <= 0;
			end
			else
			begin
			
				PC_o <= PC;
				wbAArith_o <= wbAArith;// wbBFinal_o <= wbBFinal;
				wbAddrAFinal_o <= wbAddrAArithmatic;// wbAddrBFinal_o <= wbAddrBFinal;
				wbValAFinal_o <= wbValAArithmatic;// wbValBFinal_o <= wbValBFinal;
				
				if(shouldBranch)//if shoult branch
				begin
					case(branchDirection)
						0: begin PC <= PC - (branchOffset); end//has an aditional offset of 7 as this takes into acount the latency
						1: begin PC <= PC + (branchOffset); end
					endcase
				end
				else
					PC <= PC + nextByteOffset;//incremenet the PC by a quadword
			end
	end
	
	/*
	always@ (negedge clock_i)
	begin
	//debug writing out	
		if(!icacheWriteEnable)
		begin
			$display("\n");
			$display("Global processor state Registers; PC: %d, Reset: %b, fetched Bundle size:%d", PC,  reset_i, fetchedBundleSize);
			
			//fetch control
			$display("\nBranch: \nShould branch: %b, branch Offset: %d, branch direction: %b", shouldBranch, branchOffset, branchDirection);
			
			//fetch stage 1 debug
			$display("\nFetch1:\nFetched %b, Enable: %b", cacheline, fetch1enable);
			
			//fetch stage 2 debug
			$display("\nFetch1:\nBackDisable: %b, Next byte offset: %d", backDisable, nextByteOffset);
			$display("Instruction 1: %b (Format: %b), Instruction 2: %b (Format: %b)", InstructionA, InstructionAFormat, InstructionB, InstructionBFormat); 
			$display("Fetch 2 output enables A: %b, B: %b", fetchAEnableO, fetchBEnableO);
			
			//parse debug
			$display("\nParse:\nIs branch; A:%d, B:%d", isBranchA_po, isBranchB_po);
			$display("Format (0 = reg-reg, 1 = reg-imm); A:%d, B:%d", instructionAFormat_po, instructionBFormat_po);
			$display("Opcode; A:%d, B:%d", opcodeA_po, opcodeB_po);
			$display("Prim operand; A:%d, B:%d", primOperandA_po, primOperandB_po);
			$display("Secondary operand; A:%d, B:%d", secOperandA_po, secOperandB_po);
			$display("Output Enable; A:%b, B:%b", enableA_po, enableB_po);
			
			//Decode out - reg in
			$display("\nDecode:\nOpcode; A:%d, B:%d", opcodeA, opcodeB);
			$display("FunctionType; A:%d, B:%d", functionTypeA, functionTypeB);
			$display("Primary operand; A:%d, B:%d", primOperandA, primOperandB);
			$display("Second operand; A:%d, B:%d", secOperandA, secOperandB);
			$display("Reg accesses (pw,pr,sr); A:%d,%d,%d, B:%d,%d,%d", pWriteA, pReadA, sReadA, pWriteB, pReadB, sReadB);
			$display("Is secondary immediate (0) or reg(1); A:%b, B:%b", sReadA, sReadB);
			$display("Enables; A:%d, B:%d", decodeOEnableA, decodeOEnableB);
			
			//Reg read out - dispatch in
			$display("\nReg Read:\nEnable; A:%b, B:%b", enableExecA, enableExecB);
			$display("IsWriteback; A:%b B:%b", isWbA, isWbB);
			$display("Reg writeback Address; A:%d, B:%d", regAddrA, regAddrB);
			$display("Opcode; A:%d, B:%d", opCodeExecA, opCodeExecB);
			$display("PrimOperand; A:%d, B:%d", ApOperand, BpOperand);
			$display("SecOperand; A:%d, B:%d", AsOperand, BsOperand);
			$display("Function type; A:%d, B:%d", functionTypeA_dispatch, functionTypeB_dispatch);
			$display("Reg file overflow, underflow; A:%b,%b B:%b,%b",writebackStatusA[1], writebackStatusA[0], writebackStatusB[1], writebackStatusB[0]);

			
			//Dispatch out - Arithmatic in
			$display("\nArithmatic In:\nEnable A:%b B:%b", arithmaticEnableA_arith, arithmaticEnableB_arith);
			$display("IsWriteback; A:%b B:%b", isWbA_arith, isWbB_arith);
			$display("Opcode; A:%d, B:%d", opCodeA_arith, opCodeB_arith);
			$display("PrimOperand; A:%d, B:%d", pOperandA_arith, pOperandB_arith);
			$display("SecOperand; A:%d, B:%d", sOperandA_arith, sOperandB_arith);
			$display("WbAddress; A:%d, B:%d", wbAddressA_arith, wbAddressB_arith);

			//dispatch out - branch in
			$display("\nBranch in:\nenable: %b", branchEnable);
			$display("Opcode: %d", opCode_branch);
			$display("Jump Offset:%d", pOperand_branch);
			$display("Jump Condition:%d", sOperand_branch);
			
			//dispatch out - load/store in
			$display("\nLoadStore In:\nloadstore enableA: %d, loadstore enableB: %d", loadStoreA, loadStoreB);
			$display("is writeback for loadstore; A:%b, B:%b", isWbLSA, isWbLSB);
			$display("loadstore wriback address A:%d, B:%d", lsWbAddressA, lsWbAddressB);
			$display("loadstore opcode A:%d, B:%d", lsOpCodeA, lsOpCodeB);
			$display("load store operands(prim, sec) A:%d, %d B:%d, %d", lsPoperandA, lsSoperandA, lsPoperandB, lsSoperandB);
			
			//Arithmatic out - FIFO in
			$display("\nArithmatic out:\nwbEnable; A:%b, B:%b", wbAArith, wbBArith);
			$display("WbAddress; A:%d, B:%d", wbAddrAArithmatic, wbAddrBArithmatic);
			$display("WBData; A:%d, B:%d", wbValAArithmatic, wbValBArithmatic);
			//Store out - FIFO in
			$display("\nStore out:\nwbEnable; A:%b, B:%b", wbALoadStore, wbBLoadStore);
			$display("WbAddress; A:%d, B:%d", wbAddrALoadStore, wbAddrBLoadStore);
			$display("WBData; A:%d, B:%d", wbValALoadStore, wbValBLoadStore);
			$display("Is overflow; A:%b B:%b",statusWritebackA[1], statusWritebackB[1]);
			$display("Is underflow; A:%b, B:%b",statusWritebackA[0], statusWritebackB[0]);
			
			//FIFO OUT - writeback in
			$display("\nFIFO out:\nWriteback data; A:%d, B:%d", writebackA, writebackB);
			$display("WritebackAddres; A:%d, B:%d", writebackAddrA, writebackAddrB);
			$display("WritebackData; A:%d, B:%d", writebackDataA, writebackDataB);
			$display("WritebackStatus; A:%d, B:%d", writebackStatusA,writebackStatusB);
			
			$display("\n");	
		end
		else
		begin
			$display("Instruion cache writing: ");
			$display("Address: %d", writeAddress);
			$display("Instruction: %b", cachelineWrite);
		end
	end
	
	*/
endmodule
