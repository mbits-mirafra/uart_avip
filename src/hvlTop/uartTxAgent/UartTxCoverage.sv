`ifndef UARTTXCOVERAGE_INCLUDED_
`define UARTTXCOVERAGE_INCLUDED_
//--------------------------------------------------------------------------------------------
// Class: UartTxCoverage
// Description:
// Class for coverage report for UART
//--------------------------------------------------------------------------------------------

class UartTxCoverage extends uvm_subscriber #(UartTxTransaction);
  `uvm_component_utils(UartTxCoverage)

  //Declaring handle for tx agent configuration class 
  UartTxAgentConfig uartTxAgentConfig;

  //Declating a variable to store the transmission data
  bit[DATA_WIDTH-1:0] data; 
  
  //-------------------------------------------------------
  // Covergroup: UartTxCovergroup
  //  Covergroup consists of the various coverpoints based on
  //  no. of the variables used to improve the coverage.
  //-------------------------------------------------------
  covergroup UartTxCovergroup with function sample (UartTxAgentConfig uartTxAgentConfig,  bit[DATA_WIDTH-1:0] data);
    TX_CP : coverpoint data{
     bins UART_TX  = {[0:255]};}

     DATA_WIDTH_CP : coverpoint uartTxAgentConfig.uartDataType{
       bins TRANSFER_BIT_5 = {FIVE_BIT};
       bins TRANSFER_BIT_6 = {SIX_BIT};
       bins TRANSFER_BIT_7 = {SEVEN_BIT};
       bins TRANSFER_BIT_8 = {EIGHT_BIT};
     }

    PARITY_CP : coverpoint uartTxAgentConfig.uartParityType{
       bins PARITY_EVEN = {EVEN_PARITY};
       bins PARITY_oDD = {ODD_PARITY};
    }

    STOP_BIT_CP : coverpoint uartTxAgentConfig.uartStopBit{
       bins STOP_BIT_1 = {ONE_BIT};
       bins STOP_BIT_2 = {TWO_BIT};
    }

    OVERSAMPLING_CP : coverpoint uartTxAgentConfig.uartOverSamplingMethod {
       bins OVERSAMPLING_13X = {OVERSAMPLING_13}; 
       bins OVERSAMPLING_16X = {OVERSAMPLING_16};
   }

    BAUD_RATE_CP : coverpoint uartTxAgentConfig.uartBaudRate {
       bins BAUD_4800 = {BAUD_4800};
       bins BAUD_9800 = {BAUD_9600};
       bins BAUD_13200 = {BAUD_19200};
  }

    PARITY_ERROR_INJECTION_CP : coverpoint uartTxAgentConfig.parityErrorInjection {
       bins NO_ERROR = {0};
       bins ERROR_INJECTED = {1};
 }

    HAS_PARITY_CP : coverpoint uartTxAgentConfig.hasParity {
       bins PARITY_DISABLED = {0};
       bins PARITY_ENABLED = {1};
 }


    DATA_WIDTH_CP_PARITY_CP : cross DATA_WIDTH_CP,PARITY_CP;
    DATA_WIDTH_CP_STOP_BIT_CP :cross DATA_WIDTH_CP,STOP_BIT_CP;
    OVERSAMPLING_CP_BAUD_RATE_CP : cross OVERSAMPLING_CP, BAUD_RATE_CP;
    HAS_PARITY_CP_PARITY_ERROR_INJECTION_CP : cross HAS_PARITY_CP, PARITY_ERROR_INJECTION_CP {ignore_bins parity_0 = binsof(HAS_PARITY_CP) intersect {0};}
    DATA_WIDTH_CP_BAUD_RATE_CP : cross DATA_WIDTH_CP, BAUD_RATE_CP;
    DATA_WIDTH_CP_OVERSAMPLING_CP : cross DATA_WIDTH_CP, OVERSAMPLING_CP;
    
 endgroup: UartTxCovergroup

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "UartTxCoverage", uvm_component parent = null);
  extern function void write(UartTxTransaction t);
  extern virtual function void report_phase(uvm_phase phase);
  extern virtual function void build_phase(uvm_phase phase);
endclass : UartTxCoverage

//--------------------------------------------------------------------------------------------
// Construct: new
//  name -UartTxCoverage
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function  UartTxCoverage::new(string name = "UartTxCoverage", uvm_component parent = null);
  super.new(name, parent);
  UartTxCovergroup = new();
endfunction : new

//--------------------------------------------------------------------------------------------
// Build phase
//--------------------------------------------------------------------------------------------
function void UartTxCoverage :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!(uvm_config_db #(UartTxAgentConfig) :: get(this,"","uartTxAgentConfig",this.uartTxAgentConfig)))
  `uvm_fatal("FATAL Tx AGENT CONFIG", $sformatf("Failed to get Tx agent config in coverage"))
endfunction : build_phase


//--------------------------------------------------------------------------------------------
// Function: write
// Overriding the write method declared in the parent class
//--------------------------------------------------------------------------------------------
function void UartTxCoverage::write(UartTxTransaction t);
  foreach(t.transmissionData[i]) begin
    data =  t.transmissionData[i];
    UartTxCovergroup.sample(uartTxAgentConfig,data);
  end
endfunction : write

//--------------------------------------------------------------------------------------------
// Function: report_phase
// Used for reporting the coverage instance percentage values
//--------------------------------------------------------------------------------------------
function void  UartTxCoverage::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("******************** UART TX Agent Coverage = %0.2f %% *********************",  UartTxCovergroup.get_coverage()), UVM_NONE);
endfunction: report_phase

`endif

