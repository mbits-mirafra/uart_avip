
`ifndef UARTRXAGENT_INCLUDED_
`define UARTRXAGENT_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: UartRxAgent 
// This agent has sequencer, driver_proxy, monitor_proxy for UART
//-------------------------------------------------------------------------------------------
class UartRxAgent extends uvm_component;
  `uvm_component_utils(UartRxAgent)
  
  // Variable: uartRxAgentConfig;
  // Handle for Receiver agent configuration
  UartRxAgentConfig uartRxAgentConfig;

  // Variable: uartRxDriverProxy;
  // Handle for Receiver driver_proxy
  UartRxDriverProxy uartRxDriverProxy;

  // Variable: uartRxMonitorProxy;
  // Handle for  Receiver monitor_proxy
  UartRxMonitorProxy uartRxMonitorProxy;

  // Variable: uartRxCoverage;
  // Handle for  Receiver coverage
  UartRxCoverage uartRxCoverage;

  // Variable: uartRxSequencer;
  // Handle for  Receiver sequencer
  UartRxSequencer uartRxSequencer;

  //Variable: uartRxAgentAnalysisPort
  // Handle for Agent Analysis Port
  uvm_analysis_port #(UartRxTransaction) uartRxAgentAnalysisPort;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new( string name = "UartRxAgent", uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : UartRxAgent

//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes the UartRxAgent class object
//
// Parameters:
//  name - instance name of the  UartRxAgent
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartRxAgent :: new( string name = "UartRxAgent" , uvm_component parent = null);
  super.new(name,parent);
endfunction  : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// Creates the required ports, gets the required configuration from config_db
//
// Parameters:
//  phase - stores the current phase
//--------------------------------------------------------------------------------------------
function void UartRxAgent :: build_phase( uvm_phase phase);
  super.build_phase(phase);

  if(!(uvm_config_db #(UartRxAgentConfig) :: get(this , "", "uartRxAgentConfig",uartRxAgentConfig)))
    `uvm_fatal(get_type_name(),$sformatf("FAILED TO OBTAIN AGENT CONFIG"))

  if(uartRxAgentConfig.is_active == UVM_ACTIVE) begin 
    uartRxDriverProxy = UartRxDriverProxy :: type_id :: create("uartRxDriverProxy",this);
    uartRxSequencer = UartRxSequencer :: type_id :: create("uartRxSequencer",this);
  end 
 
  if(uartRxAgentConfig.hasCoverage == 1) begin
    uartRxCoverage = UartRxCoverage :: type_id :: create("uartRxCoverage",this);
  end 
  uartRxAgentAnalysisPort = new("uartRxAgentAnalysisPort",this);
  
  uartRxMonitorProxy = UartRxMonitorProxy :: type_id :: create("uartRxMonitorProxy",this);
endfunction : build_phase

    
//--------------------------------------------------------------------------------------------
// Function: connect_phase
// Description: it connects the components using TLM ports
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
    
function void UartRxAgent :: connect_phase( uvm_phase phase);
  super.connect_phase(phase);
  if(uartRxAgentConfig.is_active==UVM_ACTIVE) begin
    uartRxDriverProxy.seq_item_port.connect(uartRxSequencer.seq_item_export);
  end
  
  if(uartRxAgentConfig.hasCoverage == 1) begin 
    uartRxMonitorProxy.uartRxMonitorAnalysisPort.connect(uartRxCoverage.analysis_export);
  end
  
  uartRxMonitorProxy.uartRxMonitorAnalysisPort.connect(uartRxAgentAnalysisPort);
endfunction : connect_phase

`endif
