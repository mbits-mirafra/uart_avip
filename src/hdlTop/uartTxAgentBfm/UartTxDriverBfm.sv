//-------------------------------------------------------
// Importing Uart global package
//-------------------------------------------------------
import UartGlobalPkg::*;

//--------------------------------------------------------------------------------------------
// Interface : UartTxDriverBfm
//  Used as the HDL driver for Uart
//  It connects with the HVL driver_proxy for driving the stimulus
//--------------------------------------------------------------------------------------------

interface UartTxDriverBfm (input  bit   clk,
                           input  bit   reset,
                           output  bit   tx
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
	
  bit bclk;
   
   //Variable: baudRate
  //Used to sample the uart data
	
  // reg[31:0] baudRate = 9600; 
  
  //Variable: counter
  // Counter to keep track of clock cycles
	
  reg [15:0] counter;  
  
  //Variable: baudDivider
  //to Calculate baud rate divider
	
  reg [15:0] baudDivider;
  
  
  //Creating the handle for the proxy_driver

  UartTxDriverProxy uartTxDriverProxy;
   
  //-------------------------------------------------------
  // Used to display the name of the interface
  //-------------------------------------------------------
  initial begin
    `uvm_info(name, $sformatf(name),UVM_LOW)
  end
  

  //------------------------------------------------------------------
  // Task: Baud_div
  // this task will calculate the baud divider based on sys clk frequency
  //-------------------------------------------------------------------
	
 //  task Baud_div(input overSampling, input baudRate);
	  
	// baudDivider = (FREQUENCY *1000000000) / (overSampling * baudRate);    
	  
 //  endtask: Baud_div
 
 //  initial begin 
	  
	//   Baud_div(agtcfg.overSampling, agtcfg.baudRate);   // variables yet to be added in the agent
	  
 //    forever begin
	//     @(posedge clk or negedge clk) begin
 //        	if (counter == baudDivider - 1) begin
 //            		bclk <= ~bclk;   // Toggle bclk when counter reaches baudDivider
 //            		counter <= 0;    // Reset the counter
 //        	end else begin
 //            		counter <= counter + 1;  // Increment the counter
 //        	end
 //    	    end
 //    	end
 //   end

  
  //-------------------------------------------------------
  // Task: WaitForReset
  //  Waiting for the system reset
  //-------------------------------------------------------

  task WaitForReset();
    
  endtask: WaitForReset
  
  //--------------------------------------------------------------------------------------------
  // Task: DriveToBfm
  //  This task will drive the data from bfm to proxy using converters
  //--------------------------------------------------------------------------------------------

  task DriveToBfm();
   // @(posedge bclk)

  endtask: DriveToBfm

endinterface : UartTxDriverBfm
