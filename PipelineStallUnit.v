`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//This unit is designed to centralise the stalling control functionality of the core
//it takes a stall input from each of the pipeline stages that may need to be able to generate a stall-back
//and it generates stalls to all of the pipeline stages front-side of the stall-generating pipeline stage
//////////////////////////////////////////////////////////////////////////////////
module PipelineStallUnit(
		//control
		input wire clock_i,
		input wire reset_i,
		
		//inputs - from units needing to generate a stall
		input wire fetch2Stall_i,
		input wire parserAStall_i,
		input wire parserBStall_i,
		input wire decodeAStall_i,
		input wire decodeBStall_i,
		input wire depResAStall_i, depResBStall_i,
		input wire registerAStall_i,
		input wire registerBStall_i,
		
		//output - units to be stalled
		output reg fetch1Stall_o,
		output reg fetch2Stall_o,
		output reg parserAStall_o,
		output reg parserBStall_o,
		output reg decodeAStall_o,
		output reg decodeBStall_o,
		output reg depResStall_o
		
		//TODO: ADD MORE INPUTS AND OUTPUTS FROM/TO LATER PIPELINE STAGES
    );

always @(posedge clock_i)
begin
	if(reset_i)
	begin//on reset, set the CPU's stalled state
		fetch1Stall_o <= 0;
		fetch2Stall_o <= 0;
		parserAStall_o <= 0;
		parserBStall_o <= 0;
		decodeAStall_o <= 0;
		decodeBStall_o <= 0;
	end
	else//run the else-ifs from the back of the pipeline forwards so if something at the back is stalling, 
	begin//it will stall forwards and end up stalling the things at the front anyway. Otherwise the first match at the front coult be 
	//picked up and only stall the front and not the back which is in need of stalling
		if((registerAStall_i == 1) || (registerBStall_i == 1))//if a stall from the registers
		begin
			fetch1Stall_o <= 1;
			fetch2Stall_o <= 1;
			parserAStall_o <= 1;
			parserBStall_o <= 1;
			decodeAStall_o <= 1;
			decodeBStall_o <= 1;
		end
		else if((decodeBStall_i == 1) || (decodeBStall_i == 1))//else if a stall at the decoders
		begin
			fetch1Stall_o <= 1;
			fetch2Stall_o <= 1;
			parserAStall_o <= 1;
			parserBStall_o <= 1;
		end
		else if((parserAStall_i == 1) || (parserBStall_i == 1))//else at the parser
		begin
			fetch1Stall_o <= 1;
			fetch2Stall_o <= 1;
		end
		else if(fetch2Stall_i == 1)//else fetch stage 2
		begin
			fetch1Stall_o <= 1;
		end
		else
		begin//else unstall everything
			fetch1Stall_o <= 0;
			fetch2Stall_o <= 0;
			parserAStall_o <= 0;
			parserBStall_o <= 0;
			decodeAStall_o <= 0;
			decodeBStall_o <= 0;
		end
	end
end


endmodule
