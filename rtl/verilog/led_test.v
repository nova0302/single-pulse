
//`define SIMULATION

`timescale 1ns/10ps
module led_test 
`ifdef SIMULATION
  #(parameter NUM_COUNT = 5)
`else
   #(parameter NUM_COUNT = 50000000)
`endif
   (
    input  CLK, //system clock 50Mhz
    input  RSTn, SP,
    output STEP
    );

   localparam OFF = 1'b0, ON = 1'b1;

   integer count_r, count_n;
   reg 	   State, nState;
   reg 	   sp_dly;
   wire    start;

   assign start = ~sp_dly & SP;
   always@(posedge CLK)
     sp_dly <= SP;

   assign STEP = (State == ON);

   // State register
   always @(posedge CLK, negedge RSTn)
     if(!RSTn)
       State <= OFF;
     else
       State <= nState;

   // next State comb block
   always@* begin
      nState = State;  //defaults
      case(State)
	OFF: 
	  if(start) 
	    nState = ON;
	ON: 
	  if(count_r == NUM_COUNT)
	    nState = OFF;
      endcase // case (State)
   end

   // next State comb block
   always@* begin
      count_n = count_r;
      case(State)
	OFF: 
	  count_n = 0;
	ON: 
	  count_n = count_r + 1;
      endcase // case (State)
   end
   
   // conter register
   always@(posedge CLK, negedge RSTn)
     if(!RSTn)
       count_r <= 0;
     else 
       count_r <= count_n;

endmodule // led_test

