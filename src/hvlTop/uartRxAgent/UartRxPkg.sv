`ifndef UARTRxPKG_INCLUDED_
`define UARTRxPKG_INCLUDED_

// includes all all files
package UartRxPkg;
  `include "uvm_macros.svh"
  import uvm_pkg :: *;
  import UartGlobalPkg :: *;
  `include "UartRxAgentConfig.sv"
  `include "UartRxTransaction.sv"
  `include "UartRxSeqItemConverter.sv"
  `include "UartRxConfigConverter.sv"
  `include "UartRxSequencer.sv"
  `include "UartRxDriverProxy.sv"
  `include "UartRxMonitorProxy.sv"
  `include "UartRxCoverage.sv"
  `include "UartRxAgent.sv"
endpackage : UartRxPkg

`endif
