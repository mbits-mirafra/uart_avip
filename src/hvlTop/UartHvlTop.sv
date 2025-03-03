`ifndef HVLTOP_INCLUDED_
`define HVLTOP_INCLUDED_
//--------------------------------------------------------------------------------------------
// Module: Hvl top module
//--------------------------------------------------------------------------------------------
module HvlTop;
  
//-------------------------------------------------------
// Package : Importing Uvm Pakckage and Test Package
//-------------------------------------------------------

  import uvm_pkg :: *;
  import UartBaseTestPkg :: *;

  initial 
    begin 
      run_test("UartBaseTest");
    end
endmodule : HvlTop

`endif
