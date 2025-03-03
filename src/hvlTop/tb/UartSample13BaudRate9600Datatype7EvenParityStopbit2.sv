`ifndef UARTSAMPLE13BAUDRATE9600DATATYPE7EVENPARITYSTOPBIT2_INCLUDED_
`define UARTSAMPLE13BAUDRATE9600DATATYPE7EVENPARITYSTOPBIT2_INCLUDED_   
//--------------------------------------------------------------------------------------------
// Class:UartSample13BaudRate9600Datatype7EvenParityStopbit2
// A test for 13 sampling condition
//--------------------------------------------------------------------------------------------
class UartSample13BaudRate9600Datatype7EvenParityStopbit2 extends UartBaseTest;
   `uvm_component_utils(UartSample13BaudRate9600Datatype7EvenParityStopbit2)
    UartVirtualBaseSequence uartVirtualBaseSequence;
    //-------------------------------------------------------
    // Externally defined Tasks and Functions
    //-------------------------------------------------------
    extern function new(string name = "UartSample13BaudRate9600Datatype7EvenParityStopbit2" , uvm_component parent = null);
    extern virtual function void  build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);
 
endclass :UartSample13BaudRate9600Datatype7EvenParityStopbit2
//--------------------------------------------------------------------------------------------
// Constructor:new
//
// Paramters:
//
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartSample13BaudRate9600Datatype7EvenParityStopbit2:: new(string name = "UartSample13BaudRate9600Datatype7EvenParityStopbit2" , uvm_component parent = null);
  super.new(name,parent);
endfunction  : new
//--------------------------------------------------------------------------------------------
// Function: build_phase
//  Create required ports
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartSample13BaudRate9600Datatype7EvenParityStopbit2 :: build_phase(uvm_phase phase);
  super.build_phase(phase);
   uartEnvConfig.uartTxAgentConfig.uartOverSamplingMethod =OVERSAMPLING_13;
  uartEnvConfig.uartTxAgentConfig.uartBaudRate = BAUD_9600;
  uartEnvConfig.uartTxAgentConfig.uartDataType = SEVEN_BIT;
  uartEnvConfig.uartTxAgentConfig.uartParityType = EVEN_PARITY;
  uartEnvConfig.uartTxAgentConfig.uartStopBit = TWO_BIT;
  uartEnvConfig.uartTxAgentConfig.hasParity = PARITY_ENABLED;

     uartEnvConfig.uartRxAgentConfig.uartOverSamplingMethod =OVERSAMPLING_13;
  uartEnvConfig.uartRxAgentConfig.uartBaudRate = BAUD_9600;
  uartEnvConfig.uartRxAgentConfig.uartDataType = SEVEN_BIT;
  uartEnvConfig.uartRxAgentConfig.uartParityType = EVEN_PARITY;
  uartEnvConfig.uartRxAgentConfig.uartStopBit = TWO_BIT;
  uartEnvConfig.uartRxAgentConfig.hasParity = PARITY_ENABLED;

 
endfunction  : build_phase

//--------------------------------------------------------------------------------------------
// task:body
// Creates the required ports
//
// Parameters:
// phase - stores the current phase
//------------------------------------------------------------------------------------------
task UartSample13BaudRate9600Datatype7EvenParityStopbit2:: run_phase(uvm_phase phase);
   super.run_phase(phase);
  endtask : run_phase
`endif 
