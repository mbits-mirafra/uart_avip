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
       bins PARITY_ODD = {ODD_PARITY};
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
       bins BAUD_9600 = {BAUD_9600};
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
     DATA_PATTERN_8 : coverpoint data{
      bins pattern1_8 = {8'b 11111111};
      bins pattern2_8 = {8'b 10101010};
      bins pattern3_8 = {8'b 11110000};
      bins pattern4_8 = {8'b 00000000};
      bins pattern5_8 = {8'b 01010101};}
 
DATA_PATTERN_7 : coverpoint data{
  bins pattern1_7 = {7'b 1111111};
  bins pattern2_7 = {7'b 1010101};
  bins pattern3_7 = {7'b 1111000};
  bins pattern4_7 = {7'b 0000000};
  bins pattern5_7 = {7'b 0101010};}
 
DATA_PATTERN_6 : coverpoint data{
  bins pattern1_6 = {6'b 111111};
  bins pattern2_6 = {6'b 101010};
  bins pattern3_6 = {6'b 111100};
  bins pattern4_6 = {6'b 000000};
  bins pattern5_6 = {6'b 010101};}
 
DATA_PATTERN_5 : coverpoint data{
  bins pattern1_5 = {5'b 11111};
  bins pattern2_5 = {5'b 10101};
  bins pattern3_5 = {5'b 11110};
  bins pattern4_5 = {5'b 00000};
  bins pattern5_5 = {5'b 01010};}
 
    DATA_PATTERN_5_DATA_WIDTH_CP : cross DATA_PATTERN_5,DATA_WIDTH_CP { ignore_bins data_5 =  !binsof(DATA_WIDTH_CP)intersect{FIVE_BIT};}
    DATA_PATTERN_6_DATA_WIDTH_CP : cross DATA_PATTERN_6,DATA_WIDTH_CP { ignore_bins data_6 =  !binsof(DATA_WIDTH_CP) intersect{SIX_BIT};}
    DATA_PATTERN_7_DATA_WIDTH_CP : cross DATA_PATTERN_7,DATA_WIDTH_CP { ignore_bins data_7 =  !binsof(DATA_WIDTH_CP) intersect {SEVEN_BIT};}
    DATA_PATTERN_8_DATA_WIDTH_CP : cross DATA_PATTERN_8,DATA_WIDTH_CP { ignore_bins data_8 =  !binsof(DATA_WIDTH_CP) intersect{EIGHT_BIT};}


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
    data =0;
    data =  t.transmissionData;
    UartTxCovergroup.sample(uartTxAgentConfig,data);
endfunction : write

//--------------------------------------------------------------------------------------------
// Function: report_phase
// Used for reporting the coverage instance percentage values
//--------------------------------------------------------------------------------------------
function void  UartTxCoverage::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(), $sformatf("******************** UART TX Agent Coverage = %0.2f %% *********************",  UartTxCovergroup.get_coverage()), UVM_NONE);
endfunction: report_phase

`endif

