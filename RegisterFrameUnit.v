`timescale 1ns / 1ps
`default_nettype none

module RegisterFrameUnit(
	input wire clock_i, enable_i, reset_i,
	input wire [6:0] opCode_i,	
	
	output reg [5:0] regBankSelect_o
    );
	
	reg [5:0] selectedRegisterBank;

always @(posedge clock_i)
begin

	regBankSelect_o <= selectedRegisterBank;
	
	if(reset_i)
	begin
		selectedRegisterBank <= 0;
	end
	else if(enable_i)
	begin	
		if(opCode_i == 11)
		begin
			selectedRegisterBank <= selectedRegisterBank + 1;
		end
		else if(opCode_i == 12)
		begin
			selectedRegisterBank <= selectedRegisterBank - 1;
		end
		else if(opCode_i == 13)
		begin
			selectedRegisterBank <= selectedRegisterBank + 1;
		end
		else if(opCode_i == 14)
		begin
			selectedRegisterBank <= selectedRegisterBank - 1;
		end
	end
end

endmodule
