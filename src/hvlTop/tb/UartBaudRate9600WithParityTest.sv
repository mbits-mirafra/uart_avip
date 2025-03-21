`ifndef UARTBAUDRATE9600WITHPARITYTEST_INCLUDED_
`define UARTBAUDRATE9600WITHPARITYTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class:  UartBaudRate9600WithParityTest
// Base test has the test scenarios for testbench which has the env, config, etc.
// Sequences are created and started in the test
//--------------------------------------------------------------------------------------------
class UartBaudRate9600WithParityTest extends UartBaseTest;

  `uvm_component_utils(UartBaudRate9600WithParityTest)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "UartBaudRate9600WithParityTest" , uvm_component parent = null);
  extern virtual function void  build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task copyTxConfigToRx(inout UartTxAgentConfig uartTxAgentConfig ,inout  UartRxAgentConfig uartRxAgentConfig);
endclass : UartBaudRate9600WithParityTest

//--------------------------------------------------------------------------------------------
// Constructor:new
//
// Paramters:
//
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartBaudRate9600WithParityTest :: new(string name = "UartBaudRate9600WithParityTest" , uvm_component parent = null);
  super.new(name,parent);
endfunction  : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
//  Create required ports
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartBaudRate9600WithParityTest :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  uartEnvConfig.uartTxAgentConfig.uartBaudRate = BAUD_9600;
endfunction  : build_phase


 task UartBaudRate9600WithParityTest :: run_phase(uvm_phase phase);
  uartVirtualTransmissionSequence= UartVirtualTransmissionSequence :: type_id :: create("uartVirtualTransmissionSequence");

  phase.raise_objection(this);
  repeat(uartEnvConfig.uartTxAgentConfig.packetsNeeded) begin

  if(uartEnvConfig.uartTxAgentConfig.randomize() with{hasParity==1;})
  uartVirtualTransmissionSequence.setConfig(uartEnvConfig.uartTxAgentConfig);
  copyTxConfigToRx(uartEnvConfig.uartTxAgentConfig , uartEnvConfig.uartRxAgentConfig);

  uartVirtualTransmissionSequence.start(uartEnv.uartVirtualSequencer);
  end
  phase.drop_objection(this);
endtask : run_phase

task UartBaudRate9600WithParityTest :: copyTxConfigToRx(inout UartTxAgentConfig uartTxAgentConfig ,inout  UartRxAgentConfig uartRxAgentConfig);
       uartRxAgentConfig.hasParity =   uartTxAgentConfig.hasParity;
       uartRxAgentConfig.uartOverSamplingMethod =   uartTxAgentConfig.uartOverSamplingMethod;
       uartRxAgentConfig.uartBaudRate =   uartTxAgentConfig.uartBaudRate;
       uartRxAgentConfig.uartDataType =   uartTxAgentConfig.uartDataType;
       uartRxAgentConfig.uartParityType =  uartTxAgentConfig.uartParityType;
       uartRxAgentConfig.parityErrorInjection =  uartTxAgentConfig.parityErrorInjection;
       uartRxAgentConfig.framingErrorInjection =  uartTxAgentConfig.framingErrorInjection;
       uartRxAgentConfig.breakingErrorInjection =  uartTxAgentConfig.breakingErrorInjection;
       uartRxAgentConfig.uartStopBit =  uartTxAgentConfig.uartStopBit;

endtask

`endif
