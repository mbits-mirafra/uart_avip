import UartGlobalPkg::*;
//--------------------------------------------------------------------------------------------
// Interface : UartTxMonitorBfm
//  Connects the master monitor bfm with the master monitor prox
//--------------------------------------------------------------------------------------------
interface UartTxMonitorBfm (input  logic   clk,
                            input  logic reset,
                            input  logic   tx
                           );
  //-------------------------------------------------------
  // Importing uvm package file
  //-------------------------------------------------------
  import uvm_pkg::*;
  `include "uvm_macros.svh"
	
  string name = "UART_TRANSMITTER_MONITOR_BFM";
	
  //Variable: bclk
  //baud clock for uart transmisson/reception
	bit baudClk;

	logic [DATA_WIDTH+3 : 0]concatData;
	int numOfZeroes;
	int breakZeroCount;

	// enum variable for transfer states
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
	
	task StartMonitoring(inout UartTxPacketStruct uartTxPacketStruct , inout UartConfigStruct uartConfigStruct);
		Deserializer(uartTxPacketStruct,uartConfigStruct);
  endtask
	
	//-------------------------------------------------------
	// Task: To compute Even Parity
	//-------------------------------------------------------
	function evenParityCompute(input UartConfigStruct uartConfigStruct,input UartTxPacketStruct uartTxPacketStruct);
	  bit parity;
	  case(uartConfigStruct.uartDataType)
	    FIVE_BIT: parity = ^(uartTxPacketStruct.transmissionData[4:0]);
	    SIX_BIT :parity = ^(uartTxPacketStruct.transmissionData[5:0]);
	    SEVEN_BIT: parity = ^(uartTxPacketStruct.transmissionData[6:0]);
	    EIGHT_BIT : parity = ^(uartTxPacketStruct.transmissionData[7:0]);
	  endcase
	return parity;
	endfunction
	
	//-------------------------------------------------------
	// Task: To compute Odd Parity
	//-------------------------------------------------------
	function oddParityCompute(input UartConfigStruct uartConfigStruct,input UartTxPacketStruct uartTxPacketStruct);
		bit parity;
		case(uartConfigStruct.uartDataType)
			FIVE_BIT: parity = ~^(uartTxPacketStruct.transmissionData[4:0]);
			SIX_BIT :parity = ~^(uartTxPacketStruct.transmissionData[5:0]);
			SEVEN_BIT: parity = ~^(uartTxPacketStruct.transmissionData[6:0]);
			EIGHT_BIT : parity = ~^(uartTxPacketStruct.transmissionData[7:0]);
		endcase
		return parity;
	endfunction
	
  //-------------------------------------------------------
  // Task: DeSerializer
  //  converts serial data to parallel
  //-------------------------------------------------------
  task Deserializer(inout UartTxPacketStruct uartTxPacketStruct, inout UartConfigStruct uartConfigStruct);
		// sampling start bit 
	  @(negedge tx);
			repeat(uartConfigStruct.uartOverSamplingMethod/2) @(posedge baudClk); 
			uartTransmitterState = STARTBIT;
			concatData={concatData,tx};
	
	
			// sampling data bits 
			for( int i=0 ; i < uartConfigStruct.uartDataType ; i++) begin
				repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk); begin
					uartTxPacketStruct.transmissionData[i] = tx;
					concatData={concatData,tx};
					uartTransmitterState = UartTransmitterStateEnum'(i+3);
				end
			end
	
			// sampling parity bit 
			if(uartConfigStruct.uartParityEnable ==1) begin
				repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
				uartTxPacketStruct.parity = tx;
				concatData={concatData,tx};
				uartTransmitterState = PARITYBIT;
				parityCheck(uartConfigStruct,uartTxPacketStruct,tx);
			end
			
			// sampling stop bit	
			repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
				concatData={concatData,tx};
				stopBitCheck(uartTxPacketStruct,uartConfigStruct,tx);
				
				if(uartConfigStruct.uartStopBit == 2) begin
					repeat(uartConfigStruct.uartOverSamplingMethod) @(posedge baudClk);
					concatData={concatData,tx};
					if(uartTxPacketStruct.framingError == 0) begin
						stopBitCheck(uartTxPacketStruct,uartConfigStruct,tx);
					end
				end
	
			numOfZeroes=$countones(~(concatData));
			if(uartConfigStruct.uartStopBit == 2)
				breakZeroCount=uartConfigStruct.uartParityEnable ? (uartConfigStruct.uartDataType)+4 :(uartConfigStruct.uartDataType)+3;
			else
				breakZeroCount=uartConfigStruct.uartParityEnable ? (uartConfigStruct.uartDataType)+3 :(uartConfigStruct.uartDataType)+2;
			if(numOfZeroes == breakZeroCount)
				uartTxPacketStruct.breakingError =1;
			else 
				uartTxPacketStruct.breakingError =0;
	
			repeat(uartConfigStruct.uartOverSamplingMethod/2) @(posedge baudClk);
			concatData = 'b x;
			numOfZeroes =0;
			uartTransmitterState = IDLE; 
    endtask
	
		task stopBitCheck (inout  UartTxPacketStruct uartTxPacketStruct,input UartConfigStruct uartConfigStruct,input bit tx);
			if (tx == 1) begin
				uartTxPacketStruct.framingError = 0;
				uartTransmitterState = STOPBIT;
			end
			else begin
				uartTxPacketStruct.framingError = 1;
				uartTransmitterState = INVALIDSTOPBIT;
			end
  	endtask
		
		task parityCheck(inout UartConfigStruct uartConfigStruct,inout UartTxPacketStruct uartTxPacketStruct,input bit tx);
   		int cal_parity;
   		if(uartConfigStruct.uartParityType == EVEN_PARITY)begin
      	cal_parity = evenParityCompute(uartConfigStruct,uartTxPacketStruct);
     	end
      else begin
      	cal_parity = oddParityCompute(uartConfigStruct,uartTxPacketStruct);
      end
			if(tx==cal_parity)begin
      	uartTxPacketStruct.parityError=0;
     	end
     	else begin
     		uartTxPacketStruct.parityError=1;
     	end
  	endtask:parityCheck
endinterface : UartTxMonitorBfm
