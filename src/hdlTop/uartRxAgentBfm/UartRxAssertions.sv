`ifndef UARTRXASSERTIONS_INCLUDED_
`define UARTRXASSERTIONS_INCLUDED_

import UartGlobalPkg :: *;
interface UartRxAssertions ( input bit uartClk , input logic uartRx);
  import uvm_pkg :: *;
  `include "uvm_macros.svh"
  import UartRxPkg ::UartRxAgentConfig;
  UartRxAgentConfig uartRxAgentConfig;
  UartConfigStruct uartConfigStruct;
  int localWidth = 0;
  bit uartStopDetectInitiation;
  bit uartDataWidthDetectInitiation;
  bit uartEvenParityDetectionInitiation;
  bit uartOddParityDetectionInitiation;
  logic [ DATA_WIDTH-1:0]uartLocalData;
  bit uartParityEnabled;
  bit uartStartDetectInitiation=1;
  bit parity;

  int uartLegalDataWidth;
  parityTypeEnum uartEvenOddParity;
  overSamplingEnum overSamplingMethod;
  bit parityError;
	bit framingError;
	bit breakingError;
  
   always@(posedge uartClk) begin 
   if(!(uvm_config_db#(UartConfigStruct) :: get(null,"","uartConfigStruct",uartConfigStruct)))
      `uvm_fatal("[Rx ASSERTION]","FAILED TO GET CONFIG OBJECT")

      uartParityEnabled = uartConfigStruct.uartParityEnable;
      uartEvenOddParity = uartConfigStruct.uartParityType;
      uartLegalDataWidth = uartConfigStruct.uartDataType;
      overSamplingMethod = uartConfigStruct.uartOverSamplingMethod;
      framingError = uartConfigStruct.uartFramingErrorInjection;
      parityError = uartConfigStruct.uartParityErrorInjection;
      breakingError = uartConfigStruct.uartBreakingErrorInjection;
  end 

  function evenParityCompute();
    case(uartConfigStruct.uartDataType)
    FIVE_BIT : parity=^(uartLocalData[4:0]);
    SIX_BIT : parity=^(uartLocalData[5:0]);
    SEVEN_BIT : parity=^(uartLocalData[6:0]);
    EIGHT_BIT : parity=^(uartLocalData[7:0]);
    endcase
    $display("PARITY IN ASSERTION IS %b",parity);
    return parity;
  endfunction 
  
  
  function oddParityCompute();
    case(uartConfigStruct.uartDataType)
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
      repeat((uartConfigStruct.uartOverSamplingMethod)-1)
       @(posedge uartClk);
      if(uartConfigStruct.uartDataType !=localWidth)begin 
      uartLocalData = {uartLocalData,uartRx};
      localWidth++;
      end

      if(localWidth == (uartConfigStruct.uartDataType))begin
        if(uartParityEnabled == 1 &&parityError==0 && framingError==0 && breakingError==0)begin
          if(uartEvenOddParity == EVEN_PARITY)begin
            uartEvenParityDetectionInitiation = 1;
            uartOddParityDetectionInitiation = 0;
          end 
          else begin 
            uartEvenParityDetectionInitiation = 0;
            uartOddParityDetectionInitiation = 1;
          end 
          uartDataWidthDetectInitiation = 1;
          repeat((uartConfigStruct.uartOverSamplingMethod))@(posedge uartClk);
          	uartStopDetectInitiation = 1;
	  			repeat((uartConfigStruct.uartOverSamplingMethod))@(posedge uartClk);
	  				uartStartDetectInitiation = 1;

        end 
        else if(uartParityEnabled==1 && (parityError==1) && framingError==0 && breakingError==0)begin 
          uartDataWidthDetectInitiation = 1;
	  		repeat((uartConfigStruct.uartOverSamplingMethod))@(posedge uartClk);
          uartStopDetectInitiation = 1;
	  		repeat((uartConfigStruct.uartOverSamplingMethod))@(posedge uartClk);
	  			uartStartDetectInitiation = 1;

        end
			else if(uartParityEnabled == 1 && parityError ==0 &&(framingError ==1 || breakingError==1))begin 
           if(uartEvenOddParity == EVEN_PARITY) begin 
              uartEvenParityDetectionInitiation = 1;
	      			uartOddParityDetectionInitiation = 0;
        	end 
	   else begin 
	   uartEvenParityDetectionInitiation = 0;
	   uartOddParityDetectionInitiation = 1;
		end 
	    uartDataWidthDetectInitiation = 1;
	    repeat((uartConfigStruct.uartOverSamplingMethod)*2)@(posedge uartClk);
	   uartStartDetectInitiation = 1;
		end
		else if (uartParityEnabled == 1 && parityError ==1 &&(framingError ==1 || breakingError==1))begin
             uartDataWidthDetectInitiation = 1;
	     repeat((uartConfigStruct.uartOverSamplingMethod)*2)@(posedge uartClk);
	     uartStartDetectInitiation = 1;
    end 
		else if(uartParityEnabled ==0 &&(parityError==0 || parityError==1) && framingError==0 && breakingError==0) begin 
          uartDataWidthDetectInitiation = 1;
	  			uartStopDetectInitiation = 1;
	  repeat((uartConfigStruct.uartOverSamplingMethod))@(posedge uartClk);
          uartStartDetectInitiation = 1;
		end 
		else if(framingError ==1 || breakingError==1) begin 
           uartDataWidthDetectInitiation = 1;
           repeat((uartConfigStruct.uartOverSamplingMethod))@(posedge uartClk);
	   				uartStartDetectInitiation = 1;
			end 
    end
    end
 end 

  property start_bit_detection_property;
    @(posedge  uartClk) disable iff(!(uartStartDetectInitiation))
    (($isunknown(uartRx))  || uartRx) |-> first_match( (##[0:500] $fell(uartRx)));
	endproperty

  IF_THERE_IS_FALLINGEDGE_ASSERTION_PASS: assert property (start_bit_detection_property)begin 
    if(uartStartDetectInitiation == 1) begin
				$display("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n");
				$info("START BIT DETECTED IN RECEIVER: ASSERTION PASS");
	  		$display("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
				uartStartDetectInitiation = 0;
      	localWidth=0;
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
        $display("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n");
	      $info("DATA WIDTH MATCH DETECTED IN RECEIVER: ASSERTION PASS");
				$display("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    		uartDataWidthDetectInitiation = 0;
    		localWidth=0;
    		uartLocalData = 'b x;
    end 
    else begin
      $error("DATA WIDTH MATCH FAILED : ASSERTION FAILED ");
      uartDataWidthDetectInitiation = 0;
      localWidth=0;
      uartLocalData= 'b x;
    end 

  property even_parity_check;
		@(posedge uartClk) disable iff((!uartEvenParityDetectionInitiation) )
  
    if(overSamplingMethod==OVERSAMPLING_16) ##16 uartRx==evenParityCompute()
    else if(overSamplingMethod==OVERSAMPLING_13) ##13 uartRx==evenParityCompute();
  endproperty 
    
  CHECK_FOR_EVEN_PARITY: assert property (even_parity_check)begin 
	 	$display("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n");
		$info("EVEN PARITY DETECTED IN RECEIVER: ASSERTION PASS");
		$display("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
		uartEvenParityDetectionInitiation = 0;
	end 
    else begin 
      $error("EVEN PARITY NOT DETECTED : ASSERTION FAIL ");
      uartEvenParityDetectionInitiation = 0;
    end 

  property odd_parity_check;
		@(posedge uartClk) disable iff((!uartOddParityDetectionInitiation))
  if(overSamplingMethod==OVERSAMPLING_16) ##16 uartRx==oddParityCompute()
  else if(overSamplingMethod==OVERSAMPLING_13) ##13 uartRx==oddParityCompute();
  endproperty 
    
  CHECK_FOR_ODD_PARITY : assert property (odd_parity_check)begin 
        $display("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n");
	      $info("ODD PARITY DETECTED IN RECEIVER: ASSERTION PASS");
				$display("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
				uartOddParityDetectionInitiation = 0;
    end 
    else begin 
			$error("ODD PARITY NOT DETECTED : ASSERTION FAIL ");
      uartOddParityDetectionInitiation = 0;
    end 
  property stop_bit_detection_property;
		@(posedge uartClk) disable iff ((!uartStopDetectInitiation) || framingError || breakingError)
    if(overSamplingMethod==OVERSAMPLING_16) ##16 uartRx
    else if(overSamplingMethod==OVERSAMPLING_13) ##13 uartRx;
  endproperty

  CHECK_FOR_STOP_BIT : assert property(stop_bit_detection_property)begin 
        $display("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! \n");
	      $info("STOP BIT DETECTED IN RECEIVER: ASSERTION PASS");
				$display("\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
    		uartStopDetectInitiation = 0;
    		uartLocalData='b x;
    		localWidth=0; 
    end 
    else begin 
      $error(" FAILED TO DETECT STOP BIT : ASSERTION FAIL ");
      uartStopDetectInitiation = 0;
      uartLocalData='b x;
      uartLocalData=0;
    end

endinterface : UartRxAssertions

`endif
  
