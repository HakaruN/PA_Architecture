`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//README!
//This FIFO is responsible for taking in register writebacks from the arithmatic and loadstore units, and sequentialising them for the register file
//it is implemented a multi write - multi read curcular queue.

//The way this queue works is as follows:
//The queue is written to by 4 units; the two arithmatic units from the A and B pipelines and also the loadstore unit.
//Each arithmatic unit is capable of submitting one writeback to the FIFO per cycle and the loadstore unit is capable of submitting
//two writebacks to the FIFO per cycle.
//
//The FIFO is capable of retiring two entries per cycle, meaning at peak the FIFO will take a net of plus two entries on a busy cycle.
//
//As the pipelines are only capable of dispatching two instructions per cycle, the average load on the FIFO with a perfectly utilised pipeline
//will be two submissions and two retirements.
//The reason a peak could result in 4 submissions is if a previously dispatched read instruction from both pipelines (memory read) completes at the same
//time as a pair of arithmatic instructions are completed, this would result in 4 register writebacks, this however ought to be very rare and as the queue
//will still operate when the pipelines are pushing nops, this queue will never be able to completly fill as it can handle maximum sustained pipeline bandith
//////////////////////////////////////////////////////////////////////////////////

module WritebackFIFO(
	input wire clock_i,
	input wire reset_i,
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
	
	parameter NUM_QUEUE_ENTRIES = 16;
	integer i;
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
		if(reset_i)
		begin
			//$display("FIFO reset");
			front <= 0;
			back <= 0;
			statusA <= 0;
			statusB <= 0;
			for(i = 0; i < NUM_QUEUE_ENTRIES; i = i + 1)
			begin
				Address[i] <= 0;
				Data[i] <= 0;
				status[i] <= 0;
			end
		end
		else
		begin
			//$display("FIFO enables: %d, %d, %d, %d", ArithAEnable_i, ArithBEnable_i, StoreAEnable_i, StoreBEnable_i);
			//write to the queue
			if(ArithAEnable_i && ArithBEnable_i && StoreAEnable_i && StoreBEnable_i)
			begin//all three writebacks
				//increment the back of the queue for all three writes
				back <= (back + 4) % NUM_QUEUE_ENTRIES;
				//write address to all three elements
				Address[(back) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressA_i;
				Address[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressB_i;
				Address[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreAWriteAddress_i;
				Address[(back + 3) % NUM_QUEUE_ENTRIES] <= StoreBWriteAddress_i;
				//write data to all three elements
				Data[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteDataA_i;
				Data[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteDataB_i;
				Data[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreAWriteData_i;
				Data[(back + 3) % NUM_QUEUE_ENTRIES] <= StoreBWriteData_i;
				//write data to all three elements
				status[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
				status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
				status[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
				status[(back + 3) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
				//update the status register for when the memory writeback is all thats there
				statusA <= ArithWriteStatusA_i;
				statusB <= ArithWriteStatusB_i;
				
			end
			else if(ArithAEnable_i && ArithBEnable_i && StoreAEnable_i && (!StoreBEnable_i))
			begin//all arithmatic writebacks, not store
				//increment the back of the queue for all three writes
				back <= (back + 3) % NUM_QUEUE_ENTRIES;
				//write address to all three elements
				Address[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressA_i;
				Address[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressB_i;
				Address[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreAWriteAddress_i;
				//write data to all three elements
				Data[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteDataA_i;
				Data[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteDataB_i;
				Data[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreAWriteData_i;
				//write data to all three elements
				status[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
				status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
				status[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
				
				//update the status register for when the memory writeback is all thats there
				statusA <= ArithWriteStatusA_i;
				statusB <= ArithWriteStatusB_i;
				
			end
			else if(ArithAEnable_i && ArithBEnable_i && (!StoreAEnable_i) && (StoreBEnable_i))
			begin//one arithmatic writebacks and store
				//increment the back of the queue for all three writes
				back <= (back + 3) % NUM_QUEUE_ENTRIES;
				//write address to all three elements
				Address[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressA_i;
				Address[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressB_i;
				Address[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreBWriteAddress_i;
				//write data to all three elements
				Data[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteDataA_i;
				Data[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteDataB_i;
				Data[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreBWriteData_i;
				//write data to all three elements
				status[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
				status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
				status[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
				
				//update the status register for when the memory writeback is all thats there
				statusA <= ArithWriteStatusA_i;
				statusB <= ArithWriteStatusB_i;
			end
			else if(ArithAEnable_i && ArithBEnable_i && (!StoreAEnable_i) && (!StoreBEnable_i))
			begin//one arithmatic writebacks, not store
				//increment the back of the queue for all three writes
				back <= (back + 2) % NUM_QUEUE_ENTRIES;
				//write address to all three elements
				Address[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressA_i;
				Address[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressB_i;
				//write data to all three elements
				Data[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteDataA_i;
				Data[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteDataB_i;
				//write data to all three elements
				status[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
				status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
				//update the status register for when the memory writeback is all thats there
				statusA <= ArithWriteStatusA_i;
				statusB <= ArithWriteStatusB_i;
				
			end
			else if(ArithAEnable_i && (!ArithBEnable_i) && (StoreAEnable_i) && (StoreBEnable_i))
			begin//one arithmatic writebacks and store
				//increment the back of the queue for all three writes
				back <= (back + 3) % NUM_QUEUE_ENTRIES;
				//write address to all three elements
				Address[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressA_i;
				Address[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreAWriteAddress_i;
				Address[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreBWriteAddress_i;
				//write data to all three elements
				Data[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteDataA_i;
				Data[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreAWriteData_i;
				Data[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreBWriteData_i;
				//write data to all three elements
				status[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;		
				status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
				status[(back + 2) % NUM_QUEUE_ENTRIES] <= statusB;
				//update the status register for when the memory writeback is all thats there
				statusA <= ArithWriteStatusA_i;
				
			end
			else if(ArithAEnable_i && (!ArithBEnable_i) && (StoreAEnable_i) && (!StoreBEnable_i))
			begin//one arithmatic writebacks, not store
				//increment the back of the queue for all three writes
				back <= (back + 2) % NUM_QUEUE_ENTRIES;
				//write address to all three elements
				Address[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressA_i;
				Address[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreAWriteAddress_i;
				//write data to all three elements
				Data[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteDataA_i;
				Data[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreAWriteData_i;
				//write data to all three elements
				status[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
				status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
				//update the status register for when the memory writeback is all thats there
				statusA <= ArithWriteStatusA_i;
			end
			else if(ArithAEnable_i && (!ArithBEnable_i) && (!StoreAEnable_i) && (StoreBEnable_i))
			begin//no arithmatic just store
				//increment the back of the queue for all three writes
				back <= (back + 2) % NUM_QUEUE_ENTRIES;
				//write address to all three elements
				Address[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressA_i;
				Address[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreBWriteAddress_i;
				//write data to all three elements
				Data[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteDataA_i;
				Data[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreBWriteData_i;
				//write data to all three elements
				status[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
				status[(back + 1) % NUM_QUEUE_ENTRIES] <= statusB;
				//update the status register for when the memory writeback is all thats there
				statusA <= ArithWriteStatusA_i;
			end
			else if(ArithAEnable_i && (!ArithBEnable_i) && (!StoreAEnable_i) && (!StoreBEnable_i))
			begin//all three writebacks
				//increment the back of the queue for all three writes
				back <= (back + 1) % NUM_QUEUE_ENTRIES;
				//write address to all three elements
				Address[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressA_i;
				//write data to all three elements
				Data[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteDataA_i;
				//write data to all three elements
				status[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusA_i;
				//update the status register for when the memory writeback is all thats there
				statusA <= ArithWriteStatusA_i;
				
			end
			else if((!ArithAEnable_i) && ArithBEnable_i && StoreAEnable_i && StoreBEnable_i)
			begin//all arithmatic writebacks, not store
				//increment the back of the queue for all three writes
				back <= (back + 3) % NUM_QUEUE_ENTRIES;
				//write address to all three elements
				Address[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressB_i;
				Address[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreAWriteAddress_i;
				Address[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreBWriteAddress_i;
				//write data to all three elements
				Data[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteDataB_i;
				Data[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreAWriteData_i;
				Data[(back + 2) % NUM_QUEUE_ENTRIES] <= StoreBWriteData_i;
				//write data to all three elements
				status[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
				status[(back + 1) % NUM_QUEUE_ENTRIES] <= statusA;
				status[(back + 2) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
				//update the status register for when the memory writeback is all thats there
				statusB <= ArithWriteStatusB_i;
				
			end
			else if((!ArithAEnable_i) && ArithBEnable_i && (StoreAEnable_i) && (!StoreBEnable_i))
			begin//one arithmatic writebacks and store
				//increment the back of the queue for all three writes
				back <= (back + 2) % NUM_QUEUE_ENTRIES;
				//write address to all three elements
				Address[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressB_i;
				Address[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreAWriteAddress_i;
				//write data to all three elements
				Data[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteDataB_i;
				Data[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreAWriteData_i;
				//write data to all three elements
				status[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
				status[(back + 1) % NUM_QUEUE_ENTRIES] <= statusA;
				//update the status register for when the memory writeback is all thats there
				statusB <= ArithWriteStatusB_i;
				
			end
			else if((!ArithAEnable_i) && ArithBEnable_i && (!StoreAEnable_i) && (StoreBEnable_i))
			begin//one arithmatic writebacks, not store
				//increment the back of the queue for all three writes
				back <= (back + 2) % NUM_QUEUE_ENTRIES;
				//write address to all three elements
				Address[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressB_i;
				Address[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreBWriteAddress_i;
				//write data to all three elements
				Data[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteDataB_i;
				Data[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreBWriteData_i;
				//write data to all three elements
				status[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
				status[(back + 1) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
				//update the status register for when the memory writeback is all thats there
				statusB <= ArithWriteStatusB_i;
				
			end
			else if((!ArithAEnable_i) && ArithBEnable_i && (!StoreAEnable_i) && (!StoreBEnable_i))
			begin//one arithmatic writebacks and store
				//increment the back of the queue for all three writes
				back <= (back + 1) % NUM_QUEUE_ENTRIES;
				//write address to all three elements
				Address[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteAddressB_i;
				//write data to all three elements
				Data[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteDataB_i;
				//write data to all three elements
				status[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteStatusB_i;
				
			end
			else if((!ArithAEnable_i) && (!ArithBEnable_i) && (StoreAEnable_i) && (StoreBEnable_i))
			begin//one arithmatic writebacks, not store
				//increment the back of the queue for all three writes
				back <= (back + 2) % NUM_QUEUE_ENTRIES;
				//write address to all three elements
				Address[(back + 0) % NUM_QUEUE_ENTRIES] <= StoreAWriteAddress_i;
				Address[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreBWriteAddress_i;
				//write data to all three elements
				Data[(back + 0) % NUM_QUEUE_ENTRIES] <= StoreAWriteData_i;
				Data[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreBWriteData_i;
				//write data to all three elements
				status[(back + 0) % NUM_QUEUE_ENTRIES] <= statusA;
				status[(back + 1) % NUM_QUEUE_ENTRIES] <= statusB;
			end
			else if((!ArithAEnable_i) && (!ArithBEnable_i) && (StoreAEnable_i) && (!StoreBEnable_i))
			begin//no arithmatic just store
				//increment the back of the queue for all three writes
				back <= (back + 1) % NUM_QUEUE_ENTRIES;
				//write address to all three elements
				Address[(back + 0) % NUM_QUEUE_ENTRIES] <= StoreAWriteAddress_i;
				//write data to all three elements
				Data[(back + 0) % NUM_QUEUE_ENTRIES] <= StoreAWriteData_i;
				//write data to all three elements
				status[(back + 0) % NUM_QUEUE_ENTRIES] <= statusA;
			end
			else if((!ArithAEnable_i) && (!ArithBEnable_i) && (!StoreAEnable_i) && (StoreBEnable_i))
			begin//no arithmatic just store
				//increment the back of the queue for all three writes
				back <= (back + 1) % NUM_QUEUE_ENTRIES;
				//write address to all three elements
				Address[(back + 0) % NUM_QUEUE_ENTRIES] <= StoreBWriteAddress_i;
				//write data to all three elements
				Data[(back + 0) % NUM_QUEUE_ENTRIES] <= StoreBWriteData_i;
				//write data to all three elements
				status[(back + 0) % NUM_QUEUE_ENTRIES] <= statusB;
			end
			//else there are no active inputs
			
			
			//dequeue (2 writebacks per cycle)
			//$display("Front: %d, Back: %d", front, back);
			if(front == back) 
			begin
				//$display("FIFO EMPTY");
				enableA_o <= 0;
				enableB_o <= 0;
			end
			else if(((front + 2) % NUM_QUEUE_ENTRIES) > back)//dequeing 2 operations would be too much
			begin
				if(((front + 1) % NUM_QUEUE_ENTRIES) > back)//dequeing 1 operation is too much
				begin
					//is full
					//$display("queue full");
					enableA_o <= 0;
					enableB_o <= 0;
				end
				else
				begin//2 was to many but 1 wasnt, only pull out one
					//$display("Dequeing 1 writeback");
					enableA_o <= 1;
					AddressA_o <= Address[(front + 0) % NUM_QUEUE_ENTRIES];
					DataA_o <= Data[(front + 0) % NUM_QUEUE_ENTRIES];
					statusA_o <= status[(front + 0) % NUM_QUEUE_ENTRIES];
					front <= front + 1;
					enableB_o <= 0;
				end
			end
			else
			begin
				//$display("Dequeing 2 writebacks");
				//dequeue 2 operations
				enableA_o <= 1;
				AddressA_o <= Address[(front + 0) % NUM_QUEUE_ENTRIES];
				DataA_o <= Data[(front + 0) % NUM_QUEUE_ENTRIES];
				statusA_o <= status[(front + 0) % NUM_QUEUE_ENTRIES];
				
				enableB_o <= 1;
				AddressB_o <= Address[(front + 1) % NUM_QUEUE_ENTRIES];
				DataB_o <= Data[(front + 1) % NUM_QUEUE_ENTRIES];
				statusB_o <= status[(front + 1) % NUM_QUEUE_ENTRIES];
				
				front <= front + 2;
			end
		end		
	end
	


endmodule
