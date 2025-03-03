
`ifndef UARTFRAMINGERRORNOPARITYTEST_INCLUDED_
`define UARTFRAMINGERRORNOPARITYTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: UartFramingErrorNoParityTest
// Base test has the test scenarios for testbench which has the env, config, etc.
// Sequences are created and started in the test
//--------------------------------------------------------------------------------------------
class UartFramingErrorNoParityTest extends UartBaseTest;
 
  `uvm_component_utils(UartFramingErrorNoParityTest)
 
  UartVirtualBaseSequence uartVirtualBaseSequence;
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "UartFramingErrorNoParityTest" , uvm_component parent = null);
  extern virtual function void  build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : UartFramingErrorNoParityTest
   
//--------------------------------------------------------------------------------------------
// Constructor:new
//
// Paramters:
//
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartFramingErrorNoParityTest :: new(string name = "UartFramingErrorNoParityTest" , uvm_component parent = null);
  super.new(name,parent);
endfunction  : new
   
//--------------------------------------------------------------------------------------------
// Function: build_phase
//  Create required ports
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartFramingErrorNoParityTest :: build_phase(uvm_phase phase);
  super.build_phase(phase);
// uartEnvConfig.uartTxAgentConfig.uartOverSamplingMethod = OVERSAMPLING_16;
// uartEnvConfig.uartTxAgentConfig.uartBaudRate =   BAUD_19200;
// uartEnvConfig.uartTxAgentConfig.uartDataType = SEVEN_BIT;
// uartEnvConfig.uartTxAgentConfig.uartStopBit = ONE_BIT;
  uartEnvConfig.uartTxAgentConfig.hasParity = PARITY_DISABLED;
  uartEnvConfig.uartTxAgentConfig.framingErrorInjection = 1;

//  uartEnvConfig.uartRxAgentConfig.uartOverSamplingMethod = OVERSAMPLING_16;
//  uartEnvConfig.uartRxAgentConfig.uartBaudRate =   BAUD_19200;
//  uartEnvConfig.uartRxAgentConfig.uartDataType = SEVEN_BIT;
//  uartEnvConfig.uartRxAgentConfig.uartStopBit = ONE_BIT;
  uartEnvConfig.uartRxAgentConfig.hasParity = PARITY_DISABLED;
  uartEnvConfig.uartRxAgentConfig.framingErrorInjection = 1;

endfunction  : build_phase
   
   
//--------------------------------------------------------------------------------------------
// task:body
// Creates the required ports
//
// Parameters:
// phase - stores the current phase
//--------------------------------------------------------------------------------------------
 task UartFramingErrorNoParityTest :: run_phase(uvm_phase phase);
    super.run_phase(phase);
endtask : run_phase

`endif  
