//-------------------------------------------------------
// Importing Uart global package
//-------------------------------------------------------
import UartGlobalPkg::*;

//--------------------------------------------------------------------------------------------
// Interface : UartTxDriverBfm
//  Used as the HDL driver for Uart
//  It connects with the HVL driver_proxy for driving the stimulus
//--------------------------------------------------------------------------------------------
interface UartTxDriverBfm (input  logic   clk,
                           input  logic   reset,
                           output logic   tx
                          );
	//-------------------------------------------------------
  // Importing uvm package file
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh"
	
  //-------------------------------------------------------
  // Importing the Transmitter package file
  //-------------------------------------------------------
  import UartTxPkg::*;
  
  //Variable: name
  //Used to store the name of the interface
  string name = "UART_TRANSMITTER_DRIVER_BFM"; 
	
  
	//Variable: bclk
  //baud clock for uart transmisson/reception	
  bit baudClk;
  
  //Variable: baudDivisor
	//used to generate the baud clock
  int baudDivisor;

  //Variable: baudDivider
  //to count the no of baud clock cycles
  int countbClk = 0;	
  
  //Creating the handle for the proxy_driver
  UartTxDriverProxy uartTxDriverProxy;

	// variable for data transfer state
  UartTransmitterStateEnum uartTransmitterState;
	
  //-------------------------------------------------------
  // Used to display the name of the interface
  //-------------------------------------------------------
  initial begin
    `uvm_info(name, $sformatf(name),UVM_LOW)
  end

  //------------------------------------------------------------------
  // Task: GenerateBaudClk
  // this task will calculate the baud divider based on sys clk frequency
  //-------------------------------------------------------------------
   task GenerateBaudClk(inout UartConfigStruct uartConfigStruct);
      real clkPeriodStartTime; 
      real clkPeriodStopTime;
      real clkPeriod;
      real clkFrequency;
      int baudDivisor;

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
  // this block will generate baud clk based on baud divider
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
	  tx = 1; //DRIVE THE UART TO IDEAL STATE
	  @(posedge reset);
	  uartTransmitterState = IDLE;
	  `uvm_info(name,$sformatf("RESET DEASSERTED"),UVM_LOW);
  endtask: WaitForReset
  
  //--------------------------------------------------------------------------------------------
  // Task: DriveToBfm
  //  This task will drive the data from bfm to proxy using converters
  //--------------------------------------------------------------------------------------------
  task DriveToBfm(inout UartTxPacketStruct uartTxPacketStruct , inout UartConfigStruct uartConfigStruct);
		SampleData(uartTxPacketStruct , uartConfigStruct);
  endtask: DriveToBfm
  
  // Task: To compute Even Parity
	task evenParityCompute(input UartConfigStruct uartConfigStruct,input UartTxPacketStruct uartTxPacketStruct,output tx);
	  case(uartConfigStruct.uartDataType)
	    FIVE_BIT: tx = ^(uartTxPacketStruct.transmissionData[4:0]);
	    SIX_BIT :tx = ^(uartTxPacketStruct.transmissionData[5:0]);
	    SEVEN_BIT: tx = ^(uartTxPacketStruct.transmissionData[6:0]);
	    EIGHT_BIT : tx = ^(uartTxPacketStruct.transmissionData[7:0]);
	  endcase
	endtask 
	
  // Task: To compute Odd Parity
	task oddParityCompute(input UartConfigStruct uartConfigStruct,input UartTxPacketStruct uartTxPacketStruct,output tx);
	  case(uartConfigStruct.uartDataType)
	      FIVE_BIT: tx = ~^(uartTxPacketStruct.transmissionData[4:0]);
	      SIX_BIT :tx = ~^(uartTxPacketStruct.transmissionData[5:0]);
	      SEVEN_BIT: tx = ~^(uartTxPacketStruct.transmissionData[6:0]);
	      EIGHT_BIT : tx = ~^(uartTxPacketStruct.transmissionData[7:0]);
	  endcase
	endtask

  //--------------------------------------------------------------------------------------------
  // Task: sample_data
  //  This task will send the data to the uart interface based on oversamplingClk
  //--------------------------------------------------------------------------------------------

	task SampleData(inout UartTxPacketStruct uartTxPacketStruct , inout UartConfigStruct uartConfigStruct);
		repeat(1) @(posedge baudClk);
		// driving start bit 
		tx = START_BIT;
		uartTransmitterState = STARTBIT;

		// driving data bits 
		for( int i=0 ; i< uartConfigStruct.uartDataType ; i++) begin
			repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
			tx = uartTxPacketStruct.transmissionData[i];
			uartTransmitterState = UartTransmitterStateEnum'(i + 3);
		end

		// driving parity bit
		if(uartConfigStruct.uartParityEnable ==1) begin 
			if(uartConfigStruct.uartParityErrorInjection==0) begin 
				if(uartConfigStruct.uartParityType == EVEN_PARITY)begin
					repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
					evenParityCompute(uartConfigStruct,uartTxPacketStruct,tx);
					uartTransmitterState = PARITYBIT;
				end
				else if (uartConfigStruct.uartParityType == ODD_PARITY) begin 
					repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
					oddParityCompute(uartConfigStruct,uartTxPacketStruct,tx);
					uartTransmitterState = PARITYBIT;
				end 
			end
			else begin 
				if(uartConfigStruct.uartParityType == EVEN_PARITY)begin
					repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
					oddParityCompute(uartConfigStruct,uartTxPacketStruct,tx);
					uartTransmitterState = PARITYBIT;
				end 
				else if(uartConfigStruct.uartParityType == ODD_PARITY) begin
					repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
					evenParityCompute(uartConfigStruct,uartTxPacketStruct,tx);
					uartTransmitterState = PARITYBIT;
				end 
			end 
		end

		// driving stop bit
		repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
		if(uartConfigStruct.uartFramingErrorInjection == 0 && uartConfigStruct.uartBreakingErrorInjection == 0)begin 
			tx = STOP_BIT;  
			uartTransmitterState = STOPBIT;
			repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
			if(uartConfigStruct.uartStopBit == TWO_BIT) begin
				uartTransmitterState = STOPBIT;
				repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
			end
			uartTransmitterState = IDLE;
		end 
					
		else if(uartConfigStruct.uartFramingErrorInjection == 1 && uartConfigStruct.uartBreakingErrorInjection == 0) begin
			tx='b x;
			uartTransmitterState = STOPBIT;
			repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
			if(uartConfigStruct.uartStopBit == TWO_BIT) begin
				uartTransmitterState = STOPBIT;
				repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
			end
			tx=1;
			uartTransmitterState = IDLE;
		end
					
		else if(uartConfigStruct.uartBreakingErrorInjection == 1)begin 
			tx = 'b 0;  
			uartTransmitterState = STOPBIT;
			repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
			if(uartConfigStruct.uartStopBit == TWO_BIT) begin
				uartTransmitterState = STOPBIT;
				repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
			end
			tx=1;
			uartTransmitterState = IDLE;
		end 
	endtask
	
endinterface : UartTxDriverBfm
