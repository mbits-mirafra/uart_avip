`ifndef UARTBAUDRATE19200WITHBREAKINGERRORTEST_INCLUDED_
`define UARTBAUDRATE19200WITHBREAKINGERRORTEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class:  UartBaudRate19200WithBreakingErrorTest
// Base test has the test scenarios for testbench which has the env, config, etc.
// Sequences are created and started in the test
//--------------------------------------------------------------------------------------------
class UartBaudRate19200WithBreakingErrorTest extends UartBaseTest;

  `uvm_component_utils(UartBaudRate19200WithBreakingErrorTest)

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "UartBaudRate19200WithBreakingErrorTest" , uvm_component parent = null);
  extern virtual function void  build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task copyTxConfigToRx(inout UartTxAgentConfig uartTxAgentConfig ,inout  UartRxAgentConfig uartRxAgentConfig);
endclass : UartBaudRate19200WithBreakingErrorTest

//--------------------------------------------------------------------------------------------
// Constructor:new
//
// Paramters:
//
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartBaudRate19200WithBreakingErrorTest :: new(string name = "UartBaudRate19200WithBreakingErrorTest" , uvm_component parent = null);
  super.new(name,parent);
endfunction  : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
//  Create required ports
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartBaudRate19200WithBreakingErrorTest :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  uartEnvConfig.uartTxAgentConfig.uartBaudRate = BAUD_19200;
endfunction  : build_phase


 task UartBaudRate19200WithBreakingErrorTest :: run_phase(uvm_phase phase);
  uartVirtualTransmissionSequenceWithPattern = UartVirtualTransmissionSequenceWithPattern :: type_id :: create("uartVirtualTransmissionSequenceWithPattern");

  phase.raise_objection(this);
  repeat(uartEnvConfig.uartTxAgentConfig.packetsNeeded) begin

  if(uartEnvConfig.uartTxAgentConfig.randomize() with{breakingErrorInjection==1;})
  uartVirtualTransmissionSequenceWithPattern.setConfig(uartEnvConfig.uartTxAgentConfig);
  copyTxConfigToRx(uartEnvConfig.uartTxAgentConfig , uartEnvConfig.uartRxAgentConfig);

  uartVirtualTransmissionSequenceWithPattern.start(uartEnv.uartVirtualSequencer);
  end
  phase.drop_objection(this);
endtask : run_phase

task UartBaudRate19200WithBreakingErrorTest :: copyTxConfigToRx(inout UartTxAgentConfig uartTxAgentConfig ,inout  UartRxAgentConfig uartRxAgentConfig);
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
