
`timescale 1ns/1ps
//-------------------------------------------------------
// Importing Uart global package
//-------------------------------------------------------
import UartGlobalPkg::*;

//--------------------------------------------------------------------------------------------
// Interface : UartRxDriverBfm
//  Used as the HDL driver for Uart
//  It connects with the HVL driver_proxy for driving the stimulus
//--------------------------------------------------------------------------------------------
interface UartRxDriverBfm (input  bit clk,
                           input  bit   reset,
                           output bit  rx
                           );

  //-------------------------------------------------------
  // Importing uvm package file
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  //-------------------------------------------------------
  // Importing the Reciever package file
  //-------------------------------------------------------
  import UartRxPkg::*;
	
  //Variable: name
  //Used to store the name of the interface
	string name = "UART_RECIEVER_DRIVER_BFM"; 

  //Variable: bclk
  //baud clock for uart transmisson/reception
  bit baudClk;
   
  //Variable: oversampling_clk
	// clk used to sample the data
  bit oversamplingClk;
  
  //Variable: count
  // Counter to keep track of clock cycles
  int count = 0;  
  
  //Variable: baudDivisor
  //to Calculate baud rate divider
  int baudDivisor;

  //Variable: counTbclk
  //to count the no of baud clock cycles
  int countbClk = 0;	
  
  //Creating the handle for the proxy_driver
  UartRxDriverProxy uartRxDriverProxy;

 // variable for data transfer state
  UartTransmitterStateEnum uartTransmitterState;
   
  //-------------------------------------------------------
  // Used to display the name of the interface
  //-------------------------------------------------------
  initial begin
    `uvm_info(name, $sformatf(name),UVM_LOW)
  end

  //------------------------------------------------------------------
  // Task: bauddivCalculation
  // this task will calculate the baud divider based on sys clk frequency
  //-------------------------------------------------------------------
	
 	task GenerateBaudClk(inout UartConfigStruct uartConfigStruct);
		 real clkPeriodStartTime; 
		 real clkPeriodStopTime;
		 real clkPeriod;
		 real clkFrequency;
		 int baudDivisor;
		 int count;
		 @(posedge clk);
		 clkPeriodStartTime = $realtime;
		 @(posedge clk);
		 clkPeriodStopTime = $realtime; 
		 clkPeriod = clkPeriodStopTime - clkPeriodStartTime;
		 clkFrequency = ( 10 **9 )/ clkPeriod;

		 if(uartConfigStruct.OverSampledBaudFrequencyClk ==1)begin
		 baudDivisor = (clkFrequency)/(uartConfigStruct.uartOverSamplingMethod * uartConfigStruct.uartBaudRate); 
		 end 
		 else begin 
			 baudDivisor = (clkFrequency)/(uartConfigStruct.uartBaudRate);
		 end 
		BaudClkGenerator(baudDivisor);
	endtask
 
  //------------------------------------------------------------------
  // Task: baudclkgenerator
  // this task will generate baud clk based on baud divider
  //-------------------------------------------------------------------

  task BaudClkGenerator(input int baudDivisor);
		 static int count=0;
		 forever begin 
			@(posedge clk or negedge clk)
	
			 if(count == (baudDivisor-1))begin 
				 count <= 0;
				 baudClk <= ~baudClk;
			 end 
			 else begin 
				 count <= count +1;
			 end   
		 end
 endtask

	//-------------------------------------------------------
  // Task: WaitForReset
  //  Waiting for the system reset
  //-------------------------------------------------------

   task WaitForReset();
			@(negedge reset);
	  	`uvm_info(name,$sformatf("RESET DETECTED"),UVM_LOW);
		   uartTransmitterState = RESET;
		   rx = 1; //DRIVE THE UART TO IDEAL STATE
		   @(posedge reset);
		   uartTransmitterState = IDLE;
		  `uvm_info(name,$sformatf("RESET DEASSERTED"),UVM_LOW);
   endtask: WaitForReset
  
  //--------------------------------------------------------------------------------------------
  // Task: DriveToBfm
  //  This task will drive the data from bfm to proxy using converters
  //--------------------------------------------------------------------------------------------

	task DriveToBfm(inout UartRxPacketStruct uartRxPacketStruct , inout UartConfigStruct uartConfigStruct);  
     SampleData(uartRxPacketStruct , uartConfigStruct);
  endtask: DriveToBfm

  //--------------------------------------------------------------------------------------------
	// Task to compute Even Parity
	//--------------------------------------------------------------------------------------------
  task evenParityCompute(input UartConfigStruct uartConfigStruct,input UartRxPacketStruct uartRxPacketStruct,output rx);
		case(uartConfigStruct.uartDataType)
			FIVE_BIT: rx = ^(uartRxPacketStruct.receivingData[4:0]);
			SIX_BIT :rx = ^(uartRxPacketStruct.receivingData[5:0]);
			SEVEN_BIT: rx = ^(uartRxPacketStruct.receivingData[6:0]);
			EIGHT_BIT : rx = ^(uartRxPacketStruct.receivingData[7:0]);
	 	endcase
  endtask 
	
	//--------------------------------------------------------------------------------------------
	// Task to compute Odd Parity
	//--------------------------------------------------------------------------------------------
  task oddParityCompute(input UartConfigStruct uartConfigStruct,input UartRxPacketStruct uartRxPacketStruct,output rx);
		case(uartConfigStruct.uartDataType)
			FIVE_BIT: rx = ~^(uartRxPacketStruct.receivingData[4:0]);
			SIX_BIT :rx = ~^(uartRxPacketStruct.receivingData[5:0]);
			SEVEN_BIT: rx = ~^(uartRxPacketStruct.receivingData[6:0]);
			EIGHT_BIT : rx = ~^(uartRxPacketStruct.receivingData[7:0]);
    endcase
 	endtask
  
  //--------------------------------------------------------------------------------------------
  // Task: sample_data
  //  This task will send the data to the uart interface based on oversampling_clk
  //--------------------------------------------------------------------------------------------
  
  task SampleData(inout UartRxPacketStruct uartRxPacketStruct , inout UartConfigStruct uartConfigStruct);
  	repeat(1) @(posedge baudClk);
    // driving start bit 
		if(uartConfigStruct.OverSampledBaudFrequencyClk ==1)begin 
	  	rx = START_BIT;
	    uartTransmitterState = STARTBIT;

      // driving data bits 
	    for( int i=0 ; i< uartConfigStruct.uartDataType ; i++) begin
				repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
	      	rx = uartRxPacketStruct.receivingData[i];
	        uartTransmitterState = UartTransmitterStateEnum'(i + 3);
	    	end

      // driving parity bit
	    if(uartConfigStruct.uartParityEnable ==1) begin 
	      if(uartConfigStruct.uartParityErrorInjection==0) begin 
	        if(uartConfigStruct.uartParityType == EVEN_PARITY)begin
						repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
		  	    evenParityCompute(uartConfigStruct,uartRxPacketStruct,rx);
			    	uartTransmitterState = PARITYBIT;
	        end
	        else if (uartConfigStruct.uartParityType == ODD_PARITY) begin 
		   			repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
		     		oddParityCompute(uartConfigStruct,uartRxPacketStruct,rx);
		     		uartTransmitterState = PARITYBIT;
	        end 
	      end
	      else begin 
	        if(uartConfigStruct.uartParityType == EVEN_PARITY)begin
		   			repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
	          oddParityCompute(uartConfigStruct,uartRxPacketStruct,rx);
		     		uartTransmitterState = PARITYBIT;
	        end 
	        else if(uartConfigStruct.uartParityType == ODD_PARITY) begin
		   			repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
		      	evenParityCompute(uartConfigStruct,uartRxPacketStruct,rx);
		      	uartTransmitterState = PARITYBIT;
	      	end 
	      end 
	    end

	    // driving stop bit
		  repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
		  if(uartConfigStruct.uartFramingErrorInjection == 0 && uartConfigStruct.uartBreakingErrorInjection == 0)begin 
				rx = STOP_BIT;  
	    	uartTransmitterState = STOPBIT;
		    repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
	   		uartTransmitterState = IDLE;
	    end 
		  else if(uartConfigStruct.uartFramingErrorInjection == 1 && uartConfigStruct.uartBreakingErrorInjection == 0) begin
				rx='b x;
		    uartTransmitterState = STOPBIT;
		    repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
				rx=1;
				uartTransmitterState = IDLE;
			end
		  else if(uartConfigStruct.uartBreakingErrorInjection == 1)begin 
				rx = 'b 0;  
				uartTransmitterState = STOPBIT;
				repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
				rx=1;
	   		uartTransmitterState = IDLE;
			end 
		end
		else if(uartConfigStruct.OverSampledBaudFrequencyClk ==0)begin
		// driving start bit
			@(posedge baudClk);
			rx =START_BIT;
			uartTransmitterState = STARTBIT;
			// driving data bits
			for( int i=0 ; i< uartConfigStruct.uartDataType ; i++) begin
				@(posedge baudClk)
				rx = uartRxPacketStruct.receivingData[i];
			  uartTransmitterState = UartTransmitterStateEnum'(i+3);
			end 

	 // driving parity bit
			if(uartConfigStruct.uartParityEnable ==1) begin
				if(uartConfigStruct.uartParityErrorInjection==0) begin
					if(uartConfigStruct.uartParityType == EVEN_PARITY)begin
						@(posedge baudClk)
		  			evenParityCompute(uartConfigStruct,uartRxPacketStruct,rx);
					end 
			   	else if(uartConfigStruct.uartParityType == ODD_PARITY) begin
						@(posedge baudClk)
		  			oddParityCompute(uartConfigStruct,uartRxPacketStruct,rx);
					end 
	  		end 
					else begin 
	          if(uartConfigStruct.uartParityType == EVEN_PARITY)begin
		  				@(posedge baudClk)
		  	   		oddParityCompute(uartConfigStruct,uartRxPacketStruct,rx);
							end 
						else if(uartConfigStruct.uartParityType == ODD_PARITY) begin
		  				@(posedge baudClk)
		  	   		evenParityCompute(uartConfigStruct,uartRxPacketStruct,rx);
						end 
					end 
				end 

	// driving stop bit
	    @(posedge baudClk)
			rx =STOP_BIT;
			uartTransmitterState = STOPBIT;
	  end 
	endtask
endinterface : UartRxDriverBfm
