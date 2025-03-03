`ifndef UARTTXCONFIGCONVERTER_INCLUDED_
`define UARTTXCONFIGCONVERTER_INCLUDED_

class UartTxConfigConverter extends uvm_object;
  `uvm_object_utils(UartTxConfigConverter)
  extern function new( string name = "uartTxConfigConverter");
  extern static function void from_Class(input UartTxAgentConfig uartTxAgentConfig, output UartConfigStruct uartConfigStruct);
endclass :UartTxConfigConverter
    

function UartTxConfigConverter :: new(string name = "uartTxConfigConverter");
  super.new(name);
endfunction : new

function void UartTxConfigConverter :: from_Class(input UartTxAgentConfig uartTxAgentConfig, output UartConfigStruct uartConfigStruct);
  uartConfigStruct.uartOverSamplingMethod =  uartTxAgentConfig.uartOverSamplingMethod;
  uartConfigStruct.uartBaudRate =  uartTxAgentConfig.uartBaudRate;
  uartConfigStruct.uartDataType = uartTxAgentConfig.uartDataType;
  uartConfigStruct.uartParityType = uartTxAgentConfig.uartParityType;
  uartConfigStruct.uartParityEnable = uartTxAgentConfig.hasParity;
  uartConfigStruct.uartParityErrorInjection = uartTxAgentConfig.parityErrorInjection;
  uartConfigStruct.uartFramingErrorInjection = uartTxAgentConfig.framingErrorInjection;
  uartConfigStruct.uartBreakingErrorInjection = uartTxAgentConfig.breakingErrorInjection;
  uartConfigStruct.OverSampledBaudFrequencyClk = uartTxAgentConfig.OverSampledBaudFrequencyClk;
  uartConfigStruct.uartStopBit = uartTxAgentConfig.uartStopBit;
endfunction : from_Class

`endif
