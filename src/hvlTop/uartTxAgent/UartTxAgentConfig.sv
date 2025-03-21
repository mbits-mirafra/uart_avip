`ifndef UARTTXAGENTCONFIG_INCLUDED_
`define UARTTXAGENTCONFIG_INCLUDED_
//--------------------------------------------------------------------------------------------
// Class: UartTxAgentConfig 
// Used as the configuration class for device0 agent and it's components
//--------------------------------------------------------------------------------------------
class UartTxAgentConfig extends uvm_object;
  `uvm_object_utils(UartTxAgentConfig)

  // Variable: is_active
  // Used for creating the agent in either passive or active mode
  uvm_active_passive_enum is_active;

  // config variables required for transmitting data
  bit hasCoverage;
  int packetsNeeded;
  logic[DATA_WIDTH-1:0]patternToTransmit;
  baudRateEnum uartBaudRate;
  bit patternNeeded;
  bit OverSampledBaudFrequencyClk;  
  rand hasParityEnum hasParity;
  rand overSamplingEnum uartOverSamplingMethod;
  rand dataTypeEnum uartDataType;
  rand parityTypeEnum uartParityType;
  rand stopBitEnum uartStopBit;
  rand bit parityErrorInjection;
  rand bit framingErrorInjection;
  rand bit breakingErrorInjection;

 constraint set_parity_condition{ hasParity==PARITY_DISABLED -> parityErrorInjection==0;}
 //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "UartTxAgentConfig");

endclass : UartTxAgentConfig

//--------------------------------------------------------------------------------------------
// Construct: new
// name - UartTxAgentConfig 
//--------------------------------------------------------------------------------------------
function UartTxAgentConfig :: new(string name = "UartTxAgentConfig");
  super.new(name);
endfunction : new

`endif
