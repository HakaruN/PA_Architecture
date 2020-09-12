`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:19:09 09/11/2020 
// Design Name: 
// Module Name:    l1d_Cache 
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
module l1d_Cache(
	input wire clock_i, isWbA_i, isWbB_i, 
	input wire loadStoreA_i, loadStoreB_i,
	input wire [4:0] wbAddressA_i, wbAddressB_i,
	input wire [6:0] opCodeA_i, opCodeB_i,
	input wire [15:0] pOperandA_i, sOperandA_i, pOperandB_i, sOperandB_i,
		
	output reg wbEnableA_o, wbEnableB_o,
	output reg [4:0] wbAddressA_o, wbAddressB_o, 
	output reg [15:0] wbDataA_o, wbDataB_o
    );
	 
	 //data cache
	 parameter numCachelines = 10000; parameter cachlinewidth = 16; parameter sizeOfAByte = 8;
	 //reg [(cachlinewidth * sizeOfAByte) - 1:0] dCache [numCachelines -1 :0];//128 entry i-cache where each cacheline is 50 bits wide (1 instruction)
	 reg [15:0] dCache [numCachelines -1 :0];//128 entry i-cache where each cacheline is 50 bits wide (1 instruction)

	//input buffers
	reg loadStoreEnableA, loadStoreEnableB;
	reg isWBA, isWBB;
	reg [4:0] wbAddressA, wbAddressB;
	reg [6:0] opCodeA, opCodeB;
	reg [15:0] pOperandA, sOperandA, pOperandB, sOperandB;
	
	//output buffers
	reg wbEnableA, wbEnableB;
	reg [15:0] wbDataA, wbDataB;
	
	always @(posedge clock_i)//update buffers
	begin
	//input buffers
	if(loadStoreA_i == 1)
		loadStoreEnableA <= 1;
	else
		loadStoreEnableA <= 0;
	
		if(loadStoreB_i == 1)
		loadStoreEnableB <= 1;
	else
		loadStoreEnableB <= 0;
		
	isWBA <= isWbA_i; isWBB <= isWbB_i;
	wbAddressA <= wbAddressA_i; wbAddressB <= wbAddressB_i;
	opCodeA <= opCodeA_i; opCodeB <= opCodeB_i;
	pOperandA <= pOperandA_i; sOperandA <= sOperandA_i; pOperandB <= pOperandB_i; sOperandB <= sOperandB_i;
	
	//output buffers
	wbAddressA_o <= wbAddressA; wbAddressB_o <= wbAddressB;
	wbDataA_o <= wbDataA; wbDataB_o <= wbDataB;
	if(wbEnableA == 1)
		wbEnableA_o <= 1;
	else
		wbEnableA_o <= 0;
		
	if(wbEnableB == 1)
		wbEnableB_o <= 1;
	else
		wbEnableB_o <= 0;
		
	end

	
	always @(posedge clock_i)
	begin
		//port A loadstore
		if(loadStoreEnableA)
		begin
			case(opCodeA)
				0: begin wbEnableA <= 0; wbDataA <= 0; end//nop
				10: begin wbEnableA <= isWBA; wbDataA <= sOperandA; end//store val to reg
				11: begin wbEnableA <= isWBA; wbDataA <= dCache[sOperandA]; end//memory to reg write
				12: begin wbEnableA <= 0; wbDataA <= 0; dCache[sOperandA] <= pOperandA; end//write to memory
			endcase
		end		
	end
	
	always @(posedge clock_i)
	begin
		//port B loadstore
		if(loadStoreEnableB)
		begin
			case(opCodeB)
				0: begin wbEnableB <= 0; wbDataB <= 0; end//nop
				10: begin wbEnableB <= isWBB; wbDataB <= sOperandB; end//store val to reg
				11: begin wbEnableB <= isWBB; wbDataB <= dCache[sOperandB]; end//memory to reg write
				12: begin wbEnableB <= 0; wbDataB <= 0; dCache[sOperandB] <= pOperandB; end//write to memory
			endcase
		end	
	end
endmodule
