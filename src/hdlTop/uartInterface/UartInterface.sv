//-------------------------------------------------------
// Importing Uart global package
//-------------------------------------------------------

import UartGlobalPkg::*;

`timescale 1ns/1ps
//--------------------------------------------------------------------------------------------
// Interface : UartIf
// Declaration of pin level signals for Uart interface
//--------------------------------------------------------------------------------------------

interface UartIf (input clk, input reset);
  
  logic tx;

  logic rx;

endinterface : UartIf 
