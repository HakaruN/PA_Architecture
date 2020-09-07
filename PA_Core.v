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
module PA_Core(input wire clock_i,
		input wire reset_i,
		output reg wbAArith_o,
		output reg [4:0] wbAddrAFinal_o,
		output reg [15:0] wbValAFinal_o
    );	
	//i-cache output - fetch input
	wire [15:0] pc;
	wire [5:0] bankSelect;//what bank of registers to use (hardcoded to 0 for now)
	wire [59:0] fetchBuffer;//the buffer where fetched instructions are written to
	wire fetchEnable;//output enable from the fetch unit
	
	
	
	Fetch fetch(.clock_i(clock_i), .reset_i(reset_i), .PC(pc) , .data_o(fetchBuffer), .enable_o(fetchEnable));

	//parse out - decode in
	wire isBranch_1, isBranch_2;
	wire instructionFormat_1, instructionFormat_2;
	wire [6:0] opCode_1, opCode_2;
	wire [4:0] primReg_1, primReg_2;
	wire [15:0] operand_1, operand_2;
	
	wire decode1Enabled_1, decode1Enabled_2;

	
	//first stage of the decode unit (more accuratly a parser, it parses 2 instructions per cycle)
	Parser parseUnit(.clock_i(clock_i), .enable_i(fetchEnable), .instruction_i(fetchBuffer),
	.isBranch_o1(isBranch_1), .isBranch_o2(isBranch_2),
	.instructionFormat_o1(instructionFormat_1), .instructionFormat_o2(instructionFormat_2),
	.opcode_o1(opCode_1), .opcode_o2(opCode_2),
	.reg_o1(primReg_1), .reg_o2(primReg_2), 
	.operand_o1(operand_1), .operand_o2(operand_2), 
	.enable_o1(decode1Enabled_1), .enable_o2(decode1Enabled_2));
	
	//Decode out - Reg reg in
	wire [6:0] opcodeA, opcodeB;
	wire [1:0] functionTypeA, functionTypeB;//function type for A and B pipeline (Arithmatic, Load/Store, Flow control (1,2,3. 0 invalid))
	wire [4:0] primOperandA, primOperandB;
	wire [15:0] secOperandA, secOperandB;
	wire pWriteA, pReadA, sReadA, pWriteB, pReadB, sReadB;
	wire decodeOEnableA, decodeOEnableB;
	
	///decode units
	Decode decodeUnit_1(.clock_i(clock_i), .enable_i(decode1Enabled_1), .isBranch_i(isBranch_1), 
	.instructionFormat_i(instructionFormat_1), .opcode_i(opCode_1), .primOperand_i(primReg_1), .secOperand_i(operand_1),
	.opcode_o(opcodeA), .functionType_o(functionTypeA), .primOperand_o(primOperandA), .secOperand_o(secOperandA),
	.pWrite_o(pWriteA), .pRead_o(pReadA), .sRead_o(sReadA), .enable_o(decodeOEnableA));
	
	Decode decodeUnit_2(.clock_i(clock_i), .enable_i(decode1Enabled_2), .isBranch_i(isBranch_2), 
	.instructionFormat_i(instructionFormat_2), .opcode_i(opCode_2), .primOperand_i(primReg_2), .secOperand_i(operand_2),
	.opcode_o(opcodeB), .functionType_o(functionTypeB), .primOperand_o(primOperandB), .secOperand_o(secOperandB),
	.pWrite_o(pWriteB), .pRead_o(pReadB), .sRead_o(sReadB), .enable_o(decodeOEnableB));
	
	//Reg read out- exec unit in
	wire enableExecA, enableExecB;//enables for the exec units
	wire isWbA, isWbB;//writeback flags
	wire [4:0] regAddrA, regAddrB;//register address to writeback to
	wire [6:0] opCodeExecA, opCodeExecB;
	wire [15:0] ApOperand, BpOperand;
	wire [15:0] AsOperand, BsOperand;
	wire [1:0] functionTypeA_exec, functionTypeB_exec;
	
	
	//arithmatic unit out - reg write in
	wire wbAArith, wbBArith;
	wire [4:0] wbAddrAArithmatic, wbAddrBArithmatic;
	wire [15:0] wbValAArithmatic, wbValBArithmatic;
	
	//load/store unit out - reg write in
	wire wbALoadStore, wbBLoadStore;
	wire [4:0] wbAddrALoadStore, wbAddrBLoadStore;
	wire [15:0] wbValALoadStore, wbValBLoadStore;
	
	///register file
	RegController registers(
	//control hardware
	.clock_i(clock_i), .reset_i(reset_i), 
	//bank select
	.bankSelect_i(bankSelect),
	
	//data in - from decode
	.enableA_i(decodeOEnableA), .enableB_i(decodeOEnableB),//enable from decode
	.pwriteA_i(pWriteA), .preadA_i(pReadA), .sreadA_i(sReadA), .pwriteB_i(pWriteB), .preadB_i(pReadB), .sreadB_i(sReadB),//register accesses
	.opcodeA_i(opcodeA), .opcodeB_i(opcodeB),
	.primOperandA_i(primOperandA), .primOperandB_i(primOperandB),
	.secOperandA_i(secOperandA), .secOperandB_i(secOperandB),
	.functionTypeA_i(functionTypeA), .functionTypeB_i(functionTypeB),
	
	//data out - to reservation station
	.enableA_o(enableExecA), .enableB_o(enableExecB),
	.wbA_o(isWbA), .wbB_o(isWbB),
	.regAddrA_o(regAddrA), .regAddrB_o(regAddrB),
	.opCodeA_o(opCodeExecA), .opCodeB_o(opCodeExecB), 
	.primOperandA_o(ApOperand), .primOperandB_o(BpOperand),
	.secOperandA_o(AsOperand), .secOperandB_o(BsOperand),
	.functionTypeA_o(functionTypeA_exec), .functionTypeB_o(functionTypeB_exec),
	
	//inputs to register writeback from arithmatic
	.wbA_arith_i(wbAArith), .wbB_arith_i(wbBArith),
	.wbAddrA_arith_i(wbAddrAArithmatic), .wbAddrB_arith_i(wbAddrBArithmatic),
	.wbValA_arith_i(wbValAArithmatic), .wbVAlB_arith_i(wbValBArithmatic),
	
	//inputs to register writeback from loadStore unit	
	.wbA_ls_i(wbALoadStore), .wbB_ls_i(wbBLoadStore),
	.wbAddrA_ls_i(wbAddrALoadStore), .wbAddrB_ls_i(wbAddrBLoadStore),
	.wbValA_ls_i(wbValALoadStore), .bwVAlB_ls_i(wbValBLoadStore)
   );
	
	//Dispatch out - Arithmatic unit in
	wire arithmaticEnableA_arith, arithmaticEnableB_arith;
	wire isWbA_arith, isWbB_arith;
	wire [4:0] wbAddressA_arith, wbAddressB_arith;
	wire [6:0] opCodeA_arith, opCodeB_arith;
	wire [15:0] pOperandA_arith, sOperandA_arith, pOperandB_arith, sOperandB_arith;
	
	//Dispatch out - Branch unit in
	wire branchEnable;
	wire [6:0] opCode_branch;
	wire [15:0] pOperand_branch, sOperand_branch;
	
	//dispatch out - reg frame unit in
	wire enable_regFrame;
	wire [6:0] opCode_regFrame;
	
	//dispatch out - load store unit in
	wire loadEnable, storeEnable;
	wire isWbLSA, isWbLSB, lsEnableA, lsEnableB;
	wire [4:0] lsWbAddressA, lsWbAddressB;
	wire [6:0] lsOpCodeA, lsOpCodeB;
	wire [15:0]lsPoperandA, lsSoperandA, lsPoperandB, lsSoperandB;
	

	
	InstructionDispatch instructionDispatch(
	//inputs to the dispatch unit
	.clock_i(clock_i), .reset_i(reset_i),
	.isWbA_i(isWbA), .isWbB_i(isWbB), 
	.enableA_i(enableExecA), .enableB_i(enableExecB),
	.functionalTypeA_i(functionTypeA_exec), .functionalTypeB_i(functionTypeB_exec),
	.wbAddressA_i(regAddrA), .wbAddressB_i(regAddrB),
	.opCodeA_i(opCodeExecA), .opCodeB_i(opCodeExecB), 
	.pOperandA_i(ApOperand), .sOperandA_i(AsOperand), .pOperandB_i(BpOperand), .sOperandB_i(BsOperand), 
		
	
	//outputs to the arithmatic units
	.arithmaticEnableA_o(arithmaticEnableA_arith), .arithmaticEnableB_o(arithmaticEnableB_arith),
	.isWbA_o(isWbA_arith), .isWbB_o(isWbB_arith),
	.wbAddressA_o(wbAddressA_arith), .wbAddressB_o(wbAddressB_arith), 
	.opCodeA_o(opCodeA_arith), .opCodeB_o(opCodeB_arith), 
	.pOperandA_o(pOperandA_arith), .sOperandA_o(sOperandA_arith), .pOperandB_o(pOperandB_arith), .sOperandB_o(sOperandB_arith),

	//outputs to the branch unit
	.branchEnable_o(branchEnable), 
	.opCode_branch_o(opCode_branch), .pOperand_branch_o(pOperand_branch), .sOperand_branch_o(sOperand_branch),
	
	//outputs to the reg frame unit	
	.regEnable_regUnit_o(enable_regFrame),	.opCode_regUnit_o(opCode_regFrame),
	
	//output to the load store unit
	.loadEnable_o(loadEnable), .storeEnable_o(storeEnable),
	.isWbLSA_o(isWbLSA), .isWbLSB_o(isWbLSB), .lsEnableA_o(lsEnableA), .lsEnableB_o(lsEnableB),
	.lsWbAddressA_o(lsWbAddressA), .lsWbAddressB_o(lsWbAddressB),
	.lsOpCodeA_o(lsOpCodeA), .lsOpCodeB_o(lsOpCodeB), 
	.lsPoperandA_o(lsPoperandA), .lsSoperandA_o(lsSoperandA), .lsPoperandB_o(lsPoperandB), .lsSoperandB_o(lsSoperandB)
	);
	
	///exec units
	ArithmaticUnit ArithmaticA(
	//inputs
	.clock_i(clock_i), .isWb_i(isWbA_arith), .enable_i(arithmaticEnableA_arith), 
	.wbAddress_i(wbAddressA_arith), .opCode_i(opCodeA_arith),
	.pOperand_i(pOperandA_arith), .sOperand_i(sOperandA_arith),	
	//outputs
	.wbEnable_o(wbAArith), .wbAddress_o(wbAddrAArithmatic), .wbData_o(wbValAArithmatic)
	);
	
	ArithmaticUnit ArithmaticB(
	//inputs
	.clock_i(clock_i), .isWb_i(isWbB_arith), .enable_i(arithmaticEnableB_arith), 
	.wbAddress_i(wbAddressB_arith), .opCode_i(opCodeB_arith),
	.pOperand_i(pOperandB_arith), .sOperand_i(sOperandB_arith),	
	//outputs
	.wbEnable_o(wbBArith), .wbAddress_o(wbAddrBArithmatic), .wbData_o(wbValBArithmatic)
	);
	
	BranchUnit branchUnit(
	//inputs
	.clock_i(clock_i), .enable_i(branchEnable), .reset_i(reset_i), 
	.opCode_i(opCode_branch), .pOperand_i(pOperand_branch), .sOperand_i(sOperand_branch),
	.pc_i(pc), 
	//outputs
	.pc_o(pc)
	);
	
	RegisterFrameUnit regFrameUnit(
	.clock_i(clock_i), .enable_i(enable_regFrame), .reset_i(reset_i),
	.opCode_i(opCode_regFrame), .regBankSelect_o(bankSelect)
	);
	
	LoadStore loadStore(
	//inputs
	.clock_i(clock_i), .isWbA_i(isWbLSA), .isWbB_i(isWbLSB), 
	.loadEnable_i(loadEnable), .storeEnable_i(storeEnable), .enableA_i(lsEnableA), .enableB_i(lsEnableB),
	.wbAddressA_i(lsWbAddressA), .wbAddressB_i(lsWbAddressB),
	.opCodeA_i(lsOpCodeA), .opCodeB_i(lsOpCodeB),
	.pOperandA_i(lsPoperandA), .sOperandA_i(lsSoperandA), .pOperandB_i(lsPoperandB), .sOperandB_i(lsSoperandB),
	
	//outputs
	.wbEnableA_o(wbALoadStore), .wbEnableB_o(wbBLoadStore),
	.wbAddressA_o(wbAddrALoadStore), .wbAddressB_o(wbAddrBLoadStore), 
	.wbDataA_o(wbValALoadStore), .wbDataB_o(wbValBLoadStore)
	);		

	always@ (posedge clock_i)
	begin
			wbAArith_o <= wbAArith;// wbBFinal_o <= wbBFinal;
			wbAddrAFinal_o <= wbAddrAArithmatic;// wbAddrBFinal_o <= wbAddrBFinal;
			wbValAFinal_o <= wbValAArithmatic;// wbValBFinal_o <= wbValBFinal;
	end
	
	
	always@ (negedge clock_i)
	begin
	//debug writing out
	
	$display("\n");
	$display("Global processor state Registers; PC: %d, RegisterBank: %d, Reset: %b", pc, bankSelect, reset_i);
	/*
	//fetch debug
	$display("\nFetch:\nFetched %b, Enable: %b", fetchBuffer, fetchEnable);
	
	//parse debug
	$display("\nParse:\nIs branch; A:%d, B:%d", isBranch_1, isBranch_2);
	$display("Format; A:%d, B:%d", instructionFormat_1, instructionFormat_2);
	$display("Opcode; A:%d, B:%d", opCode_1, opCode_2);
	$display("Reg; A:%d, B:%d", primReg_1, primReg_2);
	$display("Operand; A:%d, B:%d", operand_1, operand_2);
	$display("Enable; A:%b, B:%b", decode1Enabled_1, decode1Enabled_2);
	
	//Decode debug
	$display("\nDecode:\nOpcode; A:%d, B:%d", opcodeA, opcodeB);
	$display("FunctionType; A:%d, B:%d", functionTypeA, functionTypeB);
	$display("Primary operand; A:%d, B:%d", primOperandA, primOperandB);
	$display("Second operand; A:%d, B:%d", secOperandA, secOperandB);
	$display("Reg accesses (pw,pr,sr); A:%d,%d,%d, B:%d,%d,%d", pWriteA, pReadA, sReadA, pWriteB, pReadB, sReadB);
	$display("Enables; A:%d, B:%d", decodeOEnableA, decodeOEnableB);
	
	//Reg read
	$display("\nReg Read:\nEnable; A:%b, B:%b", enableExecA, enableExecB);
	$display("IsWriteback; A:%b B:%b", isWbA, isWbB);
	$display("Is secondary immediate (0) or reg(1); A:%b, B:%b", sReadA, sReadB);
	$display("Reg writeback Address; A:%d, B:%d", regAddrA, regAddrB);
	$display("Opcode; A:%d, B:%d", opCodeExecA, opCodeExecB);
	$display("PrimOperand; A:%d, B:%d", ApOperand, BpOperand);
	$display("SecOperand; A:%d, B:%d", AsOperand, BsOperand);
	$display("Function type; A:%d, B:%d", functionTypeA_exec, functionTypeB_exec);

	
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
	
	//dispatch out - reg frame in
	$display("\nRegframe In:\nenable: %b", enable_regFrame);
	$display("opcode: %d", opCode_regFrame);
	
	//dispatch out - load/store in
	$display("\nLoadStore In:\nload enable: %d, store enable: %d", loadEnable, storeEnable);
	$display("is writeback for loadstore; A:%b, B:%b", isWbLSA, isWbLSB);
	$display("is loadstore pipe A and B enabled: %b, %b", lsEnableA, lsEnableB);
	$display("loadstore wriback address A:%d, B:%d", lsWbAddressA, lsWbAddressB);
	$display("loadstore opcode A:%d, B:%d", lsOpCodeA, lsOpCodeB);
	$display("load store operands(prim, sec) A:%d, %d B:%d, %d", lsPoperandA, lsSoperandA, lsPoperandB, lsSoperandB);
	
	//reg writeback - Arithmatic
	$display("\nReg write(arithmatic):\nwbEnable; A:%b, B:%b", wbAArith, wbBArith);
	$display("WbAddress; A:%d, B:%d", wbAddrAArithmatic, wbAddrBArithmatic);
	$display("WBData; A:%d, B:%d", wbValAArithmatic, wbValBArithmatic);
	//reg writeback - Store
	$display("\nReg write (store):\nwbEnable; A:%b, B:%b", wbALoadStore, wbBLoadStore);
	$display("WbAddress; A:%d, B:%d", wbAddrALoadStore, wbAddrBLoadStore);
	$display("WBData; A:%d, B:%d", wbValALoadStore, wbValBLoadStore);
	*/
	$display("\n");	
	end
	
	
endmodule
