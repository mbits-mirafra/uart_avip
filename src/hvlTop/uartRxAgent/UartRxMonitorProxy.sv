`ifndef UARTRXMONITORPROXY_INCLUDED_
`define UARTRXMONITORPROXY_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: UartRxMonitorProxy
// This is the Receiver proxy monitor on the HVL side
//--------------------------------------------------------------------------------------------

class UartRxMonitorProxy extends uvm_monitor;
  `uvm_component_utils(UartRxMonitorProxy)

  // Handle for receiver monitor bfm
  virtual UartRxMonitorBfm uartRxMonitorBfm;

  // handles for struct packet, transaction packet and config class
  UartRxTransaction uartRxTransaction;
  UartRxPacketStruct uartRxPacketStruct;
  UartRxAgentConfig uartRxAgentConfig;

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
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartRxMonitorProxy :: build_phase( uvm_phase phase);
  super.build_phase(phase);
  if(!(uvm_config_db #(virtual UartRxMonitorBfm) :: get(this, "" , "uartRxMonitorBfm",uartRxMonitorBfm))) begin 
    `uvm_fatal(get_type_name(),$sformatf("FAILED TO GET VIRTUAL BFM HANDLE "))
  end
  if(!(uvm_config_db #(UartRxAgentConfig) :: get(this, "" ,"uartRxAgentConfig",uartRxAgentConfig)))
    begin 
      `uvm_fatal(get_type_name(),$sformatf("FAILED TO GET AGENT CONFIG"))
    end  
endfunction : build_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// phase - uvm phase
//--------------------------------------------------------------------------------------------
    
task UartRxMonitorProxy :: run_phase(uvm_phase phase);
  UartConfigStruct uartConfigStruct;
  uartRxTransaction = UartRxTransaction::type_id::create("uartRxTransaction");
  UartRxConfigConverter::from_Class(uartRxAgentConfig , uartConfigStruct);
  
  fork 
    begin 
    	// generating baud clck
    	uartRxMonitorBfm.GenerateBaudClk(uartConfigStruct);
    end 
		
    begin 
  	uartRxMonitorBfm.WaitForReset();
  	forever begin
	    UartRxTransaction uartRxTransaction_clone;
	    UartRxSeqItemConverter :: fromRxClass(uartRxTransaction,uartRxAgentConfig,uartRxPacketStruct);
	    UartRxConfigConverter::from_Class(uartRxAgentConfig , uartConfigStruct);
	    uartRxMonitorBfm.StartMonitoring(uartRxPacketStruct, uartConfigStruct);
	    UartRxSeqItemConverter::toRxClass(uartRxPacketStruct,uartRxAgentConfig,uartRxTransaction);
	
			$write("Data received : ");
			for(int i=0;i<uartRxAgentConfig.uartDataType;i++)
				$write("%b",uartRxTransaction.receivingData[i]);
   		$display(" ");
	    $cast(uartRxTransaction_clone, uartRxTransaction.clone());  
	    uartRxMonitorAnalysisPort.write(uartRxTransaction_clone);
  end
 end 
join_any

endtask : run_phase
`endif
