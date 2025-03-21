`ifndef UARTTXTRANSMITTERSEQUENCE_INCLUDED_
`define UARTTXTRANSMITTERSEQUENCE_INCLUDED_

class UartTxTransmitterSequence extends UartTxBaseSequence;
  `uvm_object_utils(UartTxTransmitterSequence)
  
  extern function new(string name = "UartTxTransmitterSequence");
  extern virtual task body();
  extern task setConfig(UartTxAgentConfig uartTxAgentConfig);
endclass : UartTxTransmitterSequence

function  UartTxTransmitterSequence :: new(string name= "UartTxTransmitterSequence");
  super.new(name);
endfunction : new

task UartTxTransmitterSequence :: body();
  if (uartTxAgentConfig_ == null)
    `uvm_fatal("[TX SEQUENCE]", "uartTxAgentConfig_ is NULL in body")
 req = UartTxTransaction :: type_id :: create("req");
 start_item(req);
 if(!(req.randomize()))
   `uvm_fatal("[tx sequence]","randomization failed")
 
 req.print();
 finish_item(req);
endtask : body

task UartTxTransmitterSequence::setConfig(UartTxAgentConfig uartTxAgentConfig);
 this.uartTxAgentConfig_ = uartTxAgentConfig;
 
  if (this.uartTxAgentConfig_ == null)
    `uvm_fatal("[TX SEQUENCE]", "uartTxAgentConfig_ is NULL inside setConfig")
  else
    `uvm_info("[TX SEQUENCE]", "uartTxAgentConfig_ successfully set", UVM_MEDIUM)
endtask
 
`endif   
