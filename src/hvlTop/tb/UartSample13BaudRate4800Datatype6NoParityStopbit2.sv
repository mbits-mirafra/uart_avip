`ifndef UARTSAMPLE13BAUDRATE4800DATATYPE6NOPARITYSTOPBIT2_INCLUDED_
`define UARTSAMPLE13BAUDRATE4800DATATYPE6NOPARITYSTOPBIT2_INCLUDED_
//--------------------------------------------------------------------------------------------
// Class:UartSample13BaudRate4800Datatype6NoParityStopbit2
// A test for 13 sampling condition
//--------------------------------------------------------------------------------------------
class UartSample13BaudRate4800Datatype6NoParityStopbit2 extends UartBaseTest;
 `uvm_component_utils( UartSample13BaudRate4800Datatype6NoParityStopbit2)
    UartVirtualBaseSequence uartVirtualBaseSequence;
 //-------------------------------------------------------
 // Externally defined Tasks and Functions
 //-------------------------------------------------------
    extern function new(string name = "UartSample13BaudRate4800Datatype6NoParityStopbit2" , uvm_component parent = null);
    extern virtual function void  build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);

endclass :UartSample13BaudRate4800Datatype6NoParityStopbit2
//--------------------------------------------------------------------------------------------
// Constructor:new
//
// Paramters:
//
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartSample13BaudRate4800Datatype6NoParityStopbit2:: new(string name ="UartSample13BaudRate4800Datatype6NoParityStopbit2" , uvm_component parent = null);
  super.new(name,parent);
endfunction  : new
//--------------------------------------------------------------------------------------------
// Function: build_phase
//  Create required ports
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartSample13BaudRate4800Datatype6NoParityStopbit2 :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  uartEnvConfig.uartTxAgentConfig.uartOverSamplingMethod =OVERSAMPLING_13;
  uartEnvConfig.uartTxAgentConfig.uartBaudRate = BAUD_4800;
  uartEnvConfig.uartTxAgentConfig.uartDataType = SIX_BIT;
  uartEnvConfig.uartTxAgentConfig.uartStopBit = TWO_BIT;
  uartEnvConfig.uartTxAgentConfig.hasParity=PARITY_DISABLED;

  uartEnvConfig.uartRxAgentConfig.uartOverSamplingMethod =OVERSAMPLING_13;
  uartEnvConfig.uartRxAgentConfig.uartBaudRate = BAUD_4800;
  uartEnvConfig.uartRxAgentConfig.uartDataType = SIX_BIT;
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
task UartSample13BaudRate4800Datatype6NoParityStopbit2:: run_phase(uvm_phase phase);
  super.run_phase(phase);
 endtask : run_phase
`endif
