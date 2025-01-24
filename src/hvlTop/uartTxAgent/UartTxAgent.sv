`ifndef UARTTXAGENT_INCLUDED_
`define UARTTXAGENT_INCLUDED_
//--------------------------------------------------------------------------------------------
// Class: UartTxAgent
// This agent is a configurable with respect to configuration which can create active and passive components
// It contains testbench components like sequencer,driver_proxy and monitor_proxy for UART
// --------------------------------------------------------------------------------------------
class UartTxAgent extends uvm_component;
  `uvm_component_utils(UartTxAgent)
  // Variable: uartTxAgentConfig
  // Declaring handle for uart transmitter agent config class 
  UartTxAgentConfig uartTxAgentConfig;

  // Variable: uartTxDriverProxy
  // Declaring handle for uart driver proxy 
  UartTxDriverProxy uartTxDriverProxy;

  // Variable: uartTxMonitorProxy
  // Declaring handle for uart monitor proxy 
  UartTxMonitorProxy uartTxMonitorProxy;

  // Variable: uartTxCoverage
  // Declaring handle for uart coverage
  UartTxCoverage uartTxCoverage;

  // Variable:  uartTxSequencer
  // Declaring handle for uart sequencer
  UartTxSequencer uartTxSequencer;

  //Analysis port
  uvm_analysis_port #(UartTxTransaction) uartTxAgentAnalysisPort;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new( string name = "UartTxAgent",uvm_component parent = null);
  extern virtual function void  build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : UartTxAgent

//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters: 
// name - instance name of the UartTxAgent
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartTxAgent :: new( string name = "UartTxAgent" , uvm_component parent = null);
  super.new(name,parent);
endfunction  : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// creates the required ports,gets the required configuration from config_db
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartTxAgent :: build_phase( uvm_phase phase);
  super.build_phase(phase);

  if(!(uvm_config_db #(UartTxAgentConfig) :: get(this , "", "uartTxAgentConfig",uartTxAgentConfig)))
    `uvm_fatal(get_type_name(),$sformatf("FAILED TO OBTAIN AGENT CONFIG"))

  uartTxMonitorProxy = UartTxMonitorProxy :: type_id :: create("uartTxMonitorProxy",this);
  if(uartTxAgentConfig.is_active == UVM_ACTIVE)
    begin 
      uartTxDriverProxy = UartTxDriverProxy :: type_id :: create("uartTxDriverProxy",this);
      uartTxSequencer = UartTxSequencer :: type_id :: create("uartTxSequencer",this);
    end 
  
  if(uartTxAgentConfig.hasCoverage == 1)
    uartTxCoverage = UartTxCoverage :: type_id :: create("uartTxCoverage",this);
  
  uartTxAgentAnalysisPort = new("uartTxAgentAnalysisPort",this);
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: connect_phase
// Connecting device0_driver, device0_monitor and device0_sequencer for configuration
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartTxAgent :: connect_phase( uvm_phase phase);
  super.connect_phase(phase);
  if(uartTxAgentConfig.is_active==UVM_ACTIVE)
   begin 
     uartTxDriverProxy.seq_item_port.connect(uartTxSequencer.seq_item_export);
   end
  if(uartTxAgentConfig.hasCoverage == 1)
    begin 
      uartTxMonitorProxy.uartTxMonitorAnalysisPort.connect(uartTxCoverage.analysis_export);
    end 
  uartTxMonitorProxy.uartTxMonitorAnalysisPort.connect(this.uartTxAgentAnalysisPort);
endfunction : connect_phase

`endif

