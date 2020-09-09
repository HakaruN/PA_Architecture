`timescale 1ns / 1ps
`default_nettype none
module RegisterFile(
	input wire clock_i,
	input wire reset_i,
	
	input wire [5:0] bankSelect_i,//this allows for a bank to be selected and it offsets the read/writes into a different group of 32 registers

	//reg writes from arithmatic writebacks
	input wire writeEnablePortA_i, writeEnablePortB_i,//write enables for port A and B	
	input wire [4:0] writeAPortAddr_i, writeBPortAddr_i,//port address lines for writing to registers
	input wire [15:0] writeAPortData_i, writeBPortData_i,//port data lines for writing to registers
	input wire [1:0] operationStatusA_i,operationStatusB_i,
	
	//reg writes from store unit
	input wire wbALoadStore_i, wbBLoadStore_i,//write enables for port A and B	
	input wire [4:0] wbAAddrLS_i, wbBAddrLS_i,//port address lines for writing to registers
	input wire [15:0] wbADatLS_i, wbBDatLS_i,//port data lines for writing to registers
	
	//reg write  from reg assignment 
	input wire assignEnableA_i, assignEnableB_i,//enable
	input wire [4:0] assignAddrA_i, assignAddrB_i,//write address
	input wire [15:0] assignDatA_i, assignDatB_i,//secondary value (could be reg address or immediate val)
	input wire isSecReadA_i, isSecReadB_i,//is the secondary value resolved from reading the reg[secondary] or is it an immediate
	
	
	//dispatch reads from execution units
	input wire readAPrimary_i, readBPrimary_i,//read enables for read-bus 1
	input wire readASecondary_i, readBSecondary_i,//read enables for read-bus 2
	input wire [4:0] readAPortAddr1_i, readBPortAddr1_i,//read address for bus 1
	output reg [15:0] readAPortData1_o, readBPortData1_o,//return data on bus 1
	input wire [15:0] readAPortAddr2_i, readBPortAddr2_i,//read address for bus 2
	output reg [15:0] readAPortData2_o, readBPortData2_o,//return data on bus 2
	output reg [1:0] operationStatusA_o, operationStatusB_o
    );

parameter NUM_REGISTERS_PER_BANK = 28;
parameter NUM_REG_BANKS = 2;

reg [15:0] regFile [(NUM_REGISTERS_PER_BANK * NUM_REG_BANKS)-1:0];//512 16bit registers, each register window has 32 registers so we can have 10 stack frames/processes/programs with registers allocated at once
reg [1:0] statusRegisterA;//bits 1 pipe-A overflow, bit 0 underflow.
reg [1:0] statusRegisterB;//bits 1 pipe-B overflow, bit 0 underflow.

integer i;
	always @(posedge clock_i)
	begin		
		if(reset_i)
		begin
			//$display("Reg reset");
			for(i = 0; i < NUM_REGISTERS_PER_BANK * NUM_REG_BANKS; i = i + 1)
			begin
				//regFile[i] <= 16'd0;//when reset, all of the registers are to be reset to a value of zero
				regFile[i] <= 0;
			end
			statusRegisterA[0] <= 0;
			statusRegisterA[1] <= 0;
			statusRegisterB[0] <= 0;
			statusRegisterB[1] <= 0;
		end

		
		//reg assignments
		//port A
		if(isSecReadA_i == 1 && assignEnableA_i == 1)//if secondary is to be read, reg-reg assignment
		begin
			regFile[(bankSelect_i * NUM_REGISTERS_PER_BANK) + assignAddrA_i] <= regFile[(bankSelect_i * NUM_REGISTERS_PER_BANK) + assignDatA_i];
		end
		else if(isSecReadA_i == 0 && assignEnableA_i == 1)//if secondary is not to be read, reg-imm assignment
		begin
			regFile[(bankSelect_i * NUM_REGISTERS_PER_BANK) + assignAddrA_i] <= assignDatA_i;
		end
		//port B
		if(isSecReadB_i == 1 && assignEnableB_i == 1)//if secondary is to be read, reg-reg assignment
		begin
			regFile[(bankSelect_i * NUM_REGISTERS_PER_BANK) + assignAddrB_i] <= regFile[(bankSelect_i * NUM_REGISTERS_PER_BANK) + assignDatB_i];
		end
		else if(isSecReadB_i == 0 && assignEnableB_i == 1)//if secondary is not to be read, reg-imm assignment
		begin
			regFile[(bankSelect_i * NUM_REGISTERS_PER_BANK) + assignAddrB_i] <= assignDatB_i;
		end

		
		
		
		
		//port A
		//reads - if the read is enabled then a reg read is performed and the read value is put onto the data bus,
		//if however enable is false then whats on the address bus is assumed to be an immediate value and not address so its writen to the data bus
		if(readAPrimary_i)//if read is enabled, the output becomes the data at the reg address
		begin
			operationStatusA_o <= statusRegisterA;
			readAPortData1_o <= regFile[(bankSelect_i * NUM_REGISTERS_PER_BANK) + readAPortAddr1_i];
		end
		else//if read is disabled, then whats on the bus must be a immediate value so the output just buffers through the immediate 
		begin
			readAPortData1_o <= readAPortAddr1_i;
		end
			
		if(readASecondary_i)
			readAPortData2_o <= regFile[(bankSelect_i * NUM_REGISTERS_PER_BANK) + readAPortAddr2_i];
		else
			readAPortData2_o <= readAPortAddr2_i;			
		
		//port B
		if(readBPrimary_i)
		begin
			operationStatusB_o <= statusRegisterB;
			readBPortData1_o <= regFile[(bankSelect_i * NUM_REGISTERS_PER_BANK) + readBPortAddr1_i];
		end
		else	
			readBPortData1_o <= readBPortAddr1_i;	

		if(readBSecondary_i)
			readBPortData2_o <= regFile[(bankSelect_i * NUM_REGISTERS_PER_BANK) + readBPortAddr2_i];
		else 
			readBPortData2_o <= readBPortAddr2_i;	
		
		//write - reg writeback
		//port A
		if(writeEnablePortA_i)
		begin
			 regFile[(bankSelect_i * NUM_REGISTERS_PER_BANK) + writeAPortAddr_i] <= writeAPortData_i;
			 statusRegisterA <= operationStatusA_i;
		end
		//port B
		if(writeEnablePortB_i)
		begin
			regFile[(bankSelect_i * NUM_REGISTERS_PER_BANK) + writeBPortAddr_i] <= writeBPortData_i;
			statusRegisterB <= operationStatusB_i;
		end	
		
		
		//write - store unit
		if(wbALoadStore_i)
		begin
			regFile[(bankSelect_i * NUM_REGISTERS_PER_BANK) + wbAAddrLS_i] <= wbADatLS_i;
		end
		if(wbBLoadStore_i)
		begin
			regFile[(bankSelect_i * NUM_REGISTERS_PER_BANK) + wbBAddrLS_i] <= wbBDatLS_i;
		end		
	end
endmodule
