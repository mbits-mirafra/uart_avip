`ifndef UARTEVENPARITYTEST_INCLUDED_
`define UARTEVENPARITYTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class:  UartBaseTest
// Base test has the test scenarios for testbench which has the env, config, etc.
// Sequences are created and started in the test
//--------------------------------------------------------------------------------------------
class UartEvenParityTest extends UartBaseTest;
 
  `uvm_component_utils(UartEvenParityTest)
 
  UartVirtualBaseSequence uartVirtualBaseSequence;
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "UartEvenParityTest" , uvm_component parent = null);
  extern virtual function void  build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : UartEvenParityTest
   
//--------------------------------------------------------------------------------------------
// Constructor:new
//
// Paramters:
//
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartEvenParityTest :: new(string name = "UartEvenParityTest" , uvm_component parent = null);
  super.new(name,parent);
endfunction  : new
   
//--------------------------------------------------------------------------------------------
// Function: build_phase
//  Create required ports
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartEvenParityTest :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  //need to write
endfunction  : build_phase
   
   
//--------------------------------------------------------------------------------------------
// task:body
// Creates the required ports
//
// Parameters:
// phase - stores the current phase
//--------------------------------------------------------------------------------------------
 task UartEvenParityTest :: run_phase(uvm_phase phase);
    super.run_phase(phase);
endtask : run_phase

`endif  

