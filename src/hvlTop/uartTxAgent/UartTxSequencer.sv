`ifndef UARTTXSEQUENCER_INCLUDED_
`define UARTTXSEQUENCER_INCLUDED_
//--------------------------------------------------------------------------------------------
 // Class:  UartTxSequencer
 //--------------------------------------------------------------------------------------------
class UartTxSequencer extends uvm_sequencer#(UartTxTransaction);
  `uvm_component_utils(UartTxSequencer)
 
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name="UartTxSequencer",uvm_component parent = null);
endclass : UartTxSequencer
   
//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes memory for new object
// Parameters:
// name - UartTxSequencer
//--------------------------------------------------------------------------------------------
function UartTxSequencer :: new(string name = "UartTxSequencer" , uvm_component parent = null);
  super.new(name,parent);
endfunction : new

`endif
