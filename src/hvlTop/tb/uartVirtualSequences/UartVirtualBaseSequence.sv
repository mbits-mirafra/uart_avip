`ifndef UARTVIRTUALBASESEQUENCE_INCLUDED_
`define UARTVIRTUALBASESEQUENCE_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class:UartVirtualBaseSequence
//--------------------------------------------------------------------------------------------
class UartVirtualBaseSequence extends uvm_sequence;
  `uvm_object_utils(UartVirtualBaseSequence)
  `uvm_declare_p_sequencer(UartVirtualSequencer)
 
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "UartVirtualBaseSequence");
  extern virtual task body();

endclass : UartVirtualBaseSequence

//--------------------------------------------------------------------------------------------
// Constructor:new
//
// Paramters:
// name - Instance name of the virtual_sequence
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
  
function UartVirtualBaseSequence :: new(string name = "UartVirtualBaseSequence" );
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// task:body
// Creates the required ports
//
// Parameters:
// phase - stores the current phase
//--------------------------------------------------------------------------------------------
task UartVirtualBaseSequence :: body();
  //super.body();

  if( !($cast(p_sequencer , m_sequencer)))
    `uvm_error(get_type_name(),"FAILED TO CASTE TO SEQUENCER SUBPOINTER");

endtask : body

`endif

