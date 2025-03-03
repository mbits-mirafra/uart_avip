`ifndef UARTBASETEST_INCLUDED_
`define UARTBASETEST_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class:  UartBaseTest
// Base test has the test scenarios for testbench which has the env, config, etc.
// Sequences are created and started in the test
//--------------------------------------------------------------------------------------------
class UartBaseTest extends uvm_test;
 
  `uvm_component_utils(UartBaseTest)
 
  UartVirtualTransmissionSequence uartVirtualTransmissionSequence;
  UartEnvConfig           uartEnvConfig;
  UartEnv                 uartEnv;
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "UartBaseTest" , uvm_component parent = null);
  extern virtual function void  build_phase(uvm_phase phase);
  extern virtual function void  setupUartEnvConfig();
  extern virtual function void  setupUartTxAgentConfig();
  extern virtual function void  setupUartRxAgentConfig();
  extern virtual function void  end_of_elaboration_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

endclass : UartBaseTest
   
//--------------------------------------------------------------------------------------------
// Constructor:new
//
// Paramters:
//
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartBaseTest :: new(string name = "UartBaseTest" , uvm_component parent = null);
  super.new(name,parent);
endfunction  : new
   
//--------------------------------------------------------------------------------------------
// Function: build_phase
//  Create required ports
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartBaseTest :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  setupUartEnvConfig();
  uartEnv = UartEnv :: type_id :: create("uartEnv" , this);
endfunction  : build_phase
   
//--------------------------------------------------------------------------------------------
// Function: setupUartEnvConfig
// Setup the environment configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
 function void UartBaseTest :: setupUartEnvConfig();
  uartEnvConfig = UartEnvConfig :: type_id :: create("uartEnvConfig");
  uartEnvConfig.hasScoreboard = 1;
  uartEnvConfig.hasVirtualSequencer = 1;
  uvm_config_db #(UartEnvConfig) :: set(this,"*", "uartEnvConfig",uartEnvConfig);
  setupUartTxAgentConfig();
  setupUartRxAgentConfig();
endfunction : setupUartEnvConfig 

//--------------------------------------------------------------------------------------------
// Function:setupUartTxAgentConfig
// Setup the uart trasmitter agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
 function void UartBaseTest :: setupUartTxAgentConfig();
   
  uartEnvConfig.uartTxAgentConfig = UartTxAgentConfig :: type_id :: create("uartTxAgentConfig");
  uartEnvConfig.uartTxAgentConfig.packetsNeeded=NO_OF_PACKETS;
  uartEnvConfig.uartTxAgentConfig.is_active = UVM_ACTIVE;
  uartEnvConfig.uartTxAgentConfig.hasCoverage = 1;
  uartEnvConfig.uartTxAgentConfig.hasParity = PARITY_ENABLED;
  uartEnvConfig.uartTxAgentConfig.uartOverSamplingMethod = OVERSAMPLING_16;
  uartEnvConfig.uartTxAgentConfig.uartBaudRate = BAUD_9600;
  uartEnvConfig.uartTxAgentConfig.uartDataType = FIVE_BIT;
  uartEnvConfig.uartTxAgentConfig.uartParityType = EVEN_PARITY;
  uartEnvConfig.uartTxAgentConfig.parityErrorInjection = 0;
  uartEnvConfig.uartTxAgentConfig.framingErrorInjection = 0;
  uartEnvConfig.uartTxAgentConfig.patternNeeded = 0;
  uartEnvConfig.uartTxAgentConfig.patternToTransmit=10101010;
  uartEnvConfig.uartTxAgentConfig.breakingErrorInjection = 0;

  uartEnvConfig.uartTxAgentConfig.OverSampledBaudFrequencyClk =1;
  uvm_config_db #(UartTxAgentConfig) :: set(null,"*", "uartTxAgentConfig",uartEnvConfig.uartTxAgentConfig);

endfunction : setupUartTxAgentConfig
   
//--------------------------------------------------------------------------------------------
// Function: setupUartRxAgentConfig
// Setup the uart receiver agent configuration with the required values
// and store the handle into the config_db
//--------------------------------------------------------------------------------------------
 function void UartBaseTest :: setupUartRxAgentConfig();
  uartEnvConfig.uartRxAgentConfig = UartRxAgentConfig :: type_id :: create("uartRxAgentConfig");
  uartEnvConfig.uartRxAgentConfig.packetsNeeded=NO_OF_PACKETS;
  uartEnvConfig.uartRxAgentConfig.is_active = UVM_PASSIVE;
  uartEnvConfig.uartRxAgentConfig.hasCoverage = 1;
  uartEnvConfig.uartRxAgentConfig.hasParity = PARITY_ENABLED;
  uartEnvConfig.uartRxAgentConfig.uartOverSamplingMethod = OVERSAMPLING_16;
  uartEnvConfig.uartRxAgentConfig.uartBaudRate = BAUD_9600;
  uartEnvConfig.uartRxAgentConfig.uartDataType = FIVE_BIT;
  uartEnvConfig.uartRxAgentConfig.uartParityType = EVEN_PARITY;
  uartEnvConfig.uartRxAgentConfig.parityErrorInjection =0;
  uartEnvConfig.uartRxAgentConfig.framingErrorInjection = 0;
  uartEnvConfig.uartRxAgentConfig.OverSampledBaudFrequencyClk =1;
  uartEnvConfig.uartRxAgentConfig.patternNeeded = 0;
  uartEnvConfig.uartRxAgentConfig.patternToTransmit=10101010;
  uvm_config_db #(UartRxAgentConfig) :: set(null,"*", "uartRxAgentConfig",uartEnvConfig.uartRxAgentConfig);

endfunction : setupUartRxAgentConfig
   
//--------------------------------------------------------------------------------------------
// Function: end_of_elaboration_phase
// Used for printing the testbench topology
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartBaseTest :: end_of_elaboration_phase(uvm_phase phase); 
  super.end_of_elaboration_phase(phase);
  uvm_top.print_topology();
endfunction : end_of_elaboration_phase
   
//--------------------------------------------------------------------------------------------
// task:body
// Creates the required ports
//
// Parameters:
// phase - stores the current phase
//--------------------------------------------------------------------------------------------
 task UartBaseTest :: run_phase(uvm_phase phase);
  uartVirtualTransmissionSequence = UartVirtualTransmissionSequence :: type_id :: create("uartVirtualTransmissionSequence");
  uartVirtualTransmissionSequence.print();
  phase.raise_objection(this);
  uartVirtualTransmissionSequence.start(uartEnv.uartVirtualSequencer);
  #100000;
  phase.drop_objection(this);
endtask : run_phase

`endif  

