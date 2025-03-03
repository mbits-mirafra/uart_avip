`ifndef UARTTXASSERTIONTB_INCLUDED_
`define UARTTXASSERTIONTB_INCLUDED_

`include "uvm_macros.svh"
import uvm_pkg :: *;

module UartTxAssertionTb;
  logic tx;
  bit clk = 0;

  always #5 clk = ~clk;
  initial begin 
    #100;
    $finish;
  end 

  UartTxAssertions uartTxAssertions(.uartClk(clk),.uartTx(tx));
  
  initial begin
      When_startBitisdetected_nextCycleDataTransferStarts_ThenOddParityIsCheckedFailCase_ThenStopBitDetected_AssertionFail();

  end 

  task  When_startBitisdetected_nextCycleDataTransferStarts_ThenStopBitDetected_AssertionPass();
    #4  tx = 1;
    #10 tx = 0;
    #10 tx = 1;
    #10 tx = 0;
    #10 tx = 1;
    #10 tx = 1;
    #10 tx = 0;
    #10 tx = 1 ;
  endtask 
  task  When_startBitisdetected_nextCycleDataTransferStarts_ThenEvenParityIsCheckedPassCase_ThenStopBitDetected_AssertionPass();
    #4  tx = 1;
    #10 tx = 0;
    #10 tx = 1;
    #10 tx = 0;
    #10 tx = 1;
    #10 tx = 1;
    #10 tx = 0;
    #10 tx = 1;
    #10 tx = 1 ;
  endtask
  task  When_startBitisdetected_nextCycleDataTransferStarts_ThenEvenParityIsCheckedFailCase_ThenStopBitDetected_AssertionFail();
    #4  tx = 1;
    #10 tx = 0;
    #10 tx = 1;
    #10 tx = 0;
    #10 tx = 1;
    #10 tx = 1;
    #10 tx = 0;
    #10 tx = 0;
    #10 tx = 1 ;
  endtask 
  task  When_startBitisdetected_nextCycleDataTransferStarts_ThenOddParityIsCheckedPassCase_ThenStopBitDetected_AssertionPass();
    #4  tx = 1;
    #10 tx = 0;
    #10 tx = 1;
    #10 tx = 0;
    #10 tx = 1;
    #10 tx = 1;
    #10 tx = 0;
    #10 tx = 0;
    #10 tx = 1 ;
  endtask
  task  When_startBitisdetected_nextCycleDataTransferStarts_ThenOddParityIsCheckedFailCase_ThenStopBitDetected_AssertionFail();
    #4  tx = 1;
    #10 tx = 0;
    #10 tx = 1;
    #10 tx = 0;
    #10 tx = 1;
    #10 tx = 1;
    #10 tx = 0;
    #10 tx = 1;
    #10 tx = 1 ;
  endtask 
   task  When_startBitisFailedToDetect_AssertionFail();
    #4  tx = 1;
    #10 tx = 1;
    #10 tx = 1;
    #10 tx = 1;
    #10 tx = 1;
    #10 tx = 1;
    #10 tx = 1;
    #10 tx = 1 ;
  endtask 
  
endmodule 

`endif
