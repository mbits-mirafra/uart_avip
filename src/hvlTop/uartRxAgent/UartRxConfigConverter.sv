`ifndef UARTRXCONFIGCONVERTER_INCLUDED_
`define UARTRXCONFIGCONVERTER_INCLUDED_

class UartRxConfigConverter extends uvm_object;
  `uvm_object_utils(UartRxConfigConverter)
  extern function new( string name = "UartRxConfigConverter");
  extern static function void from_Class(input UartRxAgentConfig uartRxAgentConfig, output UartConfigStruct uartConfigStruct);
endclass :UartRxConfigConverter
    

function UartRxConfigConverter :: new(string name = "UartRxConfigConverter");
  super.new(name);
endfunction : new

function void UartRxConfigConverter :: from_Class(input UartRxAgentConfig uartRxAgentConfig, output UartConfigStruct uartConfigStruct);
  uartConfigStruct.uartOverSamplingMethod =  uartRxAgentConfig.uartOverSamplingMethod;
  uartConfigStruct.uartBaudRate =  uartRxAgentConfig.uartBaudRate;
  uartConfigStruct.uartDataType = uartRxAgentConfig.uartDataType;
  uartConfigStruct.uartParityType = uartRxAgentConfig.uartParityType;
  uartConfigStruct.uartParityEnable = uartRxAgentConfig.hasParity;
  uartConfigStruct.uartParityErrorInjection = uartRxAgentConfig.parityErrorInjection;
  uartConfigStruct.OverSampledBaudFrequencyClk = uartRxAgentConfig.OverSampledBaudFrequencyClk;
  uartConfigStruct.uartStopBit = uartRxAgentConfig.uartStopBit;
endfunction : from_Class


`endif
 
  
