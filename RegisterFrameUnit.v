`timescale 1ns / 1ps
`default_nettype none

module RegisterFrameUnit(
	input wire clock_i, enable_i, reset_i,
	input wire [6:0] opCode_i,	
	input wire [5:0] regBankSelect_i,
	
	output reg [5:0] regBankSelect_o
    );

always @(posedge clock_i)
begin
	if(reset_i)
			regBankSelect_o <= 0;
			
	if(enable_i)
	begin	
		case(opCode_i)
		12: begin regBankSelect_o <= regBankSelect_i + 1; end//next reg frame
		13: begin regBankSelect_o <= regBankSelect_i - 1; end//prev reg frame
		14: begin regBankSelect_o <= regBankSelect_i + 1; end//new reg frame
		15: begin regBankSelect_o <= regBankSelect_i - 1; end//ndel current reg frame
		endcase
	end
	
end

endmodule
