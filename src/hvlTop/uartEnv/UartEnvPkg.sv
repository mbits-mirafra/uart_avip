`ifndef UARTENVPKG_INCLUDED_
`define UARTENVPKG_INCLUDED_
//--------------------------------------------------------------------------------------------
// Package: UartEnvPkg
//  Includes all the files related to UART env
//--------------------------------------------------------------------------------------------
package UartEnvPkg;
  
  //-------------------------------------------------------
  // Import uvm package
  //-------------------------------------------------------
  `include "uvm_macros.svh"
  import uvm_pkg :: *;
 
  //-------------------------------------------------------
  // Importing the required packages
  //-------------------------------------------------------
  
  import UartGlobalPkg :: *;
  import UartTxPkg :: *;
  import UartRxPkg :: *;
  
  //-------------------------------------------------------
  // Include all env related files
  //-------------------------------------------------------
  
  `include "UartEnvConfig.sv"
  `include "UartVirtualSequencer.sv"
  `include "UartScoreboard.sv"
  `include "UartEnv.sv"
endpackage : UartEnvPkg
`endif
