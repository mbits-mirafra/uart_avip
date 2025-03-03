`ifndef UARTRXBASESEQUENCE_INCLUDED_
`define UARTRXBASESEQUENCE_INCLUDED_

class UartRxBaseSequence extends uvm_sequence#(UartRxTransaction);
  `uvm_object_utils(UartRxBaseSequence)
  
  extern function new(string name = "UartRxBaseSequence");
  extern virtual task body();

endclass : UartRxBaseSequence

function UartRxBaseSequence :: new(string name= "UartRxBaseSequence");
  super.new(name);
endfunction : new

task UartRxBaseSequence :: body();
  super.body();
  req = UartRxTransaction :: type_id :: create("req");
  start_item(req);
  if( !(req.randomize()))
   `uvm_fatal(get_type_name(),"Randomization failed")
  req.print(); 
  finish_item(req);
endtask : body
 
`endif   
