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
  UartTxAgentConfig uartTxAgentConfig;
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
  uartTxBaseSequence = UartTxBaseSequence :: type_id :: create("uartTxBaseSequence");
  uartRxBaseSequence = UartRxBaseSequence :: type_id :: create("uartRxBaseSequence");
  if(!(uvm_config_db#(UartTxAgentConfig) :: get(null,"","uartTxAgentConfig",uartTxAgentConfig)))
    `uvm_fatal("[VIRTUAL SEQUENCE]",$sformatf("failed to get the config"))
  begin 
 //   uartTxBaseSequence.start(p_sequencer.uartTxSequencer);
     `uvm_do_on_with(uartTxBaseSequence , p_sequencer.uartTxSequencer,{packetsNeeded ==uartTxAgentConfig.packetsNeeded;})
 //  uartRxBaseSequence.start(p_sequencer.uartRxSequencer);
  end 


endtask : body

`endif
