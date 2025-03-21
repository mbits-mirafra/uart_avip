	import UartGlobalPkg::*;
	//--------------------------------------------------------------------------------------------
	// Interface : UartRxMonitorBfm
	//  Connects the master monitor bfm with the master monitor prox
	//--------------------------------------------------------------------------------------------
	interface UartRxMonitorBfm (input  logic   clk,
	                            input  logic reset,
	                            input  logic   rx
	                           );
		
  //-------------------------------------------------------
  // Importing uvm package file
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh"
	
  string name = "UART_RECEIVER_MONITOR_BFM";
	
  //Variable: bclk
  //baud clock for uart transmisson/reception
	bit baudClk;

	logic [DATA_WIDTH+3 : 0]concatData;
	int numOfZeroes;
	int breakZeroCount;

	// enum variable for receiver states
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
		if(uartConfigStruct.OverSampledBaudFrequencyClk==1)begin
			baudDivisor = (clkFrequency)/(uartConfigStruct.uartOverSamplingMethod * uartConfigStruct.uartBaudRate);
		end
		else begin
			baudDivisor = (clkFrequency)/(uartConfigStruct.uartBaudRate);
		end
		BaudClkGenerator(baudDivisor);
  endtask
	
  //------------------------------------------------------------------
  // Task: BaudClkGenerator
  // this task will generate baud clk based on baud divider
  //-------------------------------------------------------------------
	task BaudClkGenerator(input int baudDiv);
		static int count=0;
		forever begin
			@(posedge clk or negedge clk)
			if(count == (baudDiv-1))begin
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
    `uvm_info(name, $sformatf("system reset activated"), UVM_LOW)
    uartTransmitterState = RESET;
    @(posedge reset);
    `uvm_info(name, $sformatf("system reset deactivated"), UVM_LOW)
     uartTransmitterState = IDLE;
  endtask: WaitForReset
	
	task StartMonitoring(inout UartRxPacketStruct uartRxPacketStruct , inout UartConfigStruct uartConfigStruct);
		Deserializer(uartRxPacketStruct,uartConfigStruct);
	endtask

	//--------------------------------------------------------------------------------------------
	// Function to compute Even Parity
	//--------------------------------------------------------------------------------------------
	function evenParityCompute(input UartConfigStruct uartConfigStruct,input UartRxPacketStruct uartRxPacketStruct);
	  bit parity;
	  case(uartConfigStruct.uartDataType)
	    FIVE_BIT: parity = ^(uartRxPacketStruct.receivingData[4:0]);
	    SIX_BIT :parity = ^(uartRxPacketStruct.receivingData[5:0]);
	    SEVEN_BIT: parity = ^(uartRxPacketStruct.receivingData[6:0]);
	    EIGHT_BIT : parity = ^(uartRxPacketStruct.receivingData[7:0]);
	  endcase
		return parity;
	endfunction

	//--------------------------------------------------------------------------------------------
	// Function to compute Even Parity
	//--------------------------------------------------------------------------------------------
	function oddParityCompute(input UartConfigStruct uartConfigStruct,input UartRxPacketStruct uartRxPacketStruct);
	  bit parity;
	  case(uartConfigStruct.uartDataType)
	      FIVE_BIT: parity = ~^(uartRxPacketStruct.receivingData[4:0]);
	      SIX_BIT :parity = ~^(uartRxPacketStruct.receivingData[5:0]);
	      SEVEN_BIT: parity = ~^(uartRxPacketStruct.receivingData[6:0]);
	      EIGHT_BIT : parity = ~^(uartRxPacketStruct.receivingData[7:0]);
	  endcase
		return parity;
	endfunction
	
  //-------------------------------------------------------
  // Task: DeSerializer
  //  converts serial data to parallel
  //-------------------------------------------------------
  task Deserializer(inout UartRxPacketStruct uartRxPacketStruct, inout UartConfigStruct uartConfigStruct);
	  @(negedge rx);
			repeat(uartConfigStruct.uartOverSamplingMethod/2) @(posedge baudClk);//needs this posedge or 1 cycle delay to avoid race around or delay in output
			uartTransmitterState = STARTBIT;
			concatData={concatData,rx};
	
			for( int i=0 ; i < uartConfigStruct.uartDataType ; i++) begin
				repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk); begin
					uartRxPacketStruct.receivingData[i] = rx;
					concatData={concatData,rx};
					uartTransmitterState = UartTransmitterStateEnum'(i+3);
				end
			end
			
			if(uartConfigStruct.uartParityEnable ==1) begin
				repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
				uartRxPacketStruct.parity = rx;
				concatData={concatData,rx};
				uartTransmitterState = PARITYBIT;
				parityCheck(uartConfigStruct,uartRxPacketStruct,rx);
			end
			
			repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
			concatData={concatData,rx};
			stopBitCheck(uartRxPacketStruct,uartConfigStruct,rx);
			
			if(uartConfigStruct.uartStopBit == 2) begin
				repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
				concatData={concatData,rx};
				if(uartRxPacketStruct.framingError == 0) begin
					stopBitCheck(uartRxPacketStruct,uartConfigStruct,rx);
				end
			end
			
			numOfZeroes=$countones(~(concatData));
			if(uartConfigStruct.uartStopBit == 2)
				breakZeroCount=uartConfigStruct.uartParityEnable ? (uartConfigStruct.uartDataType)+4 :(uartConfigStruct.uartDataType)+3;
			else
				breakZeroCount=uartConfigStruct.uartParityEnable ? (uartConfigStruct.uartDataType)+3 :(uartConfigStruct.uartDataType)+2;
			if(numOfZeroes == breakZeroCount)
				uartRxPacketStruct.breakingError =1;
			else 
				uartRxPacketStruct.breakingError =0;
	
			repeat(uartConfigStruct.uartOverSamplingMethod/2) @(posedge baudClk);
			concatData = 'b x;
			numOfZeroes =0;
			uartTransmitterState = IDLE;		
  endtask

	//--------------------------------------------------------------------------------------------
	// Task to check stop bit
	//--------------------------------------------------------------------------------------------
	task stopBitCheck (inout  UartRxPacketStruct uartRxPacketStruct,input UartConfigStruct uartConfigStruct,input bit rx);
		if (rx == 1) begin
			uartRxPacketStruct.framingError = 0;
			uartTransmitterState = STOPBIT;
		end
		else begin
			uartRxPacketStruct.framingError = 1;
			uartTransmitterState = INVALIDSTOPBIT;
		end
  endtask

	//--------------------------------------------------------------------------------------------
	// Task to check parity
	//--------------------------------------------------------------------------------------------
	task parityCheck(inout UartConfigStruct uartConfigStruct,inout UartRxPacketStruct uartRxPacketStruct,input bit rx);
		int cal_parity;
		if(uartConfigStruct.uartParityType == EVEN_PARITY)begin
			cal_parity = evenParityCompute(uartConfigStruct,uartRxPacketStruct);
		end
		else begin
			cal_parity = oddParityCompute(uartConfigStruct,uartRxPacketStruct);
		end
		if(rx==cal_parity)begin
			uartRxPacketStruct.parityError=0;
		end
		else begin
			uartRxPacketStruct.parityError=1;
		end
	endtask:parityCheck
	
 endinterface : UartRxMonitorBfm
