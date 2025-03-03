//-------------------------------------------------------
// Importing Uart global package
//-------------------------------------------------------

import UartGlobalPkg::*;

//--------------------------------------------------------------------------------------------
// Interface : UartIf
// Declaration of pin level signals for Uart interface
//--------------------------------------------------------------------------------------------

interface UartIf (input clk, input reset);
  
  logic tx;

  logic rx;

endinterface : UartIf 
