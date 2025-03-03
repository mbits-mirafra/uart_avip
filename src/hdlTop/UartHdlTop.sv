//--------------------------------------------------------------------------------------------
// Module      : HDLTop
//--------------------------------------------------------------------------------------------
`timescale 1ns/1ps
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

  //Variable : reset
  //Declaration of system reset

  bit reset;

  //-------------------------------------------------------
  // Generation of system clock at frequency of 500Mhz
  //-------------------------------------------------------

  initial begin
     clk=0;
    forever begin
     #0.1 clk = ~clk;
    end
  end

  //-------------------------------------------------------
  // Generation of system reset
  //-------------------------------------------------------

  initial begin
    reset = 1'b1;
    #1 reset = 1'b0;

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

  //assign uartIf.rx = uartIf.tx;
  
endmodule : HdlTop
