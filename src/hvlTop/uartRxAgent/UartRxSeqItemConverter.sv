`ifndef UARTRXSEQITEMCONVERTER_INCLUDED_
`define UARTRXSEQITEMCONVERTER_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: UartRxSeqItemConverter
// Description:
// class for converting the transaction items to struct and vice versa
//--------------------------------------------------------------------------------------------
class UartRxSeqItemConverter extends uvm_object;
  `uvm_object_utils(UartRxSeqItemConverter)
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new( string name = "UartRxSeqItemConverter");
  extern static function void fromRxClass(input UartRxTransaction uartRxTransaction, input UartRxAgentConfig uartRxAgentConfig, output UartRxPacketStruct uartRxPacketStruct);
  extern static function void toRxClass(input UartRxPacketStruct uartRxPacketStruct, input UartRxAgentConfig uartRxAgentConfig, inout UartRxTransaction uartRxTransaction);
    
endclass :UartRxSeqItemConverter
    
//--------------------------------------------------------------------------------------------
// Construct: new
// name - UartRxSeqItemConverter
//--------------------------------------------------------------------------------------------
function UartRxSeqItemConverter :: new(string name = "UartRxSeqItemConverter");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// Function: from_class
// Converting seq_item transactions into struct data items
// name -UartRxTransaction, UartRxPacketStruct 
//--------------------------------------------------------------------------------------------
function void UartRxSeqItemConverter :: fromRxClass(input UartRxTransaction uartRxTransaction,input UartRxAgentConfig uartRxAgentConfig, output UartRxPacketStruct uartRxPacketStruct);
    for( int i=0 ; i< uartRxAgentConfig.uartDataType ; i++) begin  
      uartRxPacketStruct.receivingData[i] = uartRxTransaction.receivingData[i];
    end
endfunction : fromRxClass
    
//--------------------------------------------------------------------------------------------
// Function: to_class
//  Converting struct data items into seq_item transactions
//  name - UartRxPacketStruct,UartRxTransaction 
//--------------------------------------------------------------------------------------------
function void UartRxSeqItemConverter :: toRxClass(input UartRxPacketStruct uartRxPacketStruct,input UartRxAgentConfig uartRxAgentConfig,inout UartRxTransaction uartRxTransaction);
    for( int i=0 ; i<uartRxAgentConfig.uartDataType ; i++) begin
      uartRxTransaction.receivingData[i] = uartRxPacketStruct.receivingData[i];
    end
    uartRxTransaction.parity = uartRxPacketStruct.parity;
    uartRxTransaction.framingError = uartRxPacketStruct.framingError;
    uartRxTransaction.parityError = uartRxPacketStruct.parityError;
    uartRxTransaction.breakingError = uartRxPacketStruct.breakingError;
    uartRxTransaction.overrunError = uartRxPacketStruct.overrunError;
endfunction
`endif
