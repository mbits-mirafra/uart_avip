`ifndef UARTSCOREBOARD_INCLUDED_
`define UARTSCOREBOARD_INCLUDED_

//--------------------------------------------------------------------------------------------
// Class: UartScoreboard
// Used to compare the data sent/received by the master with the slave's data sent/received
//--------------------------------------------------------------------------------------------

import UartGlobalPkg :: *;

 typedef struct { int packetNum;
                  bit[7:0] transmissionData;
                  bit[7:0] receivingData;
                  bit [7:0] errorBitNo;
                  bit match;
                  bit parity;
                  bit parityError;
                  bit breakingError;
                  bit framingError;} UartNoOfPacketsStruct;


class UartScoreboard extends uvm_scoreboard;
  `uvm_component_utils(UartScoreboard)

  //Declaring handle for struct
  UartNoOfPacketsStruct uartNoOfPacketsStruct[$];
  UartNoOfPacketsStruct tempStruct;

  //Declaring handle to keep the count of packets
  int packetCount = 0;

  //Declaring Tx class handle and Rx class hamdle
  UartTxTransaction uartTxTransaction;
  UartRxTransaction uartRxTransaction;

  //Variable: uartScoreboardTxAnalysisExport
  //Declaring analysis export for transmitting  Tx transaction object to scoreboard
  uvm_analysis_export #(UartTxTransaction) uartScoreboardTxAnalysisExport;


  //Variable: uartScoreboardRxAnalysisExport
  //Declaring analysis export for transmitting  Rx transaction object to scoreboard
  uvm_analysis_export #(UartRxTransaction) uartScoreboardRxAnalysisExport;

  //Variable: uartScoreboardTxAnalysisFifo
  //Used to store the uart Tx transaction
  uvm_tlm_analysis_fifo #(UartTxTransaction) uartScoreboardTxAnalysisFifo;

  //Variable: uartScoreboardRxAnalysisFifo
  //Used to store the uart Rx transaction
  uvm_tlm_analysis_fifo #(UartRxTransaction) uartScoreboardRxAnalysisFifo;

  //Variable: uartTxAgentConfig
  //Declaring handle for uart transmitter agent
  UartTxAgentConfig uartTxAgentConfig;

  //Variable: uartRxAgentConfig
  //Declaring handle for uart reciever agent
  UartRxAgentConfig uartRxAgentConfig;

  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new( string name = "UartScoreboard" , uvm_component parent = null);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern task compareTxRx(UartTxTransaction uartTxTransaction,UartRxTransaction uartRxTransaction);
  extern function void report_phase(uvm_phase phase);

 endclass : UartScoreboard

//--------------------------------------------------------------------------------------------
// Construct: new
// Initialization of new memory
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------

//--------------------------------------------------------------------------------------------
// Construct: new
// Initialization of new memory
//  name - UartScoreboard
//  parent - parent under which this component is created
//--------------------------------------------------------------------------------------------
 
function UartScoreboard :: new(string name = "UartScoreboard" , uvm_component parent = null);
  super.new(name, parent);
endfunction : new
 
//--------------------------------------------------------------------------------------------
// Function: build_phase
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------
function void UartScoreboard :: build_phase(uvm_phase phase);
  super.build_phase(phase);
  uartScoreboardTxAnalysisExport = new("uartScoreboardTxAnalysisExport",this);
  uartScoreboardRxAnalysisExport = new("uartScoreboardRxAnalysisExport",this);
  uartScoreboardTxAnalysisFifo = new("uartScoreboardTxAnalysisFifo",this);
  uartScoreboardRxAnalysisFifo = new("uartScoreboardRxAnalysisFifo",this);
 
if(!uvm_config_db #(UartTxAgentConfig) :: get(this,"","uartTxAgentConfig",uartTxAgentConfig))
   `uvm_fatal ("No vif", {"Config_db Error:", get_full_name (), ".vif"});
if(!uvm_config_db #(UartRxAgentConfig) :: get(this,"","uartRxAgentConfig",uartRxAgentConfig))
   `uvm_fatal ("No vif", {"Config_db Error:", get_full_name (), ".vif"});
 
endfunction : build_phase

function void UartScoreboard :: connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  uartScoreboardTxAnalysisExport.connect(uartScoreboardTxAnalysisFifo.analysis_export);
  uartScoreboardRxAnalysisExport.connect(uartScoreboardRxAnalysisFifo.analysis_export);
endfunction : connect_phase

//--------------------------------------------------------------------------------------------
// Task: run_phase
// Used to give delays and check the transmitted and recieved data are similar or not
//
// Parameters:
//  phase - uvm phase
//--------------------------------------------------------------------------------------------

task UartScoreboard :: run_phase(uvm_phase phase);

  super.run_phase(phase);

  forever begin

    uartScoreboardTxAnalysisFifo.get(uartTxTransaction);
    `uvm_info(get_type_name(),$sformatf("Printing transmissionData= %b", uartTxTransaction.transmissionData),UVM_LOW)

    uartScoreboardRxAnalysisFifo.get(uartRxTransaction);
   `uvm_info(get_type_name(),$sformatf("Printing receivingData= %b", uartRxTransaction.receivingData),UVM_LOW)

    compareTxRx(uartTxTransaction,uartRxTransaction);
  end

endtask : run_phase


task UartScoreboard :: compareTxRx(UartTxTransaction uartTxTransaction,UartRxTransaction uartRxTransaction);

    bit packetMatch = 1;

       foreach(uartTxTransaction.transmissionData[i])
          begin
           if(uartTxTransaction.transmissionData[i] != uartRxTransaction.receivingData[i])
             begin
               tempStruct.errorBitNo[i] = 1;
               packetMatch = 0;

              `uvm_info(get_type_name(),$sformatf("Bit mismatch = %0d",i),UVM_LOW)
              `uvm_info(get_type_name(),$sformatf("TransmissionData = %b,RecievingData = %b",uartTxTransaction.transmissionData[i],uartRxTransaction.receivingData[i]),UVM_LOW)
             end
           else
             begin
                tempStruct.errorBitNo[i] = 0;
                `uvm_info(get_type_name(),$sformatf("Bit Match = %0d",i),UVM_LOW)
                `uvm_info(get_type_name(),$sformatf("TransmissionData = %b,RecievingData = %b",uartTxTransaction.transmissionData[i],uartRxTransaction.receivingData[i]),UVM_LOW)
             end
           end

           if((uartTxAgentConfig.hasParity && uartRxAgentConfig.hasParity) == 1)
             begin
              if(uartTxTransaction.parity ^ uartRxTransaction.parity)
                 begin
                   packetMatch = 0;
                   `uvm_error(get_type_name(),$sformatf("Parity mismatch"))
                 end
             end

           else
            begin
              `uvm_info(get_type_name(),$sformatf("No parity"),UVM_LOW)
            end

           if(uartTxTransaction.parityError ^ uartRxTransaction.parityError)
             begin
               packetMatch = 0;
               `uvm_error(get_type_name(),$sformatf("Parity Error Occured"))
             end

           if(uartTxTransaction.framingError ^ uartRxTransaction.framingError)
             begin
               packetMatch = 0;
               `uvm_error(get_type_name(),$sformatf("Framing Error Occured"))
             end

           if(uartTxTransaction.breakingError ^ uartRxTransaction.breakingError)
             begin
               packetMatch = 0;
               `uvm_error(get_type_name(),$sformatf("Breaking Error Occured"))
             end
          packetCount++;

          if(packetMatch)
            begin
              `uvm_info(get_type_name(), "PACKET MATCH SUCCESSFUL", UVM_LOW)
            end
          else
            begin
             `uvm_error(get_type_name(), "PACKET MISMATCH")
            end

            `uvm_info(get_type_name(),$sformatf("\n transmissionData:%b\n receivingData:%b\n tx parity:%0b rx parity:%0b\n tx framingError:%0b rx framingError:%0b\n tx parityError:%0b rx parityError:%0b\n tx breakingError:%0b rx breakingError:%0b",uartTxTransaction.transmissionData,uartRxTransaction.receivingData,uartTxTransaction.parity,uartRxTransaction.parity,uartTxTransaction.framingError,uartRxTransaction.framingError,uartTxTransaction.parityError,uartRxTransaction.parityError,uartTxTransaction.breakingError,uartRxTransaction.breakingError),UVM_LOW)



            tempStruct = '{packetNum: packetCount,
                           transmissionData: uartTxTransaction.transmissionData,
                           receivingData: uartRxTransaction.receivingData,
                           match: packetMatch,
                           parity: uartTxTransaction.parity ^ uartRxTransaction.parity,
                           parityError: uartTxTransaction.parityError ^ uartRxTransaction.parityError,
                           breakingError: uartTxTransaction.breakingError ^ uartRxTransaction.breakingError,
                           framingError: uartTxTransaction.framingError ^ uartRxTransaction.framingError,
                           errorBitNo: tempStruct.errorBitNo};
            uartNoOfPacketsStruct.push_back(tempStruct);

endtask : compareTxRx

function void UartScoreboard:: report_phase(uvm_phase phase);
  super.report_phase(phase);
  foreach (uartNoOfPacketsStruct[i]) begin
  $display("----------------------------------------------------------------------------------------------------------------------------------------");
  `uvm_info(get_type_name(), $sformatf("\nPacket %0d Summary:\n TransmissionData:%b\n RecievingData:%b\n %0s\n %0s\n %0s\n %0s\n %0s\n",uartNoOfPacketsStruct[i].packetNum,uartNoOfPacketsStruct[i].transmissionData,uartNoOfPacketsStruct[i].receivingData,uartNoOfPacketsStruct[i].match?"Packet matched":"Packet mismatched", uartNoOfPacketsStruct[i].parity?"Parity mismatch":"Parity match",uartNoOfPacketsStruct[i].parityError?"Parity Error mismatch":"Parity Error match",uartNoOfPacketsStruct[i].breakingError?"Breaking Error mismatch":"Breaking Error match",uartNoOfPacketsStruct[i].framingError?"Framing Error mismatch":"Framing Error match"), UVM_LOW)

  $display("----------------------------------------------------------------------------------------------------------------------------------------");
  end
endfunction

`endif
