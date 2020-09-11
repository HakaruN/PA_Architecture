`timescale 1ns / 1ps
`default_nettype none
module LoadStore(
   	input wire clock_i, isWbA_i, isWbB_i, 
		input wire loadEnable_i, storeEnable_i, enableA_i, enableB_i,
		input wire [4:0] wbAddressA_i, wbAddressB_i,
		input wire [6:0] opCodeA_i, opCodeB_i,
		input wire [15:0] pOperandA_i, sOperandA_i,pOperandB_i, sOperandB_i,
		
		output reg wbEnableA_o, wbEnableB_o,
		output reg [4:0] wbAddressA_o, wbAddressB_o, 
		output reg [15:0] wbDataA_o, wbDataB_o
    );	 
	 //data cache
	 parameter numCachelines = 3; parameter cachlinewidth = 16; parameter sizeOfAByte = 8;
	 //reg [(cachlinewidth * sizeOfAByte) - 1:0] dCache [numCachelines -1 :0];//128 entry i-cache where each cacheline is 50 bits wide (1 instruction)
	 reg [15:0] dCache [numCachelines -1 :0];//128 entry i-cache where each cacheline is 50 bits wide (1 instruction)
	 
always @(posedge clock_i)
begin
	wbEnableA_o <= isWbA_i & enableA_i;
	wbEnableB_o <= isWbB_i & enableB_i;
	
	//load
	if(loadEnable_i)
	begin
		if(enableA_i)
		begin			
			wbAddressA_o <= wbAddressA_i;
			case(opCodeA_i)
				0: begin wbEnableA_o <= 0; wbDataA_o <= 0; end//nop
				10: begin wbEnableA_o <= 1; wbDataA_o <= sOperandA_i; /*wbAddress_o; <= pOperandA_i*/ end//store val to reg
				11: begin wbEnableA_o <= 1; wbDataA_o <= dCache[sOperandA_i]; end//load from memory into primary reg at location of secondary3
			endcase
		end
		
		if(enableB_i)
		begin			
			wbAddressB_o <= wbAddressB_i;
			case(opCodeB_i)
				0: begin wbEnableB_o <= 0; wbDataB_o <= 0; end//nop
				10: begin wbEnableB_o <= 1; wbDataB_o <= sOperandB_i; /*wbAddressB_o; <= pOperandA_i*/ end//store val to reg
				11: begin wbEnableB_o <= 1; wbDataB_o <= dCache[sOperandB_i]; end//load from memory into primary reg at location of secondary
			endcase
		end				
	end
	
	if(storeEnable_i)
	begin
		if(enableA_i)
		begin
			case(opCodeA_i)
				0: begin wbEnableA_o <= 0; wbDataA_o <= 0; end//nop
				12: begin wbEnableA_o <= 0; wbDataA_o <= 0; dCache[sOperandA_i] <= pOperandA_i; end//store to memory
			endcase
		end
		
		if(enableB_i)
		begin		
			case(opCodeA_i)
				0: begin wbEnableA_o <= 0; wbDataA_o <= 0; end//nop
				12: begin wbEnableB_o <= 0; wbDataA_o <= 0; dCache[sOperandB_i] <= pOperandB_i; end//store to memory
			endcase
		end
	end
	
end
endmodule
