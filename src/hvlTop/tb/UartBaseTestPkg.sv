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
  
  //Testcases
  `include "UartBaudRate4800Test.sv"
  `include "UartBaudRate9600Test.sv"
  `include "UartBaudRate19200Test.sv"
  `include "UartBaudRate9600WithBreakingErrorTest.sv"
  `include "UartBaudRate4800WithParityErrorTest.sv"
  `include "UartBaudRate19200WithFramingErrorTest.sv"
  `include "UartBaudRate4800WithParityTest.sv"
  `include "UartBaudRate9600WithParityTest.sv"
  `include "UartBaudRate19200WithParityTest.sv"
  `include "UartBaudRate9600WithParityErrorTest.sv"
  `include "UartBaudRate19200WithParityErrorTest.sv"
  `include "UartBaudRate4800WithBreakingErrorTest.sv"
  `include "UartBaudRate19200WithBreakingErrorTest.sv"
  `include "UartBaudRate4800WithFramingErrorTest.sv"
  `include "UartBaudRate9600WithFramingErrorTest.sv"
endpackage : UartBaseTestPkg
`endif
