`ifndef UARTTXSEQITEMCONVERTER_INCLUDED_
`define UARTTXSEQITEMCONVERTER_INCLUDED_
//--------------------------------------------------------------------------------------------
// Class:UartTxSeqItemConverter
// Description:
// class for converting the transaction items to struct and vice veras
//--------------------------------------------------------------------------------------------
class UartTxSeqItemConverter extends uvm_object;
  `uvm_object_utils(UartTxSeqItemConverter)
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new( string name = "UartTxSeqItemConverter");
  extern static function void fromTxClass(input UartTxTransaction uartTxTransaction, output UartTxPacketStruct uartTxPacketStruct);
  extern static function void toTxClass(input UartTxPacketStruct uartTxPacketStruct, output UartTxTransaction uartTxTransaction);
endclass :UartTxSeqItemConverter
    
//--------------------------------------------------------------------------------------------
// Construct: new
// Initializes memory for new object 
// Parameters:
// name - UartTxSeqItemConverter
//--------------------------------------------------------------------------------------------
function UartTxSeqItemConverter :: new(string name = "UartTxSeqItemConverter");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: fromTxclass
// Converting seq_item transactions into struct data items
//--------------------------------------------------------------------------------------------
function void UartTxSeqItemConverter :: fromTxClass(input UartTxTransaction uartTxTransaction, output UartTxPacketStruct uartTxPacketStruct);
  int total_transmission = uartTxTransaction.transmissionData.size();

  for(int transmission_number=0 ; transmission_number < total_transmission; transmission_number++)begin 
    for( int i=0 ; i< DATA_WIDTH ; i++) begin  
      uartTxPacketStruct.transmissionData[transmission_number][i] = uartTxTransaction.transmissionData[transmission_number][i];
     end 
   end 
   uartTxPacketStruct.parity = uartTxTransaction.parity;
 endfunction : fromTxClass

//--------------------------------------------------------------------------------------------
// Function: toTxClass
// Converting struct data items into seq_item transactions
//--------------------------------------------------------------------------------------------
function void UartTxSeqItemConverter :: toTxClass(input UartTxPacketStruct uartTxPacketStruct, output UartTxTransaction uartTxTransaction);
  int total_transmission = $size(uartTxPacketStruct.transmissionData);
  for(int transmission_number=0 ; transmission_number < total_transmission; transmission_number++)begin 
    for( int i=0 ; i< DATA_WIDTH ; i++) begin
      uartTxTransaction.transmissionData[transmission_number][i] = uartTxPacketStruct.transmissionData[transmission_number][i];
    end 
  end 
   uartTxTransaction.parity = uartTxPacketStruct.parity;
endfunction : toTxClass

`endif
 
  
