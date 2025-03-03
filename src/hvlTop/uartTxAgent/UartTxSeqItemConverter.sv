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
  extern static function void fromTxClass(input UartTxTransaction uartTxTransaction, input UartTxAgentConfig, output UartTxPacketStruct uartTxPacketStruct);
  extern static function void toTxClass(input UartTxPacketStruct uartTxPacketStruct,input UartTxAgentConfig uartTxAgentConfig,inout UartTxTransaction uartTxTransaction);
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
function void UartTxSeqItemConverter :: fromTxClass(input UartTxTransaction uartTxTransaction,input UartTxAgentConfig uartTxAgentConfig, output UartTxPacketStruct uartTxPacketStruct);
    for( int i=0 ; i< uartTxAgentConfig.uartDataType ; i++) begin  
      uartTxPacketStruct.transmissionData[i] = uartTxTransaction.transmissionData[i];
    end 
endfunction : fromTxClass

//--------------------------------------------------------------------------------------------
// Function: toTxClass
// Converting struct data items into seq_item transactions
//--------------------------------------------------------------------------------------------
function void UartTxSeqItemConverter :: toTxClass(input UartTxPacketStruct uartTxPacketStruct,input UartTxAgentConfig uartTxAgentConfig,inout UartTxTransaction uartTxTransaction);
    for( int i=0 ; i<uartTxAgentConfig.uartDataType ; i++) begin
      uartTxTransaction.transmissionData[i] = uartTxPacketStruct.transmissionData[i];
    end
    uartTxTransaction.parity = uartTxPacketStruct.parity;
    uartTxTransaction.framingError = uartTxPacketStruct.framingError;
    uartTxTransaction.parityError = uartTxPacketStruct.parityError;
    uartTxTransaction.breakingError = uartTxPacketStruct.breakingError;
    uartTxTransaction.overrunError = uartTxPacketStruct.overrunError;
endfunction : toTxClass

`endif
