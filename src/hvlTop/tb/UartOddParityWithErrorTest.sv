`ifndef UARTODDPARITYWITHERRORTEST_INCLUDED_
`define UARTODDPARITYWITHERRORTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class:  UartBaseTest
// Base test has the test scenarios for testbench which has the env, config, etc.
// Sequences are created and started in the test
//--------------------------------------------------------------------------------------------
class UartOddParityWithErrorTest extends UartBaseTest;
 
   `uvm_component_utils(UartOddParityWithErrorTest)
    
    UartVirtualBaseSequence uartVirtualBaseSequence;
    //-------------------------------------------------------
    // Externally defined Tasks and Functions
    //-------------------------------------------------------
    extern function new(string name = "UartOddParityWithErrorTest" , uvm_component parent = null);
    extern virtual function void  build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);

endclass : UartOddParityWithErrorTest
		     
//--------------------------------------------------------------------------------------------
// Constructor:new
//
// Paramters:
//
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartOddParityWithErrorTest :: new(string name = "UartOddParityWithErrorTest" , uvm_component parent = null);
  super.new(name,parent);
endfunction  : new
		          
//--------------------------------------------------------------------------------------------
// Function: build_phase
//  Create required ports
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartOddParityWithErrorTest :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  uartEnvConfig.uartTxAgentConfig.hasParity = PARITY_ENABLED;
  uartEnvConfig.uartTxAgentConfig.uartParityType = ODD_PARITY;
	uartEnvConfig.uartRxAgentConfig.uartParityType = ODD_PARITY;
  uartEnvConfig.uartTxAgentConfig.parityErrorInjection =1;
	uartEnvConfig.uartRxAgentConfig.parityErrorInjection =1;

endfunction  : build_phase
			         
				    
//--------------------------------------------------------------------------------------------
// task:body
// Creates the required ports
//
// Parameters:
// phase - stores the current phase
//------------------------------------------------------------------------------------------
task UartOddParityWithErrorTest:: run_phase(uvm_phase phase);
	super.run_phase(phase);
  endtask : run_phase
`endif  
