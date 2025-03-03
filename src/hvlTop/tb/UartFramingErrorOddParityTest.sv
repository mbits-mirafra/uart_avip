
`ifndef UARTFRAMINGERRORODDPARITYTEST_INCLUDED_
`define UARTFRAMINGERRORODDPARITYTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: UartFramingErrorOddParityTest
// Base test has the test scenarios for testbench which has the env, config, etc.
// Sequences are created and started in the test
//--------------------------------------------------------------------------------------------
class UartFramingErrorOddParityTest extends UartBaseTest;
 
  `uvm_component_utils(UartFramingErrorOddParityTest)
 
  UartVirtualBaseSequence uartVirtualBaseSequence;
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "UartFramingErrorOddParityTest" , uvm_component parent = null);
  extern virtual function void  build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : UartFramingErrorOddParityTest
   
//--------------------------------------------------------------------------------------------
// Constructor:new
//
// Paramters:
//
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartFramingErrorOddParityTest :: new(string name = "UartFramingErrorOddParityTest" , uvm_component parent = null);
  super.new(name,parent);
endfunction  : new
   
//--------------------------------------------------------------------------------------------
// Function: build_phase
//  Create required ports
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartFramingErrorOddParityTest :: build_phase(uvm_phase phase);
  super.build_phase(phase);
// uartEnvConfig.uartTxAgentConfig.uartOverSamplingMethod = OVERSAMPLING_16;
// uartEnvConfig.uartTxAgentConfig.uartBaudRate =   BAUD_19200;
// uartEnvConfig.uartTxAgentConfig.uartDataType = SEVEN_BIT;
   uartEnvConfig.uartTxAgentConfig.uartParityType =  ODD_PARITY;
// uartEnvConfig.uartTxAgentConfig.uartStopBit = ONE_BIT;
  uartEnvConfig.uartTxAgentConfig.hasParity = PARITY_ENABLED;
  uartEnvConfig.uartTxAgentConfig.framingErrorInjection = 1;

//  uartEnvConfig.uartRxAgentConfig.uartOverSamplingMethod = OVERSAMPLING_16;
//  uartEnvConfig.uartRxAgentConfig.uartBaudRate =   BAUD_19200;
//  uartEnvConfig.uartRxAgentConfig.uartDataType = SEVEN_BIT;
  uartEnvConfig.uartRxAgentConfig.uartParityType = ODD_PARITY;
//  uartEnvConfig.uartRxAgentConfig.uartStopBit = ONE_BIT;
  uartEnvConfig.uartRxAgentConfig.hasParity = PARITY_ENABLED;
  uartEnvConfig.uartRxAgentConfig.framingErrorInjection = 1;

endfunction  : build_phase
   
   
//--------------------------------------------------------------------------------------------
// task:body
// Creates the required ports
//
// Parameters:
// phase - stores the current phase
//--------------------------------------------------------------------------------------------
 task UartFramingErrorOddParityTest :: run_phase(uvm_phase phase);
    super.run_phase(phase);
endtask : run_phase

`endif  
