`ifndef UARTTXMONITORPROXY_INCLUDED_
`define UARTTXMONITORPROXY_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: device0_monitor_proxy
//--------------------------------------------------------------------------------------------
class UartTxMonitorProxy extends uvm_monitor;
   //register with factory so can use create uvm_method and
   //override in future if necessary
  `uvm_component_utils(UartTxMonitorProxy)
 
  virtual UartTxMonitorBfm uartTxMonitorBfm;
  //declaring analysis port for the monitor port
  uvm_analysis_port#(UartTxTransaction) uartTxMonitorAnalysisPort;
  
//-------------------------------------------------------
// Externally defined Tasks and Functions
//-------------------------------------------------------
  
  extern function  new( string name = "UartTxMonitorProxy" , uvm_component parent = null);
  extern virtual function void build_phase( uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass : UartTxMonitorProxy
//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
// name - UartTxMonitorProxy
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function  UartTxMonitorProxy :: new( string name = "UartTxMonitorProxy" , uvm_component parent = null);
  super.new(name,parent);
  uartTxMonitorAnalysisPort = new("uartTxMonitorAnalysisPort",this);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: build_phase
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartTxMonitorProxy :: build_phase( uvm_phase phase);
  super.build_phase(phase);

  if(!(uvm_config_db #(virtual UartTxMonitorBfm) :: get(this, "" , "uartTxMonitorBfm",uartTxMonitorBfm)))
   begin 
    `uvm_fatal(get_type_name(),$sformatf("FAILED TO GET VIRTUAL BFM HANDLE "))
   end 
endfunction : build_phase
    
//--------------------------------------------------------------------------------------------
// Task: run_phase
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task UartTxMonitorProxy :: run_phase(uvm_phase phase);
  UartTxTransaction uartTxTransaction;
 
  `uvm_info(get_type_name(), $sformatf("Inside the TX_monitor_proxy"), UVM_LOW);
endtask : run_phase
`endif
 
