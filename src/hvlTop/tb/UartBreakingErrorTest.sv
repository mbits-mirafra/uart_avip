`ifndef UARTBREAKINGERRORTEST_INCLUDED_
`define UARTBREAKINGERRORTEST_INCLUDED_ 

//--------------------------------------------------------------------------------------------
// Class:  UartBreakingErrorTest
// A test for Breaking error check
//--------------------------------------------------------------------------------------------
class UartBreakingErrorTest extends UartBaseTest;
 
   `uvm_component_utils(UartBreakingErrorTest)
    
   UartVirtualTransmissionSequenceWithPattern uartVirtualTransmissionSequenceWithPattern;
    //-------------------------------------------------------
    // Externally defined Tasks and Functions
    //-------------------------------------------------------
    extern function new(string name = "UartBreakingErrorTest" , uvm_component parent = null);
    extern virtual function void  build_phase(uvm_phase phase);
    extern virtual task run_phase(uvm_phase phase);

endclass : UartBreakingErrorTest
		     
//--------------------------------------------------------------------------------------------
// Constructor:new
//
// Paramters:
//
// parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
function UartBreakingErrorTest :: new(string name = "UartBreakingErrorTest" , uvm_component parent = null);
  super.new(name,parent);
endfunction  : new
		          
//--------------------------------------------------------------------------------------------
// Function: build_phase
//  Create required ports
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartBreakingErrorTest :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  //uartEnvConfig.uartTxAgentConfig.uartOverSamplingMethod = OVERSAMPLING_16
// uartEnvConfig.uartTxAgentConfig.uartBaudRate =   BAUD_9600;
  uartEnvConfig.uartTxAgentConfig.uartDataType = EIGHT_BIT;
  uartEnvConfig.uartTxAgentConfig.uartParityType = EVEN_PARITY;
  uartEnvConfig.uartTxAgentConfig.uartStopBit = TWO_BIT;
  uartEnvConfig.uartTxAgentConfig.hasParity = PARITY_ENABLED;
  uartEnvConfig.uartTxAgentConfig.patternNeeded = 1;
  uartEnvConfig.uartTxAgentConfig.patternToTransmit = 8'b0;
  uartEnvConfig.uartTxAgentConfig.breakingErrorInjection = 1;

 // uartEnvConfig.uartRxAgentConfig.uartOverSamplingMethod = OVERSAMPLING_16;
  //uartEnvConfig.uartRxAgentConfig.uartBaudRate =   BAUD_9600;
  uartEnvConfig.uartRxAgentConfig.uartDataType = EIGHT_BIT;
  uartEnvConfig.uartRxAgentConfig.uartParityType = EVEN_PARITY;
  uartEnvConfig.uartRxAgentConfig.uartStopBit = TWO_BIT;
  uartEnvConfig.uartRxAgentConfig.hasParity = PARITY_ENABLED;
  uartEnvConfig.uartRxAgentConfig.breakingErrorInjection = 1;

endfunction  : build_phase
			         
				    
//--------------------------------------------------------------------------------------------
// task:body
// Creates the required ports
//
// Parameters:
// phase - stores the current phase
//------------------------------------------------------------------------------------------
task UartBreakingErrorTest:: run_phase(uvm_phase phase);
  uartVirtualTransmissionSequenceWithPattern = UartVirtualTransmissionSequenceWithPattern :: type_id :: create("uartVirtualTransmissionSequenceWithPattern");
  phase.raise_objection(this);
   uartVirtualTransmissionSequenceWithPattern.start(uartEnv.uartVirtualSequencer);
   #100000;
  phase.drop_objection(this);  
endtask : run_phase
`endif  
