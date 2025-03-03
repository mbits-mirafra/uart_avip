`ifndef UARTENV_INCLUDED_
`define UARTENV_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: uart_env
// Creates transmitter (Tx) agent and reciever(Rx) agent and scoreboard
//--------------------------------------------------------------------------------------------
class UartEnv extends uvm_env;
  `uvm_component_utils(UartEnv)

  //Variable: uartVirtualSequencer
  //Declaring uart virtual sequencer handle
  UartVirtualSequencer uartVirtualSequencer;
  
  //Variable: uartTxAgent
  //Declaring uart Tx agent handle
  UartTxAgent uartTxAgent;
 
  //Variable: uartRxAgent
  //Declaring uart Rx agent handle 
  UartRxAgent uartRxAgent;

  //Variable: uartEnvConfig
  //Declaring handle for UartEnvConfig_object 
  UartEnvConfig uartEnvConfig;

  //Variable: uartScoreboard
  //Declaring uart scoreboard handle 
  UartScoreboard uartScoreboard;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function  new(string name = "UartEnv" , uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
endclass : UartEnv

//--------------------------------------------------------------------------------------------
// Construct: new
//  name - UartEnv 
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function  UartEnv :: new(string name = "UartEnv" , uvm_component parent =null);
  super.new(name,parent);
endfunction : new
    
//--------------------------------------------------------------------------------------------
// Function: build_phase
// Builds the Tx and Rx agents and scoreboard
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartEnv :: build_phase(uvm_phase phase);
  super.build_phase(phase);

  if(!(uvm_config_db #(UartEnvConfig) :: get(this,"","uartEnvConfig",this.uartEnvConfig)))
    `uvm_fatal("FATAL ENV CONFIG", $sformatf("Failed to get environment config in environment"))

  if(uartEnvConfig.hasVirtualSequencer) 
  begin 
    uartVirtualSequencer = UartVirtualSequencer :: type_id :: create("uartVirtualSequencer",this);
  end 

  if(uartEnvConfig.hasScoreboard)
  begin 
    uartScoreboard = UartScoreboard :: type_id :: create("uartScoreboard",this);
  end 

  uartTxAgent = UartTxAgent :: type_id :: create("uartTxAgent",this);
  uartRxAgent = UartRxAgent :: type_id :: create("uartRxAgent",this);
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Function: connect_phase
//  Connects the Tx agent monitor's analysis_port with scoreboard's analysis_fifo 
//  Connects the Rx agent monitor's analysis_port with scoreboard's analysis_fifo 
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartEnv ::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  uartTxAgent.uartTxAgentAnalysisPort.connect(uartScoreboard.uartScoreboardTxAnalysisExport);
  uartRxAgent.uartRxAgentAnalysisPort.connect(uartScoreboard.uartScoreboardRxAnalysisExport);

  if(uartEnvConfig.hasVirtualSequencer==1)
  begin 
   uartVirtualSequencer.uartTxSequencer = uartTxAgent.uartTxSequencer;
   uartVirtualSequencer.uartRxSequencer = uartRxAgent.uartRxSequencer;
  end 
endfunction : connect_phase

`endif
