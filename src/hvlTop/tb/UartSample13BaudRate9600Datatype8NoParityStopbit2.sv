`ifndef UARTSAMPLE13BAUDRATE9600DATATYPE8NOPARITYSTOPBIT2_INCLUDED_
`define UartSample13BaudRate9600Datatype8NoParityStopbit2_INCLUDED_
//--------------------------------------------------------------------------------------------
// Class:UartSample13BaudRate9600Datatype8NoParityStopbit2
// A test for 13 sampling condition
//--------------------------------------------------------------------------------------------
class UartSample13BaudRate9600Datatype8NoParityStopbit2 extends UartBaseTest;
  `uvm_component_utils(UartSample13BaudRate9600Datatype8NoParityStopbit2)
    UartVirtualBaseSequence uartVirtualBaseSequence;
    //-------------------------------------------------------
    // Externally defined Tasks and Functions
    //-------------------------------------------------------
  extern function new(string name = "UartSample13BaudRate9600Datatype8NoParityStopbit2" , uvm_component parent = null);
    extern virtual function void  build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);

endclass :UartSample13BaudRate9600Datatype8NoParityStopbit2
//--------------------------------------------------------------------------------------------
// Constructor:new
//
// Paramters:
//
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartSample13BaudRate9600Datatype8NoParityStopbit2:: new(string name = "UartSample13BaudRate9600Datatype8NoParityStopbit2" , uvm_component parent = null);
  super.new(name,parent);
endfunction  : new
//--------------------------------------------------------------------------------------------
// Function: build_phase
//  Create required ports
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartSample13BaudRate9600Datatype8NoParityStopbit2:: build_phase(uvm_phase phase);
  super.build_phase(phase);
  uartEnvConfig.uartTxAgentConfig.uartOverSamplingMethod =OVERSAMPLING_13;
  uartEnvConfig.uartTxAgentConfig.uartBaudRate = BAUD_9600;
  uartEnvConfig.uartTxAgentConfig.uartDataType = EIGHT_BIT;
  uartEnvConfig.uartTxAgentConfig.uartStopBit = TWO_BIT;
  uartEnvConfig.uartTxAgentConfig.hasParity=PARITY_DISABLED;

     uartEnvConfig.uartRxAgentConfig.uartOverSamplingMethod =OVERSAMPLING_13;
  uartEnvConfig.uartRxAgentConfig.uartBaudRate = BAUD_9600;
  uartEnvConfig.uartRxAgentConfig.uartDataType = EIGHT_BIT;
  uartEnvConfig.uartRxAgentConfig.uartStopBit = TWO_BIT;
  uartEnvConfig.uartRxAgentConfig.hasParity=PARITY_DISABLED;

endfunction  : build_phase

//--------------------------------------------------------------------------------------------
// task:body
// Creates the required ports
//
// Parameters:
// phase - stores the current phase
//------------------------------------------------------------------------------------------
task UartSample13BaudRate9600Datatype8NoParityStopbit2:: run_phase(uvm_phase phase);
  super.run_phase(phase);
  endtask : run_phase
`endif
