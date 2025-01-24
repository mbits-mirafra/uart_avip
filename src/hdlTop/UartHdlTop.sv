//--------------------------------------------------------------------------------------------
// Module      : HDLTop
//--------------------------------------------------------------------------------------------

module HdlTop;

  //-------------------------------------------------------
  // Importing uvm package and Including uvm macros file
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import UartGlobalPkg::*;

  initial begin
    `uvm_info("HDL_TOP","HDL_TOP",UVM_LOW);
  end

  //Variable : clk
  //Declaration of system clock

  bit clk;
  
  //Variables : on,off
  //used for generating clock of required frequency
  real on,off;

  //Variable : reset
  //Declaration of system reset

  bit reset;

  //-------------------------------------------------------
  // Generation of system clock at frequency of 500Mhz
  //-------------------------------------------------------

  initial begin
    on= PERIOD*(DUTY*0.01);
    off = PERIOD-on;
    forever begin
      clk=1;
      #on clk=0;
      #off;
    end
  end

  //-------------------------------------------------------
  // Generation of system reset
  //-------------------------------------------------------

  initial begin
    reset = 1'b1;
    #15 reset = 1'b0;

    repeat(1) begin
      @(posedge clk);
    end
    reset = 1'b1;
  end

  //-------------------------------------------------------
  // UART Interface Instantiation
  //-------------------------------------------------------
  UartIf uartIf(clk,reset);

  //-------------------------------------------------------
  // UART Transmitter BFM Agent Instantiation
  //-------------------------------------------------------

  UartTxAgentBfm uartTxAgentBfm(uartIf); 
  
  //-------------------------------------------------------
  // UART Reciever BFM Agent Instantiation
  //-------------------------------------------------------

  UartRxAgentBfm uartRxAgentBfm(uartIf);
  
endmodule : HdlTop
