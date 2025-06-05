//--------------------------------------------------------------------------------------------
// Module      : UART Transmitter Agent BFM
// Description : Instantiates driver and monitor
//--------------------------------------------------------------------------------------------

module UartTxAgentBfm(UartIf uartIf);

  //-------------------------------------------------------
  // Importing uvm package file
  //-------------------------------------------------------

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  initial begin
    `uvm_info("uart transmitter agent bfm",$sformatf("UART TRANSMITTER AGENT BFM"),UVM_LOW)
  end
  
  //-------------------------------------------------------
  // Transmitter driver bfm instantiation
  //-------------------------------------------------------
  
  UartTxDriverBfm uartTxDriverBfm (.clk(uartIf.clk),
                                     .reset(uartIf.reset),
                                     .tx(uartIf.tx)

  );

  //-------------------------------------------------------
  // Transmitter monitor bfm instantiation
  //-------------------------------------------------------
  
 UartTxMonitorBfm uartTxMonitorBfm (.clk(uartIf.clk),
                                     .reset(uartIf.reset),
                                     .tx(uartIf.tx)
  );


  //-------------------------------------------------------
  // setting the virtual handle of BFMs into config_db
  //-------------------------------------------------------

  initial begin
    uvm_config_db#(virtual UartTxDriverBfm)::set(null,"*","uartTxDriverBfm",uartTxDriverBfm);
    uvm_config_db#(virtual UartTxMonitorBfm)::set(null,"*","uartTxMonitorBfm",uartTxMonitorBfm);
  end

  bind UartTxMonitorBfm UartTxAssertions TransmissionAssertions(.uartClk(baudClk),.uartTx(tx));

endmodule : UartTxAgentBfm
