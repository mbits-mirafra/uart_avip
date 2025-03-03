`ifndef UARTSAMPLE16BAUDRATE4800DATATYPE7ODDPARITYSTOPBIT1_INCLUDED_
`define UARTSAMPLE16BAUDRATE4800DATATYPE7ODDPARITYSTOPBIT1_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: UartSample16BaudRate4800Datatype7OddParityStopbit1
// Base test has the test scenarios for testbench which has the env, config, etc.
// Sequences are created and started in the test
//--------------------------------------------------------------------------------------------
class UartSample16BaudRate4800Datatype7OddParityStopbit1 extends UartBaseTest;
 
  `uvm_component_utils(UartSample16BaudRate4800Datatype7OddParityStopbit1)
 
  UartVirtualBaseSequence uartVirtualBaseSequence;
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "UartSample16BaudRate4800Datatype7OddParityStopbit1" , uvm_component parent = null);
  extern virtual function void  build_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : UartSample16BaudRate4800Datatype7OddParityStopbit1
   
//--------------------------------------------------------------------------------------------
// Constructor:new
//
// Paramters:
//
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartSample16BaudRate4800Datatype7OddParityStopbit1 :: new(string name = "UartSample16BaudRate4800Datatype7OddParityStopbit1" , uvm_component parent = null);
  super.new(name,parent);
endfunction  : new
   
//--------------------------------------------------------------------------------------------
// Function: build_phase
//  Create required ports
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartSample16BaudRate4800Datatype7OddParityStopbit1 :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  uartEnvConfig.uartTxAgentConfig.uartOverSamplingMethod = OVERSAMPLING_16;
  uartEnvConfig.uartTxAgentConfig.uartBaudRate =   BAUD_4800;
  uartEnvConfig.uartTxAgentConfig.uartDataType = SEVEN_BIT;
  uartEnvConfig.uartTxAgentConfig.uartParityType = ODD_PARITY;
  uartEnvConfig.uartTxAgentConfig.uartStopBit = ONE_BIT;
  uartEnvConfig.uartTxAgentConfig.hasParity = PARITY_ENABLED;

  uartEnvConfig.uartRxAgentConfig.uartOverSamplingMethod = OVERSAMPLING_16;
  uartEnvConfig.uartRxAgentConfig.uartBaudRate =   BAUD_4800;
  uartEnvConfig.uartRxAgentConfig.uartDataType = SEVEN_BIT;
  uartEnvConfig.uartRxAgentConfig.uartParityType = ODD_PARITY;
  uartEnvConfig.uartRxAgentConfig.uartStopBit = ONE_BIT;
  uartEnvConfig.uartRxAgentConfig.hasParity = PARITY_ENABLED;
endfunction  : build_phase
   
   
//--------------------------------------------------------------------------------------------
// task:body
// Creates the required ports
//
// Parameters:
// phase - stores the current phase
//--------------------------------------------------------------------------------------------
 task UartSample16BaudRate4800Datatype7OddParityStopbit1 :: run_phase(uvm_phase phase);
    super.run_phase(phase);
endtask : run_phase

`endif  
