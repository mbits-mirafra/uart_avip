`ifndef UARTVIRTUALTRANSMISSIONSEQUENCE_INCLUDED_
`define UARTVIRTUALTRANSMISSIONSEQUENCE_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: uart_virtual_seqs
//--------------------------------------------------------------------------------------------
class UartVirtualTransmissionSequence extends UartVirtualBaseSequence;
  `uvm_object_utils(UartVirtualTransmissionSequence)
  `uvm_declare_p_sequencer(UartVirtualSequencer)
  
  UartTxBaseSequence uartTxBaseSequence;
  UartRxBaseSequence uartRxBaseSequence;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "UartVirtualTransmissionSequence");
  extern virtual task body();

endclass : UartVirtualTransmissionSequence
    
//--------------------------------------------------------------------------------------------
// Constructor:new
//
// Paramters:
// name - Instance name of the virtual_sequence
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartVirtualTransmissionSequence :: new(string name = "UartVirtualTransmissionSequence" );
  super.new(name);
endfunction : new
    
//--------------------------------------------------------------------------------------------
// task:body
// Creates the required ports
//
// Parameters:
// phase - stores the current phase
//--------------------------------------------------------------------------------------------

task UartVirtualTransmissionSequence :: body();
  super.body();
  uartTxBaseSequence = UartTxBaseSequence :: type_id :: create("uartTxBaseSequence");
  uartRxBaseSequence = UartRxBaseSequence :: type_id :: create("uartRxBaseSequence");
  
  begin 
    uartTxBaseSequence.start(p_sequencer.uartTxSequencer);
    uartRxBaseSequence.start(p_sequencer.uartRxSequencer);
  end 


endtask : body

`endif

