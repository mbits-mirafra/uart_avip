`ifndef UARTVIRTUALTRANSMISSIONSEQUENCE_INCLUDED_
`define UARTVIRTUALTRANSMISSIONSEQUENCE_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: uart_virtual_seqs
//--------------------------------------------------------------------------------------------
class UartVirtualTransmissionSequence extends UartVirtualBaseSequence;
  `uvm_object_utils(UartVirtualTransmissionSequence)
  `uvm_declare_p_sequencer(UartVirtualSequencer)
  
  UartTxTransmitterSequence uartTxTransmitterSequence;
  UartRxBaseSequence uartRxBaseSequence;
  UartTxAgentConfig uartTxAgentConfig;
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "UartVirtualTransmissionSequence");
  extern virtual task body();
  extern task setConfig(UartTxAgentConfig uartTxAgentConfig);
endclass : UartVirtualTransmissionSequence
    
//--------------------------------------------------------------------------------------------
// Constructor:new
// Paramters:
// name - Instance name of the virtual_sequence
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartVirtualTransmissionSequence :: new(string name = "UartVirtualTransmissionSequence" );
  super.new(name);
   uartRxBaseSequence = UartRxBaseSequence :: type_id :: create("uartRxBaseSequence");
endfunction : new
    
//--------------------------------------------------------------------------------------------
// task:body
// phase - stores the current phase
//--------------------------------------------------------------------------------------------

task UartVirtualTransmissionSequence :: body();
  fork 
  `uvm_do_on_with(uartTxTransmitterSequence , p_sequencer.uartTxSequencer,{})
   uartTxTransmitterSequence.setConfig(this.uartTxAgentConfig);
 join
endtask : body

task UartVirtualTransmissionSequence :: setConfig(UartTxAgentConfig uartTxAgentConfig);
  this.uartTxAgentConfig = uartTxAgentConfig;
endtask 

`endif
