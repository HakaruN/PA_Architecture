`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:11:16 09/10/2020 
// Design Name: 
// Module Name:    WritebackFIFO 
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
module WritebackFIFO(
	input wire clock_i,
	//input data from the Arithmatic units
	input wire ArithAEnable_i, ArithBEnable_i,
	input wire [4:0] ArithWriteAddressA_i, ArithWriteAddressB_i,
	input wire [15:0] ArithWriteDataA_i, ArithWriteDataB_i,
	input wire [1:0]ArithWriteStatusA_i, ArithWriteStatusB_i,

	//input data from the store unit
	input wire StoreAEnable_i, StoreBEnable_i,
	input wire [4:0] StoreAWriteAddress_i, StoreBWriteAddress_i,
	input wire [15:0] StoreAWriteData_i, StoreBWriteData_i,
	
	//two output ports (two dequeues per cycle)
	output reg enableA_o, enableB_o,
	output reg [4:0] AddressA_o, AddressB_o,
	output reg [15:0] DataA_o, DataB_o,
	output reg [1:0] statusA_o, statusB_o
	);
	
	parameter NUM_QUEUE_ENTRIES = 8;
	
	//old status
	//these are updated with the status from the arithmatics so when the store happens, we know what status to send back
	reg [1:0] statusA, statusB;
	
	//writeback queue	
	reg [4:0] Address [NUM_QUEUE_ENTRIES -1: 0];
	reg [15:0] Data [NUM_QUEUE_ENTRIES -1: 0];
	reg [1:0] status [NUM_QUEUE_ENTRIES -1: 0];
	
	reg [3:0] front, back;//front and back of the queue
	
	always @(posedge clock_i)
	begin
		//write to the queue
		if(ArithAEnable_i && ArithBEnable_i && StoreAEnable_i && StoreBEnable_i)
		begin//all three writebacks
			//increment the back of the queue for all three writes
			back <= (back + 4) % NUM_QUEUE_ENTRIES;
			//write address to all three elements
			Address[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressA_i;
			Address[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressB_i;
			Address[(back + 3) % NUM_QUEUE_ENTRIES] <= StoreAWriteAddress_i;
			Address[(back + 4) % NUM_QUEUE_ENTRIES] <= StoreBWriteAddress_i;
			//write data to all three elements
			Data[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteDataA_i;
			Data[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteDataB_i;
			Data[(back + 3) % NUM_QUEUE_ENTRIES] <= StoreAWriteData_i;
			Data[(back + 4) % NUM_QUEUE_ENTRIES] <= StoreBWriteData_i;
			//write data to all three elements
			status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
			status[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
			status[(back + 3) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
			status[(back + 4) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
			//update the status register for when the memory writeback is all thats there
			statusA <= ArithWriteStatusA_i;
			statusB <= ArithWriteStatusB_i;
			
		end
		else if(ArithAEnable_i && ArithBEnable_i && StoreAEnable_i && (!StoreBEnable_i))
		begin//all arithmatic writebacks, not store
			//increment the back of the queue for all three writes
			back <= (back + 3) % NUM_QUEUE_ENTRIES;
			//write address to all three elements
			Address[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressA_i;
			Address[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressB_i;
			Address[(back + 3) % NUM_QUEUE_ENTRIES] <= StoreAWriteAddress_i;
			//write data to all three elements
			Data[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteDataA_i;
			Data[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteDataB_i;
			Data[(back + 3) % NUM_QUEUE_ENTRIES] <= StoreAWriteData_i;
			//write data to all three elements
			status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
			status[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
			status[(back + 3) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
			
			//update the status register for when the memory writeback is all thats there
			statusA <= ArithWriteStatusA_i;
			statusB <= ArithWriteStatusB_i;
			
		end
		else if(ArithAEnable_i && ArithBEnable_i && (!StoreAEnable_i) && (StoreBEnable_i))
		begin//one arithmatic writebacks and store
			//increment the back of the queue for all three writes
			back <= (back + 3) % NUM_QUEUE_ENTRIES;
			//write address to all three elements
			Address[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressA_i;
			Address[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressB_i;
			Address[(back + 3) % NUM_QUEUE_ENTRIES] <= StoreBWriteAddress_i;
			//write data to all three elements
			Data[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteDataA_i;
			Data[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteDataB_i;
			Data[(back + 3) % NUM_QUEUE_ENTRIES] <= StoreBWriteData_i;
			//write data to all three elements
			status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
			status[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
			status[(back + 3) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
			
			//update the status register for when the memory writeback is all thats there
			statusA <= ArithWriteStatusA_i;
			statusB <= ArithWriteStatusB_i;
		end
		else if(ArithAEnable_i && ArithBEnable_i && (!StoreAEnable_i) && (!StoreBEnable_i))
		begin//one arithmatic writebacks, not store
			//increment the back of the queue for all three writes
			back <= (back + 2) % NUM_QUEUE_ENTRIES;
			//write address to all three elements
			Address[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressA_i;
			Address[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressB_i;
			//write data to all three elements
			Data[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteDataA_i;
			Data[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteDataB_i;
			//write data to all three elements
			status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
			status[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
			//update the status register for when the memory writeback is all thats there
			statusA <= ArithWriteStatusA_i;
			statusB <= ArithWriteStatusB_i;
			
		end
		else if(ArithAEnable_i && (!ArithBEnable_i) && (StoreAEnable_i) && (StoreBEnable_i))
		begin//one arithmatic writebacks and store
			//increment the back of the queue for all three writes
			back <= (back + 3) % NUM_QUEUE_ENTRIES;
			//write address to all three elements
			Address[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressA_i;
			Address[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreAWriteAddress_i;
			Address[(back + 3) % NUM_QUEUE_ENTRIES] <= StoreBWriteAddress_i;
			//write data to all three elements
			Data[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteDataA_i;
			Data[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreAWriteData_i;
			Data[(back + 3) % NUM_QUEUE_ENTRIES] <= StoreBWriteData_i;
			//write data to all three elements
			status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;		
			status[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
			status[(back + 3) % NUM_QUEUE_ENTRIES] <= statusB;
			//update the status register for when the memory writeback is all thats there
			statusA <= ArithWriteStatusA_i;
			
		end
		else if(ArithAEnable_i && (!ArithBEnable_i) && (StoreAEnable_i) && (!StoreBEnable_i))
		begin//one arithmatic writebacks, not store
			//increment the back of the queue for all three writes
			back <= (back + 2) % NUM_QUEUE_ENTRIES;
			//write address to all three elements
			Address[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressA_i;
			Address[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreAWriteAddress_i;
			//write data to all three elements
			Data[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteDataA_i;
			Data[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreAWriteData_i;
			//write data to all three elements
			status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
			status[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
			//update the status register for when the memory writeback is all thats there
			statusA <= ArithWriteStatusA_i;
		end
		else if(ArithAEnable_i && (!ArithBEnable_i) && (!StoreAEnable_i) && (StoreBEnable_i))
		begin//no arithmatic just store
			//increment the back of the queue for all three writes
			back <= (back + 2) % NUM_QUEUE_ENTRIES;
			//write address to all three elements
			Address[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressA_i;
			Address[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreBWriteAddress_i;
			//write data to all three elements
			Data[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteDataA_i;
			Data[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreBWriteData_i;
			//write data to all three elements
			status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
			status[(back + 2) % NUM_QUEUE_ENTRIES] <= statusB;
			//update the status register for when the memory writeback is all thats there
			statusA <= ArithWriteStatusA_i;
		end
		else if(ArithAEnable_i && (!ArithBEnable_i) && (!StoreAEnable_i) && (!StoreBEnable_i))
		begin//all three writebacks
			//increment the back of the queue for all three writes
			back <= (back + 1) % NUM_QUEUE_ENTRIES;
			//write address to all three elements
			Address[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressA_i;
			//write data to all three elements
			Data[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteDataA_i;
			//write data to all three elements
			status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
			//update the status register for when the memory writeback is all thats there
			statusA <= ArithWriteStatusA_i;
			
		end
		else if((!ArithAEnable_i) && ArithBEnable_i && StoreAEnable_i && StoreBEnable_i)
		begin//all arithmatic writebacks, not store
			//increment the back of the queue for all three writes
			back <= (back + 3) % NUM_QUEUE_ENTRIES;
			//write address to all three elements
			Address[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressB_i;
			Address[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreAWriteAddress_i;
			Address[(back + 3) % NUM_QUEUE_ENTRIES] <= StoreBWriteAddress_i;
			//write data to all three elements
			Data[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteDataB_i;
			Data[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreAWriteData_i;
			Data[(back + 3) % NUM_QUEUE_ENTRIES] <= StoreBWriteData_i;
			//write data to all three elements
			status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
			status[(back + 2) % NUM_QUEUE_ENTRIES] <= statusA;
			status[(back + 3) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
			//update the status register for when the memory writeback is all thats there
			statusB <= ArithWriteStatusB_i;
			
		end
		else if((!ArithAEnable_i) && ArithBEnable_i && (StoreAEnable_i) && (!StoreBEnable_i))
		begin//one arithmatic writebacks and store
			//increment the back of the queue for all three writes
			back <= (back + 2) % NUM_QUEUE_ENTRIES;
			//write address to all three elements
			Address[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressB_i;
			Address[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreAWriteAddress_i;
			//write data to all three elements
			Data[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteDataB_i;
			Data[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreAWriteData_i;
			//write data to all three elements
			status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
			status[(back + 2) % NUM_QUEUE_ENTRIES] <= statusA;
			//update the status register for when the memory writeback is all thats there
			statusB <= ArithWriteStatusB_i;
			
		end
		else if((!ArithAEnable_i) && ArithBEnable_i && (!StoreAEnable_i) && (StoreBEnable_i))
		begin//one arithmatic writebacks, not store
			//increment the back of the queue for all three writes
			back <= (back + 2) % NUM_QUEUE_ENTRIES;
			//write address to all three elements
			Address[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressB_i;
			Address[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreBWriteAddress_i;
			//write data to all three elements
			Data[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteDataB_i;
			Data[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreBWriteData_i;
			//write data to all three elements
			status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
			status[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
			//update the status register for when the memory writeback is all thats there
			statusB <= ArithWriteStatusB_i;
			
		end
		else if((!ArithAEnable_i) && ArithBEnable_i && (!StoreAEnable_i) && (!StoreBEnable_i))
		begin//one arithmatic writebacks and store
			//increment the back of the queue for all three writes
			back <= (back + 1) % NUM_QUEUE_ENTRIES;
			//write address to all three elements
			Address[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressB_i;
			//write data to all three elements
			Data[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteDataB_i;
			//write data to all three elements
			status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
			
		end
		else if((!ArithAEnable_i) && (!ArithBEnable_i) && (StoreAEnable_i) && (StoreBEnable_i))
		begin//one arithmatic writebacks, not store
			//increment the back of the queue for all three writes
			back <= (back + 2) % NUM_QUEUE_ENTRIES;
			//write address to all three elements
			Address[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreAWriteAddress_i;
			Address[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreBWriteAddress_i;
			//write data to all three elements
			Data[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreAWriteData_i;
			Data[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreBWriteData_i;
			//write data to all three elements
			status[(back + 1) % NUM_QUEUE_ENTRIES] <= statusA;
			status[(back + 2) % NUM_QUEUE_ENTRIES] <= statusB;
		end
		else if((!ArithAEnable_i) && (!ArithBEnable_i) && (StoreAEnable_i) && (!StoreBEnable_i))
		begin//no arithmatic just store
			//increment the back of the queue for all three writes
			back <= (back + 1) % NUM_QUEUE_ENTRIES;
			//write address to all three elements
			Address[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreAWriteAddress_i;
			//write data to all three elements
			Data[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreAWriteData_i;
			//write data to all three elements
			status[(back + 1) % NUM_QUEUE_ENTRIES] <= statusA;
		end
		else if((!ArithAEnable_i) && (!ArithBEnable_i) && (!StoreAEnable_i) && (StoreBEnable_i))
		begin//no arithmatic just store
			//increment the back of the queue for all three writes
			back <= (back + 1) % NUM_QUEUE_ENTRIES;
			//write address to all three elements
			Address[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreBWriteAddress_i;
			//write data to all three elements
			Data[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreBWriteData_i;
			//write data to all three elements
			status[(back + 1) % NUM_QUEUE_ENTRIES] <= statusB;
		end
		//else there are no active inputs
		
		
		//dequeue (2 writebacks per cycle)
		//front, back
		if(((front + 2) % NUM_QUEUE_ENTRIES) >= back)//dequeing 2 operations would be too much
		begin
			if(((front + 1) % NUM_QUEUE_ENTRIES) >= back)//dequeing 1 operation is too much
			begin
				//is full
				enableA_o <= 0;
				enableB_o <= 0;
			end
			else
			begin//2 was to many but 1 wasnt, only pull out one
				enableA_o <= 1;
				AddressA_o <= Address[(front + 1) % NUM_QUEUE_ENTRIES];
				DataA_o <= Data[(front + 1) % NUM_QUEUE_ENTRIES];
				statusA_o <= status[(front + 1) % NUM_QUEUE_ENTRIES];
				front <= front + 1;
			end
		end
		else
		begin
			//dequeue 2 operations
			enableA_o <= 1;
			AddressA_o <= Address[(front + 1) % NUM_QUEUE_ENTRIES];
			DataA_o <= Data[(front + 1) % NUM_QUEUE_ENTRIES];
			statusA_o <= status[(front + 1) % NUM_QUEUE_ENTRIES];
			
			enableB_o <= 1;
			AddressB_o <= Address[(front + 2) % NUM_QUEUE_ENTRIES];
			DataB_o <= Data[(front + 2) % NUM_QUEUE_ENTRIES];
			statusB_o <= status[(front + 2) % NUM_QUEUE_ENTRIES];
			
			front <= front + 2;
		end
	end
	


endmodule
