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
				 
				 UartTxConfigConverter::from_Class(uartTxAgentConfig , uartConfigStruct);
                                uvm_config_db#(UartConfigStruct) :: set(null,"*","uartConfigStruct",uartConfigStruct);
				seq_item_port.get_next_item(req);
				//	 UartTxConfigConverter::from_Class(uartTxAgentConfig , uartConfigStruct);

`uvm_info("[DRIVER PROXY]",$sformatf("\n**************************************************************************************************************************************\n************************************************************\tTHE TRANSMITTER CONFIG FIELDS\t****************************************\n\tUartDataType = %s \n\tThe baudrate of Uart = %s \n\tThe parity enable = %s \n \tParity Type is %s\n \tNo. of stop bits = %s\n\tOversampling method = %s\n\tframing error injection = %b\n\tParity error injection = %b\n\tBreaking error injection = %b\n\*********************************************************************************************************************************",uartConfigStruct.uartDataType, uartConfigStruct.uartBaudRate, uartConfigStruct.uartParityEnable, uartConfigStruct.uartParityType, uartConfigStruct.uartStopBit,uartConfigStruct.uartOverSamplingMethod,uartConfigStruct.uartFramingErrorInjection,uartConfigStruct.uartParityErrorInjection,uartConfigStruct.uartBreakingErrorInjection),UVM_LOW);
				  $display("The orginal data being generated is %b\n",req.transmissionData);	
			          UartTxSeqItemConverter :: fromTxClass(req,uartConfigStruct,uartTxPacketStruct);
					$write("Data to be sent from the Transmitter is: ");
  				      for(int i=uartConfigStruct.uartDataType-1;i>=0;i--)
   					$write("%b",uartTxPacketStruct.transmissionData[i]);
					$write(" as uartDataType is %s",uartConfigStruct.uartDataType);
   				$display(" \n");
					uartTxDriverBfm.DriveToBfm(uartTxPacketStruct , uartConfigStruct);
					seq_item_port.item_done();
				end
			end 
		join_any
	endtask : run_phase
`endif
