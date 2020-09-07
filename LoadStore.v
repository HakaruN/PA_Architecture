`timescale 1ns / 1ps
`default_nettype none
module LoadStore(
   	input wire clock_i, isWbA_i, isWbB_i, 
		input wire storeEnable_i, loadEnable_i, enableA_i, enableB_i,
		input wire [4:0] wbAddressA_i, wbAddressB_i,
		input wire [6:0] opCodeA_i, opCodeB_i,
		input wire [15:0] pOperandA_i, sOperandA_i,pOperandB_i, sOperandB_i,
		
		output reg wbEnableA_o, wbEnableB_o,
		output reg [4:0] wbAddressA_o, wbAddressB_o, 
		output reg [15:0] wbDataA_o, wbDataB_o
    );
	 
always @(posedge clock_i)
begin
	wbEnableA_o <= isWbA_i & enableA_i;
	wbEnableB_o <= isWbB_i & enableB_i;
	if(loadEnable_i)
	begin
		if(enableA_i)
		begin
			
			wbAddressA_o <= wbAddressA_i;
			case(opCodeA_i)
				0: begin wbEnableA_o <= 0; wbDataA_o <= 0; end//nop
				4: begin wbEnableA_o <= 1; wbDataA_o <= sOperandA_i; /*wbAddress_o; <= pOperandA_i*/ end//store val to reg
			endcase
		end
		if(enableB_i)
		begin
			
			wbAddressB_o <= wbAddressB_i;
			case(opCodeB_i)
				0: begin wbEnableB_o <= 0; wbDataB_o <= 0; end//nop
				4: begin wbEnableB_o <= 1; wbDataB_o <= sOperandB_i; /*wbAddressB_o; <= pOperandA_i*/ end//store val to reg
			endcase
		end				
	end
	
end
endmodule
