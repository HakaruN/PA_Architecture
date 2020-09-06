`timescale 1ns / 1ps
`default_nettype none
module ExecUnit(
		input wire clock_i, isWb_i, enable_i, reset_i,
		input wire [4:0] wbAddress_i,
		input wire [6:0] opCode_i,
		input wire [15:0] pOperand_i, sOperand_i,
		input wire [5:0] regBankSelect_i,
		
		output reg wbEnable_o, 
		output reg [4:0] wbAddress_o,
		output reg [15:0] wbData_o,
		output reg [5:0] regBankSelect_o
    );
	 
	always @(posedge clock_i)
	begin
		if(reset_i)
			regBankSelect_o <= 0;
			
		if(enable_i)
		begin
			wbEnable_o <= isWb_i;
			wbAddress_o <= wbAddress_i; 
			case(opCode_i)
			0: begin wbEnable_o <= 0; wbData_o <= 0; end//nop
			1: begin wbData_o <= pOperand_i + sOperand_i; end//add
			2: begin wbData_o <= pOperand_i - sOperand_i; end//sub
			3: begin wbData_o <= pOperand_i * sOperand_i; end//mul
			4: begin wbData_o <= sOperand_i; end
			5: begin wbData_o <= sOperand_i; end
			6: begin regBankSelect_o <= regBankSelect_i + 1; end//increment regbank
			7: begin regBankSelect_o <= regBankSelect_i - 1; end//decrement regbank
			endcase
		end
	end
endmodule
