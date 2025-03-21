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
  UartVirtualTransmissionSequenceWithPattern uartVirtualTransmissionSequenceWithPattern;
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
  extern function void copyTxConfigToRx(inout UartTxAgentConfig uartTxAgentConfig ,inout  UartRxAgentConfig uartRxAgentConfig);
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
  uartEnvConfig.uartTxAgentConfig.uartOverSamplingMethod = OVERSAMPLING_16;
  uartEnvConfig.uartTxAgentConfig.uartBaudRate = BAUD_9600;
  uartEnvConfig.uartTxAgentConfig.patternNeeded = 1;
  uartEnvConfig.uartTxAgentConfig.patternToTransmit=0;

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
  uartEnvConfig.uartRxAgentConfig.is_active = UVM_PASSIVE;
  uartEnvConfig.uartRxAgentConfig.hasCoverage = 1;
  uartEnvConfig.uartRxAgentConfig.OverSampledBaudFrequencyClk =1;
  copyTxConfigToRx(uartEnvConfig.uartTxAgentConfig , uartEnvConfig.uartRxAgentConfig);
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
  uartVirtualTransmissionSequence= UartVirtualTransmissionSequence :: type_id :: create("uartVirtualTransmissionSequence");
  
  phase.raise_objection(this);
  repeat(uartEnvConfig.uartTxAgentConfig.packetsNeeded) begin

  if(uartEnvConfig.uartTxAgentConfig.randomize() with{hasParity==PARITY_ENABLED;})
  uartVirtualTransmissionSequence.setConfig(uartEnvConfig.uartTxAgentConfig);
  copyTxConfigToRx(uartEnvConfig.uartTxAgentConfig , uartEnvConfig.uartRxAgentConfig);

  uartVirtualTransmissionSequence.start(uartEnv.uartVirtualSequencer);
  end 
   phase.drop_objection(this);
endtask : run_phase

function void UartBaseTest :: copyTxConfigToRx(inout UartTxAgentConfig uartTxAgentConfig ,inout  UartRxAgentConfig uartRxAgentConfig);
       uartRxAgentConfig.hasParity =   uartTxAgentConfig.hasParity;
       uartRxAgentConfig.uartOverSamplingMethod =   uartTxAgentConfig.uartOverSamplingMethod;
       uartRxAgentConfig.uartBaudRate =   uartTxAgentConfig.uartBaudRate;
       uartRxAgentConfig.uartDataType =   uartTxAgentConfig.uartDataType;
       uartRxAgentConfig.uartParityType =  uartTxAgentConfig.uartParityType;
       uartRxAgentConfig.parityErrorInjection =  uartTxAgentConfig.parityErrorInjection;
       uartRxAgentConfig.framingErrorInjection =  uartTxAgentConfig.framingErrorInjection;
       uartRxAgentConfig.breakingErrorInjection =  uartTxAgentConfig.breakingErrorInjection;
       uartRxAgentConfig.uartStopBit =  uartTxAgentConfig.uartStopBit;

endfunction

`endif  

