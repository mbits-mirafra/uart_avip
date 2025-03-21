`ifndef UARTTXBASESEQUENCEWITHPATTERN_INCLUDED_
`define UARTTXBASESEQUENCEWITHPATTERN_INCLUDED_

class UartTxBaseSequenceWithPattern extends UartTxBaseSequence;
  `uvm_object_utils(UartTxBaseSequenceWithPattern)
  
  extern function new(string name = "UartTxBaseSequenceWithPattern");
  extern virtual task body();
  rand int packetsNeeded;
  rand logic[DATA_WIDTH-1:0]patternToTransmit;
endclass : UartTxBaseSequenceWithPattern

function  UartTxBaseSequenceWithPattern :: new(string name= "UartTxBaseSequenceWithPattern");
  super.new(name);
endfunction : new

task UartTxBaseSequenceWithPattern :: body();
  req = UartTxTransaction :: type_id :: create("req");
    start_item(req);
    if(!(req.randomize() with{transmissionData == patternToTransmit;}))
      `uvm_fatal("[tx sequence]","randomization failed")
    req.print();
    finish_item(req);
endtask : body
 
`endif   
