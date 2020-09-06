`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:08:00 09/06/2020 
// Design Name: 
// Module Name:    PA_Core 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
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
		output reg wbAFinal_o,
		output reg [4:0] wbAddrAFinal_o,
		output reg [15:0] wbValAFinal_o
    );	
	//i-cache output - fetch input
	reg [15:0] pc;
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
	
	
	//exec unit out - reg write in
	wire wbAFinal, wbBFinal;
	wire [4:0] wbAddrAFinal, wbAddrBFinal;
	wire [15:0] wbValAFinal, wbValBFinal;
	
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
	//data out - to exec units
	.enableA_o(enableExecA), .enableB_o(enableExecB),
	.wbA_o(isWbA), .wbB_o(isWbB),
	.regAddrA_o(regAddrA), .regAddrB_o(regAddrB),
	.opCodeA_o(opCodeExecA), .opCodeB_o(opCodeExecB), 
	.primOperandA_o(ApOperand), .primOperandB_o(BpOperand),
	.secOperandA_o(AsOperand), .secOperandB_o(BsOperand),
	
	//inputs to register writeback
	.wbA_i(wbAFinal), .wbB_i(wbBFinal),
	.wbAddrA_i(wbAddrAFinal), .wbAddrB_i(wbAddrBFinal),
	.wbValA_i(wbValAFinal), .bwVAlB_i(wbValBFinal)
   );
	
	///exec units
	ExecUnit ExecUnitA(
	//inputs to exec unit
	.clock_i(clock_i), .isWb_i(isWbA), .enable_i(enableExecA), .reset_i(reset_i),//control
	.wbAddress_i(regAddrA), .opCode_i(opCodeExecA),//metadata
	.pOperand_i(ApOperand), .sOperand_i(AsOperand),//data
	.regBankSelect_i(bankSelect),
	
	//outputs
	.wbEnable_o(wbAFinal), .wbAddress_o(wbAddrAFinal), .wbData_o(wbValAFinal),
	.regBankSelect_o(bankSelect)
	);
	
	ExecUnit ExecUnitB(
	//inputs to exec unit
	.clock_i(clock_i), .isWb_i(isWbB), .enable_i(enableExecB), .reset_i(reset_i),//control
	.wbAddress_i(regAddrB), .opCode_i(opCodeExecB),//metadata
	.pOperand_i(BpOperand), .sOperand_i(BsOperand),//data
	.regBankSelect_i(bankSelect),
	
	//outputs
	.wbEnable_o(wbBFinal), .wbAddress_o(wbAddrBFinal), .wbData_o(wbValBFinal)
	//.regBankSelect_o(bankSelect)
	);
	
	
	always@ (posedge clock_i)
	begin
		if(reset_i == 1)
			begin
			//$display("Resetting core");
			pc <= 0;
			end
		else
		begin
			//$display("\n");
			pc <= pc + 1;
			wbAFinal_o <= wbAFinal;// wbBFinal_o <= wbBFinal;
			wbAddrAFinal_o <= wbAddrAFinal;// wbAddrBFinal_o <= wbAddrBFinal;
			wbValAFinal_o <= wbValAFinal;// wbValBFinal_o <= wbValBFinal;
			
		
		end
	end
	
	/*
	always@ (negedge clock_i)
	begin
	//debug writing out
	$display("\n");
	$display("Global processor state Registers; PC: %d, RegisterBank: %d, Reset: %b", pc, bankSelect, reset_i);
	
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
	$display("Reg accesses (pr,pw,sr); A:%d,%d,%d, B:%d,%d,%d", pWriteA, pReadA, sReadA, pWriteB, pReadB, sReadB);
	$display("Enables; A:%d, B:%d", decodeOEnableA, decodeOEnableB);
	
	//Reg read
	$display("\nReg Read:\nEnable; A:%b, B:%b", enableExecA, enableExecB);
	$display("IsWriteback; A:%b B:%b", isWbA, isWbB);
	$display("Is secondary immediate (0) or reg(1); A:%b, B:%b", sreadA, sreadB);
	$display("Reg writeback Address; A:%d, B:%d", regAddrA, regAddrB);
	$display("Opcode; A:%d, B:%d", opCodeExecA, opCodeExecB);
	$display("PrimOperand; A:%d, B:%d", ApOperand, BpOperand);
	$display("SecOperand; A:%d, B:%d", AsOperand, BsOperand);

	//reg writeback
	$display("\nReg write:\nwbEnable; A:%b, B:%b", wbAFinal, wbBFinal);
	$display("WbAddress; A:%d, B:%d", wbAddrAFinal, wbAddrBFinal);
	$display("WBData; A:%d, B:%d", wbValAFinal, wbValBFinal);
	$display("\n");

	
	end
	*/
	
endmodule
