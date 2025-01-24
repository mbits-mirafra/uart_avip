`ifndef UARTGLOBALPKG_INCLUDED_
`define UARTGLOBALPKG_INCLUDED_

package UartGlobalPkg;

  parameter DATA_WIDTH=5;
  parameter  DUTY = 60;
  parameter FREQUENCY = 0.5; // in GHz
  parameter PERIOD = 1 ;//frequency;
  parameter NO_OF_PACKETS = 50;
  
  typedef struct packed { bit[NO_OF_PACKETS -1 :0][DATA_WIDTH-1:0] transmissionData; bit parity;} UartTxPacketStruct;
  typedef struct packed { bit[NO_OF_PACKETS -1 :0][DATA_WIDTH-1:0] receivingData; bit parity;} UartRxPacketStruct;

  typedef enum bit[31:0]{ BAUD_4800 = 32'd4800,
                          BAUD_9600 = 32'd9600,
                          BAUD_19200 = 32'd19200 
                        }Baud_Rate;

  typedef enum bit[4:0]{ X16 = 5'd16,
                         X13 = 5'd13
  }Over_Sampling;

endpackage : UartGlobalPkg
`endif
