`ifndef UARTENVCONFIG_INCLUDED_
`define UARTENVCONFIG_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: UartEnvConfig
// This class is used as configuration class for Uart_environment and its components
//--------------------------------------------------------------------------------------------
class UartEnvConfig extends uvm_object;
  `uvm_object_utils(UartEnvConfig)

  //Variable: hasVirtualSequencer
  //Enables the virtual sequencer
  bit hasVirtualSequencer;

  //Variable: hasScoreboard
  //Enables the scoreboard
  bit hasScoreboard;

  //Variable: uartTxAgentConfig;
  //Handle for Tx configuration
  UartTxAgentConfig uartTxAgentConfig;

  //Variable: uartRxAgentConfig;
  //Handle for Rx configuration 
  UartRxAgentConfig uartRxAgentConfig;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "UartEnvConfig");
 
 endclass : UartEnvConfig

//--------------------------------------------------------------------------------------------
// Construct: new
//  Initialization of new memory
//  name - UartEnvConfig
//--------------------------------------------------------------------------------------------
 function UartEnvConfig :: new(string name = "UartEnvConfig");
   super.new(name);
 endfunction : new

`endif
