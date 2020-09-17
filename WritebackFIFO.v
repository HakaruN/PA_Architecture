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
	input wire ArithEnable_i,
	input wire [4:0] ArithWriteAddress_i,
	input wire [15:0] ArithWriteData_i,
	input wire [1:0] ArithWriteStatus_i,

	//input data from the store unit
	input wire StoreEnable_i,
	input wire [4:0] StoreWriteAddress_i,
	input wire [15:0] StoreWriteData_i,
	
	//two output ports (two dequeues per cycle)
	output reg enable_o,
	output reg [4:0] Address_o,
	output reg [15:0] Data_o,
	output reg [1:0] status_o
	);

	parameter NUM_QUEUE_ENTRIES = 8;
	integer i;
	//old status
	//these are updated with the status from the arithmatics so when the store happens, we know what status to send back
	reg [1:0] statusR;
	
	//writeback queue	
	reg [4:0] Address [NUM_QUEUE_ENTRIES -1: 0];
	reg [15:0] Data [NUM_QUEUE_ENTRIES -1: 0];
	reg [1:0] status [NUM_QUEUE_ENTRIES -1: 0];
	
	reg [3:0] front, back;//front and back of the queue
	
	always @(posedge clock_i)
	begin
		//$display("\n");
		if(reset_i)
		begin
			//$display("FIFO reset");
			front <= 0;
			back <= 0;
			statusR <= 0;
			for(i = 0; i < NUM_QUEUE_ENTRIES; i = i + 1)
			begin
				Address[i] <= 0;
				Data[i] <= 0;
				status[i] <= 0;
			end
		end
		else
		begin
			//enqueue
			if((!ArithEnable_i) && (!StoreEnable_i))
			begin//all three writebacks
				//do nothing if neither are active
				//$display("enqueing nothing");
			end
			else if((!ArithEnable_i) && StoreEnable_i)
			begin
				//$display("enqueing 1 element");
				back <= (back + 1) % NUM_QUEUE_ENTRIES;
				
				//set the status for the elements in the fifo
				status[(back + 0) % NUM_QUEUE_ENTRIES] <= statusR;
				
				Address[(back + 0) % NUM_QUEUE_ENTRIES] <= StoreWriteAddress_i;
				
				Data[(back + 0) % NUM_QUEUE_ENTRIES] <= StoreWriteData_i;						
			end
			else if(ArithEnable_i && (!StoreEnable_i))
			begin
				//$display("enqueing 1 element");
				back <= (back + 1) % NUM_QUEUE_ENTRIES;
				statusR <= ArithWriteStatus_i;//set the status state
				
				//set the status for the elements in the fifo
				status[(back + 0) % NUM_QUEUE_ENTRIES] <= statusR;	
				
				Address[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteAddress_i;
				
				Data[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteData_i;					
			end
			else if(ArithEnable_i && StoreEnable_i)
			begin//all three writebacks
				//$display("enqueing 2 elements");
				back <= (back + 2) % NUM_QUEUE_ENTRIES;
				statusR <= ArithWriteStatus_i;//set the status state
				
				//set the status for the elements in the fifo
				status[(back + 0) % NUM_QUEUE_ENTRIES] <= statusR;
				status[(back + 1) % NUM_QUEUE_ENTRIES] <= statusR;		
				
				Address[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteAddress_i;
				Address[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreWriteAddress_i;
				
				Data[(back + 0) % NUM_QUEUE_ENTRIES] <= ArithWriteData_i;
				Data[(back + 1) % NUM_QUEUE_ENTRIES] <= StoreWriteData_i;						
			end
			
			//dequeue
			if(front == back)//FIFO empty
			begin
				//$display("FIFO EMPTY");
				enable_o <= 0;
			end
			else if(((front + 1) % NUM_QUEUE_ENTRIES) > back)//dequeing 1 operation is too much (FIFO full)
			begin
				//is full
				//$display("FIFO FULL");
				enable_o <= 0;
			end
			else
			begin//dequeue one element
				//$display("Dequeing 1 element");
				enable_o <= 1;
				Address_o <= Address[(front + 0) % NUM_QUEUE_ENTRIES];
				Data_o <= Data[(front + 0) % NUM_QUEUE_ENTRIES];
				status_o <= status[(front + 0) % NUM_QUEUE_ENTRIES];
				front <= (front + 1) % NUM_QUEUE_ENTRIES;
			end			
			
		end
	end
endmodule
