`ifndef UARTBASETESTPKG_INCLUDED_
`define UARTBASETESTPKG_INCLUDED_
//--------------------------------------------------------------------------------------------
// Package:UartBaseTestPkg
//--------------------------------------------------------------------------------------------
package UartBaseTestPkg;
  `include "uvm_macros.svh"
  
  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  import uvm_pkg :: *;
  import UartGlobalPkg :: *;

  //-------------------------------------------------------
  // Importing the required packages
  //-------------------------------------------------------
  import UartTxPkg ::*;
  import UartRxPkg :: *;
  import UartEnvPkg :: *;
  import UartTxSequencePkg :: *;
  import UartRxSequencePkg :: *;
  import UartVirtualSequencePkg::*;
  
  //including base_test for testing
  `include "UartBaseTest.sv"
endpackage : UartBaseTestPkg
`endif
