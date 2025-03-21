`ifndef UARTTXBASESEQUENCE_INCLUDED_
`define UARTTXBASESEQUENCE_INCLUDED_

class UartTxBaseSequence extends uvm_sequence#(UartTxTransaction);
  `uvm_object_utils(UartTxBaseSequence)
  
  extern function new(string name = "UartTxBaseSequence");
  extern virtual task body();
  UartTxAgentConfig uartTxAgentConfig_;
endclass : UartTxBaseSequence

function  UartTxBaseSequence :: new(string name= "UartTxBaseSequence");
  super.new(name);
endfunction : new

task UartTxBaseSequence :: body();
 super.body();
endtask : body

 
`endif   
