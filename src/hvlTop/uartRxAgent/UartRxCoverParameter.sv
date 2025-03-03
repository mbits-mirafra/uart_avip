`ifndef UARTRXCOVERPARAMETER_INCLUDED_
`define UARTRXCOVERPARAMETER_INCLUDED_

package UartRxCoverParameter;
  parameter DATA_WIDTH = 5;
  parameter PARITY_ENABLED = 0;
  typedef enum bit  {EVEN_PARITY , ODD_PARITY}PARITY_TYPE;
endpackage : UartRxCoverParameter

`endif
