`timescale 1ns / 1ps
`default_nettype none

module ArithmaticUnit(
		input wire clock_i, isWb_i, enable_i,
		input wire [4:0] wbAddress_i,
		input wire [6:0] opCode_i,
		input wire [15:0] pOperand_i, sOperand_i,
		
		output reg wbEnable_o, 
		output reg [4:0] wbAddress_o,
		output reg [15:0] wbData_o,
		output reg [1:0] statusWriteback_o //[1] - overflow, [0] - underflow
    );
	 
	always @(posedge clock_i)
	begin
			
		if(enable_i)
		begin
			wbEnable_o <= isWb_i;
			wbAddress_o <= wbAddress_i; 
			case(opCode_i)
			0: begin wbEnable_o <= 0; wbData_o <= 0; end//nop
			1: begin wbData_o <= pOperand_i + sOperand_i; if ((pOperand_i + sOperand_i) < pOperand_i) begin statusWriteback_o[0] <= 0; statusWriteback_o[1] <= 1; end else begin statusWriteback_o[0] <= 0; statusWriteback_o[1] <= 0; end end//add
			2: begin wbData_o <= pOperand_i - sOperand_i; if ((pOperand_i - sOperand_i) > pOperand_i) begin statusWriteback_o[0] <= 1; statusWriteback_o[1] <= 0;end else begin statusWriteback_o[0] <= 0; statusWriteback_o[1] <= 0; end end//sub
			3: begin wbData_o <= pOperand_i * sOperand_i; end//mul
			endcase
		end
	end
endmodule