`ifndef UARTTxDRIVERPROXY_INCLUDED_
`define UARTTxDRIVERPROXY_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class:  UartTxDriverProxy
//--------------------------------------------------------------------------------------------

class UartTxDriverProxy extends uvm_driver#(UartTxTransaction);
  `uvm_component_utils(UartTxDriverProxy)

	// virtual handle of transmitter driver bfm
  virtual UartTxDriverBfm uartTxDriverBfm;

	// handles for struct packet, transaction packet and config class
  UartTxPacketStruct uartTxPacketStruct;
  UartTxAgentConfig uartTxAgentConfig;
  UartTxTransaction uartTxTransaction;

	//event for controlling run phase drop objection
  event driverSynchronizer;  
	
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new( string name = "UartTxDriverProxy" , uvm_component parent);
  extern virtual function void build_phase( uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass : UartTxDriverProxy
		
//--------------------------------------------------------------------------------------------
// Construct: new
// name - UartTxDriverProxy
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartTxDriverProxy :: new( string name = "UartTxDriverProxy" , uvm_component parent );
  super.new(name,parent);
endfunction : new
		
//--------------------------------------------------------------------------------------------
// Function: build_phase
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartTxDriverProxy :: build_phase( uvm_phase phase);
  super.build_phase(phase);

  if(!(uvm_config_db #(virtual UartTxDriverBfm) :: get(this, "" , "uartTxDriverBfm",uartTxDriverBfm)))
   begin 
    `uvm_fatal(get_type_name(),$sformatf("FAILED TO GET VIRTUAL BFM HANDLE "))
   end 
  if(!(uvm_config_db #(UartTxAgentConfig) :: get(this, "" ,"uartTxAgentConfig",uartTxAgentConfig)))
    begin 
      `uvm_fatal(get_type_name(),$sformatf("FAILED TO GET AGENT CONFIG"))
    end 
  uartTxTransaction = UartTxTransaction :: type_id :: create("uartTxTransaction");
endfunction : build_phase
		
//--------------------------------------------------------------------------------------------
// Task: run_phase
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------

task UartTxDriverProxy :: run_phase(uvm_phase phase);
	UartConfigStruct uartConfigStruct;
	UartTxConfigConverter::from_Class(uartTxAgentConfig , uartConfigStruct);
	
		fork 
			begin 
				// baud clock generation
				uartTxDriverBfm.GenerateBaudClk(uartConfigStruct);
			end
			begin 
				uartTxDriverBfm.WaitForReset();
				forever begin
					seq_item_port.get_next_item(req);
					UartTxConfigConverter::from_Class(uartTxAgentConfig , uartConfigStruct);
					`uvm_info("[DRIVER PROXY]",$sformatf("UartDataType = %s \nThe baudrate of Uart = %s \nThe parity enable = %s \n No. of stop bits = %s\n oversampling method = %s",
					uartTxAgentConfig.uartDataType, uartTxAgentConfig.uartBaudRate, uartTxAgentConfig.hasParity, uartTxAgentConfig.uartStopBit, uartTxAgentConfig.uartOverSamplingMethod),UVM_LOW);
					$write("Data to be sent : ");
  				for(int i=0;i<uartTxAgentConfig.uartDataType;i++)
   					$write("%b",req.transmissionData[i]);
   				$display(" ");
					UartTxSeqItemConverter :: fromTxClass(req,uartTxAgentConfig,uartTxPacketStruct);
					uartTxDriverBfm.DriveToBfm(uartTxPacketStruct , uartConfigStruct);
				 	//wait(driverSynchronizer.triggered);
					seq_item_port.item_done();
				end
			end 
		join_any
	endtask : run_phase
`endif
