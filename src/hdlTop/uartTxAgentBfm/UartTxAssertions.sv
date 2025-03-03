`ifndef UARTTXASSERTIONS_INCLUDED_
`define UARTTXASSERTIONS_INCLUDED_

import UartGlobalPkg :: *;
//import UartTxCoverParameter :: *;
interface UartTxAssertions ( input bit uartClk , input logic uartTx);
import uvm_pkg :: *;
`include "uvm_macros.svh"
import UartTxPkg ::UartTxAgentConfig;
UartTxAgentConfig uartTxAgentConfig;

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
	bit parityError;
	bit framingError;
	bit breakingError;

  overSamplingEnum overSamplingMethod;
  initial begin 
  start_of_simulation_ph.wait_for_state(UVM_PHASE_STARTED);
    if(!(uvm_config_db#(UartTxAgentConfig) :: get(null,"","uartTxAgentConfig",uartTxAgentConfig)))
			`uvm_fatal("[TX ASSERTION]","FAILED TO GET CONFIG OBJECT")
			uartParityEnabled = uartTxAgentConfig.hasParity;
			uartStartDetectInitiation = 1;
			uartEvenOddParity = uartTxAgentConfig.uartParityType;
			uartLegalDataWidth = uartTxAgentConfig.uartDataType;
			overSamplingMethod = uartTxAgentConfig.uartOverSamplingMethod;
			framingError = uartTxAgentConfig.framingErrorInjection;
			parityError = uartTxAgentConfig.parityErrorInjection;
			breakingError = uartTxAgentConfig.breakingErrorInjection;
  end 

  // Function to compute Even Parity
  function evenParityCompute();
    case(uartTxAgentConfig.uartDataType)
      FIVE_BIT : parity=^(uartLocalData[4:0]);
      SIX_BIT : parity=^(uartLocalData[5:0]);
      SEVEN_BIT : parity=^(uartLocalData[6:0]);
      EIGHT_BIT : parity=^(uartLocalData[7:0]);
    endcase
    $display("PARITY IN ASSERTION IS %b",parity);
    return parity;
  endfunction 
  
  // Function to compute Odd Parity
  function oddParityCompute();
    case(uartTxAgentConfig.uartDataType)
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
      repeat((uartTxAgentConfig.uartOverSamplingMethod)-1)
        @(posedge uartClk);
        if(uartTxAgentConfig.uartDataType !=localWidth)begin 
          uartLocalData = {uartLocalData,uartTx};
          localWidth++;
        end

      if(localWidth == (uartTxAgentConfig.uartDataType))begin
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
          repeat((uartTxAgentConfig.uartOverSamplingMethod))@(posedge uartClk);
          uartStopDetectInitiation = 1;
        end 
        else begin 
          uartDataWidthDetectInitiation = 1;
          uartStopDetectInitiation = 1;
        end 
      end
    end
 end 

	//Assertion to detect start bit
  property start_bit_detection_property;
    @(posedge  uartClk) disable iff(!(uartStartDetectInitiation))
		(!($isunknown(uartTx)) && uartTx) |-> first_match( (##[0:500] $fell(uartTx)));
	endproperty
	
  IF_THERE_IS_FALLINGEDGE_ASSERTION_PASS: assert property (start_bit_detection_property)begin 
    if(uartStartDetectInitiation == 1) begin
      $info("*******************************START BIT DETECTED : ASSERTION PASS");
      uartStartDetectInitiation = 0;
    end
  end 
  else 
    $error("FAILED TO DETECT START BIT : ASSERTION FAILED");

	//Assertion to check for data width
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
		
  //Assertion to check for even parity
  property even_parity_check;
		@(posedge uartClk) disable iff((!uartEvenParityDetectionInitiation ) || parityError || breakingError)
  
    if(overSamplingMethod==OVERSAMPLING_16) ##16 uartTx==evenParityCompute()
    else if(overSamplingMethod==OVERSAMPLING_13) ##13 uartTx==evenParityCompute();
  endproperty 
    
  CHECK_FOR_EVEN_PARITY : assert property (even_parity_check)begin 
    $info("*********************EVEN PARITY IS DETECTED : ASSERTION PASS ");
    uartEvenParityDetectionInitiation = 0;

    end 
    else begin 
      $error("EVEN PARITY NOT DETECTED : ASSERTION FAIL ");
      uartEvenParityDetectionInitiation = 0;
    end
		
  //Assertion to check for odd parity
  property odd_parity_check;
		@(posedge uartClk) disable iff((!uartOddParityDetectionInitiation) || parityError || breakingError)
  	if(overSamplingMethod==OVERSAMPLING_16) ##16 uartTx==oddParityCompute()
  	else if(overSamplingMethod==OVERSAMPLING_13) ##13 uartTx==oddParityCompute();
  endproperty 
    
  CHECK_FOR_ODD_PARITY : assert property (odd_parity_check)begin 
    $info("***********************8ODD PARITY IS DETECTED : ASSERTION PASS ");
    uartOddParityDetectionInitiation = 0;
    end 
    else begin 
      $error("Odd PARITY NOT DETECTED : ASSERTION FAIL ");
      uartOddParityDetectionInitiation = 0;
    end 

	//Assertion to detect stop bit
  property stop_bit_detection_property;
		@(posedge uartClk) disable iff ((!uartStopDetectInitiation) || framingError || breakingError)
    if(overSamplingMethod==OVERSAMPLING_16) ##16 uartTx
    else if(overSamplingMethod==OVERSAMPLING_13) ##13 uartTx;
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

endinterface : UartTxAssertions

`endif
