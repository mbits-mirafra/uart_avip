`ifndef UARTTXMONITORPROXY_INCLUDED_
`define UARTTXMONITORPROXY_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: device0_monitor_proxy
//--------------------------------------------------------------------------------------------
class UartTxMonitorProxy extends uvm_monitor;
	
  `uvm_component_utils(UartTxMonitorProxy)

	// virtual handle of transmitter monitor bfm
  virtual UartTxMonitorBfm uartTxMonitorBfm;
	
	// handles for struct packet, transaction packet and config class
  UartTxPacketStruct uartTxPacketStruct;
	UartTxTransaction uartTxTransaction;
  UartTxAgentConfig uartTxAgentConfig;

	//event for controlling run phase drop objection
  event monitorSynchronizer;
	
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
  if(!(uvm_config_db #(UartTxAgentConfig) :: get(this , "" , "uartTxAgentConfig",uartTxAgentConfig)))
   begin 
     `uvm_fatal(get_type_name(),$sformatf("FAILED TO GET AGENT CONFIG"))
   end 
   uartTxTransaction = UartTxTransaction :: type_id :: create("uartTxTransaction");
endfunction : build_phase
    
//--------------------------------------------------------------------------------------------
// Task: run_phase
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
task UartTxMonitorProxy :: run_phase(uvm_phase phase);
	UartConfigStruct uartConfigStruct;
	UartTxConfigConverter :: from_Class(uartTxAgentConfig,uartConfigStruct);
	fork 
		begin 
			uartTxMonitorBfm.GenerateBaudClk(uartConfigStruct);
		end 
		begin
		  uartTxMonitorBfm.WaitForReset();
      forever begin
				UartTxTransaction uartTxTransaction_clone;
				uartTxMonitorBfm.StartMonitoring(uartTxPacketStruct , uartConfigStruct);
				UartTxSeqItemConverter::toTxClass(uartTxPacketStruct , uartTxAgentConfig , uartTxTransaction);

				$cast(uartTxTransaction_clone, uartTxTransaction.clone());  
    		uartTxMonitorAnalysisPort.write(uartTxTransaction_clone);
				//->monitorSynchronizer;
       end 
		end 
	join_any
endtask : run_phase
`endif
