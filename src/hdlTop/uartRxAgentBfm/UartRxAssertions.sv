`ifndef UARTRXASSERTIONS_INCLUDED_
`define UARTRXASSERTIONS_INCLUDED_

import UartGlobalPkg :: *;
interface UartRxAssertions ( input bit uartClk , input logic uartRx);
  import uvm_pkg :: *;
  `include "uvm_macros.svh"
  import UartRxPkg ::UartRxAgentConfig;
  UartRxAgentConfig uartRxAgentConfig;

  int localWidth = 0;
  bit uartStopDetectInitiation;
  bit uartDataWidthDetectInitiation;
  bit uartEvenParityDetectionInitiation;
  bit uartOddParityDetectionInitiation;
  logic [ DATA_WIDTH-1:0]uartLocalData;
  bit uartParityEnabled;
  bit uartStartDetectInitiation;
  bit parity;
  int uartLegalDataWidth;
  parityTypeEnum uartEvenOddParity;
  overSamplingEnum overSamplingMethod;
  bit parityError;
	bit framingError;
	bit breakingError;
  
  initial begin 
  start_of_simulation_ph.wait_for_state(UVM_PHASE_STARTED);
    if(!(uvm_config_db#(UartRxAgentConfig) :: get(null,"","uartRxAgentConfig",uartRxAgentConfig)))
      `uvm_fatal("[Rx ASSERTION]","FAILED TO GET CONFIG OBJECT")
      uartParityEnabled = uartRxAgentConfig.hasParity;
      uartStartDetectInitiation = 1;
      uartEvenOddParity = uartRxAgentConfig.uartParityType;
      uartLegalDataWidth = uartRxAgentConfig.uartDataType;
      overSamplingMethod = uartRxAgentConfig.uartOverSamplingMethod;
      framingError = uartRxAgentConfig.framingErrorInjection;
      parityError = uartRxAgentConfig.parityErrorInjection;
      breakingError = uartRxAgentConfig.breakingErrorInjection;
  end 

  function evenParityCompute();
    case(uartRxAgentConfig.uartDataType)
    FIVE_BIT : parity=^(uartLocalData[4:0]);
    SIX_BIT : parity=^(uartLocalData[5:0]);
    SEVEN_BIT : parity=^(uartLocalData[6:0]);
    EIGHT_BIT : parity=^(uartLocalData[7:0]);
    endcase
    $display("PARITY IN ASSERTION IS %b",parity);
    return parity;
  endfunction 
  
  
  function oddParityCompute();
    case(uartRxAgentConfig.uartDataType)
      FIVE_BIT : parity=~^(uartLocalData[4:0]);
      SIX_BIT : parity=~^(uartLocalData[5:0]);
      SEVEN_BIT : parity=~^(uartLocalData[6:0]);
      EIGHT_BIT : parity=~^(uartLocalData[7:0]);
    endcase
    $display("PARITY IN ASSERTION IS %b",parity);
    return parity;
  endfunction 

  always@(posedge uartClk) begin 
    if(!(uartStartDetectInitiation))begin
      repeat((uartRxAgentConfig.uartOverSamplingMethod)-1)
       @(posedge uartClk);
      if(uartRxAgentConfig.uartDataType !=localWidth)begin 
      uartLocalData = {uartLocalData,uartRx};
      localWidth++;
      end

      if(localWidth == (uartRxAgentConfig.uartDataType))begin
        if(uartParityEnabled == 1)begin 
          if(uartEvenOddParity == EVEN_PARITY)begin
            uartEvenParityDetectionInitiation = 1;
            uartOddParityDetectionInitiation = 0;
          end 
          else begin 
            uartEvenParityDetectionInitiation = 0;
            uartOddParityDetectionInitiation = 1;
          end 
          uartDataWidthDetectInitiation = 1;
          repeat((uartRxAgentConfig.uartOverSamplingMethod))@(posedge uartClk);
          uartStopDetectInitiation = 1;
        end 
        else begin 
          uartDataWidthDetectInitiation = 1;
          uartStopDetectInitiation = 1;
        end 
      end
    end

  end 

  property start_bit_detection_property;
    @(posedge  uartClk) disable iff(!(uartStartDetectInitiation))
    (!($isunknown(uartRx)) && uartRx) |-> first_match( (##[0:500] $fell(uartRx)));

  endproperty

  IF_THERE_IS_FALLINGEDGE_ASSERTION_PASS: assert property (start_bit_detection_property)begin 
    if(uartStartDetectInitiation == 1) begin
      $info("*******************************START BIT DETECTED : ASSERTION PASS");
      uartStartDetectInitiation = 0;
    end
  end 
  else 
    $error("FAILED TO DETECT START BIT : ASSERTION FAILED");
    
  property data_width_check_property;
    @(posedge uartClk) disable iff(!(uartDataWidthDetectInitiation))

    if(overSamplingMethod==OVERSAMPLING_16)  ##16 localWidth == uartLegalDataWidth
   else if (overSamplingMethod==OVERSAMPLING_13)  ##13 localWidth == uartLegalDataWidth;

   endproperty 

  CHECK_FOR_DATA_WIDTH_LENGTH : assert property (data_width_check_property)begin
    $info("*****************************DATA WIDTH IS MATCHING : ASSERTION PASS ");
    uartDataWidthDetectInitiation = 0;
    uartStartDetectInitiation = 1;
    localWidth=0;
    end 
    else begin
      $error("DATA WIDTH MATCH FAILED : ASSERTION FAILED ");
      uartDataWidthDetectInitiation = 0;
      localWidth=0;

    end 

  property even_parity_check;
		@(posedge uartClk) disable iff((!uartEvenParityDetectionInitiation) || parityError || breakingError)
  
    if(overSamplingMethod==OVERSAMPLING_16) ##16 uartRx==evenParityCompute()
    else if(overSamplingMethod==OVERSAMPLING_13) ##13 uartRx==evenParityCompute();
  endproperty 
    
  CHECK_FOR_EVEN_PROPERTY : assert property (even_parity_check)begin 
    $info("*********************EVEN PARITY IS DETECTED : ASSERTION PASS ");
    uartEvenParityDetectionInitiation = 0;

    end 
    else begin 
      $error("EVEN PARITY NOT DETECTED : ASSERTION FAIL ");
      uartEvenParityDetectionInitiation = 0;
    end 

  property odd_parity_check;
		@(posedge uartClk) disable iff((!uartOddParityDetectionInitiation) || parityError || breakingError)
  if(overSamplingMethod==OVERSAMPLING_16) ##16 uartRx==oddParityCompute()
  else if(overSamplingMethod==OVERSAMPLING_13) ##13 uartRx==oddParityCompute();
  endproperty 
    
  CHECK_FOR_ODD_PROPERTY : assert property (odd_parity_check)begin 
    $info("***********************ODD PARITY IS DETECTED : ASSERTION PASS ");
    uartOddParityDetectionInitiation = 0;
    end 
    else begin 
      $error("Odd PARITY NOT DETECTED : ASSERTION FAIL ");
      uartOddParityDetectionInitiation = 0;
    end 
  property stop_bit_detection_property;
		@(posedge uartClk) disable iff ((!uartStopDetectInitiation) || framingError || breakingError)
    if(overSamplingMethod==OVERSAMPLING_16) ##16 uartRx
    else if(overSamplingMethod==OVERSAMPLING_13) ##13 uartRx;
  endproperty

  CHECK_FOR_STOP_BIT : assert property(stop_bit_detection_property)begin 
    $info("STOP BIT IS BEING DETECTED : ASSERTION PASS ");
    uartStopDetectInitiation = 0;
    uartStartDetectInitiation = 1;
    uartLocalData='b x;
    localWidth=0; 
    end 
    else begin 
      $error(" FAILED TO DETECT STOP BIT : ASSERTION FAIL ");
      uartStopDetectInitiation = 0;
      uartStartDetectInitiation = 1;
      uartLocalData='b x;

      uartLocalData=0;
    end

endinterface : UartRxAssertions

`endif
  
