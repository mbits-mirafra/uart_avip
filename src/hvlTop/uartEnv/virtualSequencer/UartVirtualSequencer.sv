`ifndef UARTVIRTUALSEQUENCER_INCLUDED_
`define UARTVIRTUALSEQUENCER_INLCUDED_
//--------------------------------------------------------------------------------------------
// Class: UartVirtualSequencer
//--------------------------------------------------------------------------------------------
class UartVirtualSequencer extends uvm_sequencer;
  `uvm_component_utils(UartVirtualSequencer)
  
  UartTxSequencer uartTxSequencer;
  UartRxSequencer uartRxSequencer;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new( string name = "UartVirtualSequencer" , uvm_component parent = null);

endclass : UartVirtualSequencer
    
//--------------------------------------------------------------------------------------------
// Construct: new
//  name - instance name of the  virtual_sequencer
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartVirtualSequencer :: new(string name = "UartVirtualSequencer" , uvm_component parent = null);
  super.new(name,parent);
endfunction : new

`endif
 
