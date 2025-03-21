`ifndef UARTRXCOVERAGE_INCLUDED_
`define UARTRXCOVERAGE_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: UartRxCoverage
//  This class is used to include covergroups and bins required for functional coverage
//--------------------------------------------------------------------------------------------
class UartRxCoverage extends uvm_subscriber #(UartRxTransaction);
  `uvm_component_utils(UartRxCoverage)

  //Handle for uart recevier agent configuration
  UartRxAgentConfig uartRxAgentConfig;

  //Declating a variable to store the receiveing data
  bit[DATA_WIDTH-1:0] data; 
  
  //-------------------------------------------------------
  // Covergroup : UartRxCovergroup 
  //  Covergroup consists of the various coverpoints
  //  based on the number of the variables used to improve the coverage.
  //-------------------------------------------------------
  covergroup UartRxCovergroup with function sample (UartRxAgentConfig uartRxAgentConfig, bit[DATA_WIDTH-1:0] data);
    RX_CP : coverpoint data{
      bins UART_RX = {[0:255]};
    }

    DATA_WIDTH_CP : coverpoint uartRxAgentConfig.uartDataType{
      bins TRANSFER_BIT_5 = { FIVE_BIT};
      bins TRANSFER_BIT_6 = {SIX_BIT};
      bins TRANSFER_BIT_7 = {SEVEN_BIT};
      bins TRANSFER_BIT_8 = {EIGHT_BIT};
    }

    BAUD_RATE_CP:coverpoint uartRxAgentConfig.uartBaudRate{
      bins BAUD_4800_1 = {BAUD_4800};
      bins BAUD_9600_2 = {BAUD_9600};
      bins BAUD_19200_3 = {BAUD_19200};
    }

    OVER_SAMPLING_CP: coverpoint uartRxAgentConfig.uartOverSamplingMethod{
      bins OVERSAMPLING_16_1_1 = {OVERSAMPLING_16};
      bins OVERSAMPLING_13_2_2 = {OVERSAMPLING_13};
    }
    
    PARITY_CP : coverpoint uartRxAgentConfig.uartParityType{
      bins EVEN_PARITY_0 = {0};
      bins ODD_PARITY_1 = {1};
    }

    STOP_BIT_CP : coverpoint uartRxAgentConfig.uartStopBit{
      bins STOP_BIT_1_1 = {1};
      bins STOP_BIT_2_2 = {2};
    }
    
    HAS_PARITY_CP: coverpoint uartRxAgentConfig.hasParity{
      bins HAS_PARITY_0 = {0};
      bins HAS_PARITY_1 = {1};
    }
 
    PARITY_ERROR_INJECTION_CP:coverpoint uartRxAgentConfig.parityErrorInjection{
      bins WITH_NO_ERROR = {0};
      bins WITH_ERROR = {1};
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
 
DATA_PATTERN_5_DATA_WIDTH_CP : cross DATA_PATTERN_5,DATA_WIDTH_CP {ignore_bins data_5 = !binsof(DATA_WIDTH_CP) intersect {FIVE_BIT};}
DATA_PATTERN_6_DATA_WIDTH_CP : cross DATA_PATTERN_6,DATA_WIDTH_CP {ignore_bins data_6 = !binsof(DATA_WIDTH_CP) intersect {SIX_BIT};}
DATA_PATTERN_7_DATA_WIDTH_CP : cross DATA_PATTERN_7,DATA_WIDTH_CP {ignore_bins data_7 = !binsof(DATA_WIDTH_CP) intersect {SEVEN_BIT};}
DATA_PATTERN_8_DATA_WIDTH_CP : cross DATA_PATTERN_8,DATA_WIDTH_CP {ignore_bins data_8 = !binsof(DATA_WIDTH_CP) intersect {EIGHT_BIT};}
    
    DATA_WIDTH_CP_PARITY_CP : cross DATA_WIDTH_CP,PARITY_CP;
    DATA_WIDTH_CP_STOP_BIT_CP :cross DATA_WIDTH_CP,STOP_BIT_CP;
    OVER_SAMPLINGxBAUD_RATE:cross BAUD_RATE_CP,  OVER_SAMPLING_CP;
    HAS_PARITY_CP_PARITY_ERROR_INJECTION_CP : cross HAS_PARITY_CP, PARITY_ERROR_INJECTION_CP {ignore_bins parity_0 = binsof(HAS_PARITY_CP) intersect {0};}
    OVER_SAMPLINGxDATA_TYPE:cross  DATA_WIDTH_CP,OVER_SAMPLING_CP;
    DATA_WIDTHxBAUD_RATE: cross  DATA_WIDTH_CP ,BAUD_RATE_CP;
    
endgroup: UartRxCovergroup
  
  //-------------------------------------------------------
  //Externally defined tasks and functions
  //-------------------------------------------------------
  extern function new(string name = "UartRxCoverage", uvm_component parent = null);
  extern function void write(UartRxTransaction t);
  extern virtual function void report_phase(uvm_phase phase);
  extern virtual function void build_phase(uvm_phase phase);
endclass : UartRxCoverage

  //--------------------------------------------------------------------------------------------
  // Construct: new
  //  name -  UartRxCoverage
  //  parent - parent under which this component is created
  //--------------------------------------------------------------------------------------------
  function  UartRxCoverage::new(string name = "UartRxCoverage", uvm_component parent = null);
    super.new(name, parent);
    UartRxCovergroup = new();
  endfunction : new

  //---------------------------------------------------------------------------------------------------------
  // Build Phase
  //-------------------------------------------------------------------------------------------------------------
  function void UartRxCoverage :: build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!(uvm_config_db #(UartRxAgentConfig) :: get(this,"","uartRxAgentConfig",uartRxAgentConfig)))
    `uvm_fatal("FATAL Rx AGENT CONFIG", $sformatf("Failed to get Rx agent config in coverage"))
  endfunction : build_phase

    
  //-------------------------------------------------------
  // Function: write
  //  Creates the write method
  //  t - UartRxTransaction handle
  //-------------------------------------------------------
  function void UartRxCoverage::write(UartRxTransaction t);
      data =0;
      data =  t.receivingData;
      UartRxCovergroup.sample(uartRxAgentConfig,data);
  endfunction : write

  //--------------------------------------------------------------------------------------------
  // Function: report_phase
  //  Used for reporting the coverage instance percentage values
  //--------------------------------------------------------------------------------------------
  function void  UartRxCoverage::report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("******************** UART RX Agent Coverage = %0.2f %% *********************",  UartRxCovergroup.get_coverage()), UVM_NONE);
  endfunction: report_phase

`endif
