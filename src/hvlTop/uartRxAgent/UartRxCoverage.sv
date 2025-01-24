`ifndef UARTRXCOVERAGE_INCLUDED_
`define UARTRXCOVERAGE_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: UartRxCoverage
//  This class is used to include covergroups and bins required for functional coverage
//--------------------------------------------------------------------------------------------
class UartRxCoverage extends uvm_subscriber #(UartRxTransaction);
  `uvm_component_utils(UartRxCoverage)

  //Variable: uartRxAgentConfig;
  //Handle for uart recevier agent configuration
  UartRxAgentConfig uartRxAgentConfig;
  
  //-------------------------------------------------------
  // Covergroup : UartRxCovergroup 
  //  Covergroup consists of the various coverpoints
  //  based on the number of the variables used to improve the coverage.
  //-------------------------------------------------------
  covergroup UartRxCovergroup with function sample (UartRxAgentConfig uartRxAgentConfig, UartRxTransaction uartRxTransaction);
    RX : coverpoint uartRxTransaction.receivingData{
      option.comment = "rx";
      bins UART_RX = {[1:$]};
    }
  endgroup: UartRxCovergroup
  
  //-------------------------------------------------------
  //Externally defined tasks and functions
  //-------------------------------------------------------
  extern function new(string name = "UartRxCoverage", uvm_component parent = null);
  extern function void write(UartRxTransaction t);
  extern virtual function void report_phase(uvm_phase phase);

endclass : UartRxCoverage

//--------------------------------------------------------------------------------------------
// Construct: new
// 
// Parameters:
//  name -  UartRxCoverage
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function  UartRxCoverage::new(string name = "UartRxCoverage", uvm_component parent = null);
  super.new(name, parent);
  UartRxCovergroup = new();
endfunction : new

//-------------------------------------------------------
// Function: write
//  Creates the write method
//
// Parameters:
//  t - UartRxTransaction handle
//-------------------------------------------------------
function void UartRxCoverage::write(UartRxTransaction t);
  `uvm_info(get_type_name(),$sformatf("Before calling SAMPLE METHOD"),UVM_HIGH);
  foreach(t.receivingData[i]) begin
    UartRxCovergroup.sample(uartRxAgentConfig,t);
  end
  `uvm_info(get_type_name(),"After calling SAMPLE METHOD",UVM_HIGH);

endfunction : write

//--------------------------------------------------------------------------------------------
// Function: report_phase
//  Used for reporting the coverage instance percentage values
//--------------------------------------------------------------------------------------------
function void  UartRxCoverage::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("UART RX Agent Coverage = %0.2f %%",  UartRxCovergroup.get_coverage()), UVM_NONE);
endfunction: report_phase

`endif
