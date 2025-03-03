
`ifndef UARTTXPKG_INCLUDED_
`define UARTTXPKG_INCLUDED_

// includes all the files required
package UartTxPkg;
  `include "uvm_macros.svh"
  import uvm_pkg :: *;
  import UartGlobalPkg :: *;
  `include "UartTxAgentConfig.sv"
  `include "UartTxTransaction.sv"
  `include "UartTxSeqItemConverter.sv"
  `include "UartTxConfigConverter.sv"
  `include "UartTxSequencer.sv"
  `include "UartTxDriverProxy.sv"
  `include "UartTxMonitorProxy.sv"
  `include "UartTxCoverage.sv"
  `include "UartTxAgent.sv"
endpackage : UartTxPkg

`endif
