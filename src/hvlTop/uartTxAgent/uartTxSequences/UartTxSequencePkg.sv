`ifndef UARTTXSEQUENCEPKG_INCLUDED_
`define UARTTXSEQUENCEPKG_INCLUDED_

package UartTxSequencePkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import UartGlobalPkg :: *;
  import UartTxPkg ::*;

  `include"UartTxBaseSequence.sv"
  `include"UartTxBaseSequenceWithPattern.sv"
  `include "UartTxTransmitterSequence.sv"

endpackage
`endif

