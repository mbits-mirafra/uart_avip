`ifndef UARTVIRTUALSEQUENCEPKG_INCLUDED_
`define UARTVIRTUALSEQUENCEPKG_INCLUDED_
//--------------------------------------------------------------------------------------------
// Package:UartVirtualSequencePkg
//  Includes all the files related to uart virtual sequences
//--------------------------------------------------------------------------------------------
package UartVirtualSequencePkg;
  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg :: *;
  import UartGlobalPkg :: *;
  import UartEnvPkg::*;
  import UartTxPkg::*;
  import UartRxPkg::*;
  import UartTxSequencePkg::*;
  import UartRxSequencePkg::*;
  
  //-------------------------------------------------------
  // Include all other files
  //-------------------------------------------------------

  `include "UartVirtualBaseSequence.sv"
  `include "UartVirtualTransmissionSequence.sv"
endpackage

`endif
