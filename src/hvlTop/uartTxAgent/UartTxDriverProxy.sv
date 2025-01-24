
`ifndef UARTTxDRIVERPROXY_INCLUDED_
`define UARTTxDRIVERPROXY_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class:  UartTxDriverProxy
//--------------------------------------------------------------------------------------------

class UartTxDriverProxy extends uvm_driver#(UartTxTransaction);
  `uvm_component_utils(UartTxDriverProxy)
 
  virtual UartTxDriverBfm uartTxDriverBfm;
  UartTxPacketStruct uartTxPacketStruct;
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new( string name = "UartTxDriverProxy" , uvm_component parent);
  extern virtual function void build_phase( uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
endclass : UartTxDriverProxy
//--------------------------------------------------------------------------------------------
// Construct: new
//
// Parameters:
// name - UartTxDriverProxy
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------

function UartTxDriverProxy :: new( string name = "UartTxDriverProxy" , uvm_component parent );
  super.new(name,parent);
endfunction : new
//--------------------------------------------------------------------------------------------
// Function: build_phase
//
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartTxDriverProxy :: build_phase( uvm_phase phase);
  super.build_phase(phase);

  if(!(uvm_config_db #(virtual UartTxDriverBfm) :: get(this, "" , "uartTxDriverBfm",uartTxDriverBfm)))
   begin 
    `uvm_fatal(get_type_name(),$sformatf("FAILED TO GET VIRTUAL BFM HANDLE "))
   end 
endfunction : build_phase
//--------------------------------------------------------------------------------------------
// Task: run_phase
// Parameters:
// phase - uvm phase
//--------------------------------------------------------------------------------------------

task UartTxDriverProxy :: run_phase(uvm_phase phase);
  seq_item_port.get_next_item(req);
  UartTxSeqItemConverter :: fromTxClass(req,uartTxPacketStruct);
  `uvm_info("BFM",$sformatf("data in driver is %p",uartTxPacketStruct.transmissionData),UVM_LOW)
  seq_item_port.item_done();
endtask : run_phase
`endif
