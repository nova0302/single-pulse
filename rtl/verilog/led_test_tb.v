//`include "defines.sv"
`timescale 1ns/10ps
module   led_test_tb;

   localparam PERIOD = 10;
   localparam NUM_COUNT = 5;

   reg CLK, RSTn=0, SP=0;
   wire STEP;

   // input driving
   initial begin
      RSTn = 0;
      #15 RSTn <= 1;
      repeat(3) @(posedge CLK);
      SP <= 1'b1;
      @(posedge CLK);
      SP <= 1'b0;
      repeat(15) @(posedge CLK);
      $finish;
   end

   // design under test
`ifdef GATE_SIM
   led_test  dut(.*);
`else
   led_test #(.NUM_COUNT(NUM_COUNT)) dut(.*);
`endif

   // output monitoring
   always @(posedge CLK)
     $monitor("@%0tns count: %0h STEP: %0d dut.State: %0b",$time, dut.count_r, STEP, dut.State);

   // clock generation
   initial begin
      CLK <= 1'b1;
      forever #(PERIOD/2) CLK <= ~CLK;
   end
endmodule // led_test_tb
