`ifndef UARTRXMONITORPROXY_INCLUDED_
`define UARTRXMONITORPROXY_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: UartRxMonitorProxy
// This is the Receiver proxy monitor on the HVL side
//--------------------------------------------------------------------------------------------

class UartRxMonitorProxy extends uvm_monitor;
  `uvm_component_utils(UartRxMonitorProxy)

  // Variable:  uartRxMonitorBfm
  // Handle for receiver monitor bfm
  virtual UartRxMonitorBfm uartRxMonitorBfm;

  //Declaring Monitor Analysis Import
  uvm_analysis_port#(UartRxTransaction) uartRxMonitorAnalysisPort;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function  new( string name = "UartRxMonitorProxy" , uvm_component parent = null);
  extern virtual function void build_phase( uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass : UartRxMonitorProxy

  
//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
// name - UartRxMonitorProxy
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function  UartRxMonitorProxy :: new( string name = "UartRxMonitorProxy" , uvm_component parent = null);
  super.new(name,parent);
  uartRxMonitorAnalysisPort = new("uartRxMonitorAnalysisPort",this);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// uartRxMonitorBfm configuration is obtained in build_phase
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartRxMonitorProxy :: build_phase( uvm_phase phase);
  super.build_phase(phase);
  if(!(uvm_config_db #(virtual UartRxMonitorBfm) :: get(this, "" , "uartRxMonitorBfm",uartRxMonitorBfm))) begin 
    `uvm_fatal(get_type_name(),$sformatf("FAILED TO GET VIRTUAL BFM HANDLE "))
  end 
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// <Description_here>
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
    
task UartRxMonitorProxy :: run_phase(uvm_phase phase);
  UartRxTransaction uartRxTransaction;
  `uvm_info(get_type_name(), $sformatf("Inside the RX_monitor_proxy"), UVM_LOW);
  uartRxTransaction = UartRxTransaction::type_id::create("uartRxTransaction");
  	
endtask : run_phase
`endif
