
`ifndef UARTRXSEQUENCER_INCLUDED_
`define UARTRXSEQUENCER_INCLUDED_
//--------------------------------------------------------------------------------------------
// Class:  UartRxSequencer 
// It send transactions to driver via tlm ports
//--------------------------------------------------------------------------------------------
class UartRxSequencer extends uvm_sequencer#(UartRxTransaction);
  `uvm_component_utils(UartRxSequencer)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name="UartRxSequencer", uvm_component parent = null);
endclass : UartRxSequencer

//--------------------------------------------------------------------------------------------
// Construct: new
//  UartRxSequencer class object is initialized
//
// Parameters:
// name -  UartRxSequencer
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartRxSequencer :: new(string name = "UartRxSequencer" , uvm_component parent = null);
  super.new(name,parent);
endfunction : new

`endif
