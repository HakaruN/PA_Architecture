`timescale 1ns / 1ps
`default_nettype none

module registerFile(
	input wire clock_i, reset_i, 	
	input wire [5:0] bankSelect_i,//this allows for a bank to be selected and it offsets the read/writes into a different group of 32 registers
	//generic writes are to load/store and arithmatic

	//port writes (Arithmatic & loadstore)
	input wire portAWriteEnable_i, portBWriteEnable_i,
	input wire [4:0] portAWriteAddress_i, portBWriteAddress_i,
	input wire [15:0] portAWriteData_i, portBWriteData_i,	
	
	//port reads (Functional units) - prim regs
	input wire portAReadPrimEnable_i, portBReadPrimEnable_i,//read enables for primary regs
	input wire [4:0] portAReadPrimAddr_i, portBReadPrimAddr_i,//read address for primary regs
	output reg [15:0] portAReadPrimOutput_o, portBReadPrimOutput_o,//output bus for primary reg
	
	//port reads Functional units) - prim regs
	input wire portASecRead_i, portBSecRead_i,//if the secondary data is to be interpereted as a reg address or a immediate value
	input wire portAReadSecEnable_i, portBReadSecEnable_i,//read enables for primary regs
	input wire [15:0] portAReadSecAddr_i, portBReadSecAddr_i,//read address for secondary regs, or could be the secondary value and not an addr
	output reg [15:0] portAReadSecOutput_o, portBReadSecOutput_o,//output bus for primary reg
	
	//port writes (register assignment)
	input wire portASecReadAssign_i, portBSecReadAssign_i,
	input wire regAssignAEnable_i, regAssignBEnable_i,
	input wire [4:0] regAssignAAddress_i, regAssignBAddress_i,
	input wire [15:0] regAssignAData_i, regAssignBData_i//,	
    );

parameter NUM_REGISTERS_PER_BANK = 16, NUM_REG_BANKS = 2;
reg [15:0] regFile [(NUM_REGISTERS_PER_BANK * NUM_REG_BANKS)-1:0];//512 16bit registers, each register window has 32 registers so we can have 10 stack frames/processes/programs with registers allocated at once
integer i;

always @(posedge clock_i)//generic access port A
begin
	
	//on reset, the reg file goes to zero
	if(reset_i == 1)
		for(i = 0; i < NUM_REGISTERS_PER_BANK * NUM_REG_BANKS; i = i + 1)
				regFile[i] <= 0;

	if(portAWriteEnable_i)//Port A write (primary)
		regFile[portAWriteAddress_i + (bankSelect_i * NUM_REGISTERS_PER_BANK)] <= portAWriteData_i;	

	if(portAReadPrimEnable_i)//Port A read (prim regs)
		portAReadPrimOutput_o <= regFile[portAReadPrimAddr_i + (bankSelect_i * NUM_REGISTERS_PER_BANK)];

	if(portAReadSecEnable_i && portASecRead_i)//Port A read (secondary)
		portAReadSecOutput_o <= regFile[portAReadSecAddr_i + (bankSelect_i * NUM_REGISTERS_PER_BANK)];
	else if(portAReadSecEnable_i && (portASecRead_i == 0))
		portAReadSecOutput_o <= portAReadSecAddr_i;
	
	if(regAssignAEnable_i)//Port A assign
		if(portASecReadAssign_i)//if the secondary is a read, its a reg address		
			regFile[regAssignAAddress_i + (bankSelect_i * NUM_REGISTERS_PER_BANK)] <= regFile[regAssignAData_i + (bankSelect_i * NUM_REGISTERS_PER_BANK)];
		else
			regFile[regAssignAAddress_i + (bankSelect_i * NUM_REGISTERS_PER_BANK)] <= regAssignAData_i;
		
		
		
	if(portBWriteEnable_i)//Port B write (primary)
		regFile[portBWriteAddress_i + (bankSelect_i * NUM_REGISTERS_PER_BANK)] <= portBWriteData_i;
		
	if(portBReadPrimEnable_i)//Port B read (prim regs)
		portBReadPrimOutput_o <= regFile[portBReadPrimAddr_i + (bankSelect_i * NUM_REGISTERS_PER_BANK)];
	
	if(portBReadSecEnable_i && portBSecRead_i)//Port B read (secondary)
		portBReadSecOutput_o <= regFile[portBReadSecAddr_i + (bankSelect_i * NUM_REGISTERS_PER_BANK)];
	else if(portBReadSecEnable_i && (portBSecRead_i == 0))
		portBReadSecOutput_o <= portBReadSecAddr_i;	
		
	if(regAssignBEnable_i)//Port B assign
		if(portBSecReadAssign_i)//if the secondary is a read, its a reg address		
			regFile[regAssignBAddress_i + (bankSelect_i * NUM_REGISTERS_PER_BANK)] <= regFile[regAssignBData_i + (bankSelect_i * NUM_REGISTERS_PER_BANK)];
		else
			regFile[regAssignBAddress_i + (bankSelect_i * NUM_REGISTERS_PER_BANK)] <= regAssignBData_i;
			
end
endmodule
