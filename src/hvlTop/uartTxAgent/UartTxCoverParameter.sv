`ifndef UARTTXCOVERPARAMETER_INCLUDED_
`define UARTTXCOVERPARAMETER_INCLUDED_

package UartTxCoverParameter;
  parameter DATA_WIDTH = 5;
  parameter PARITY_ENABLED = 1;
  typedef enum bit  {EVEN_PARITY , ODD_PARITY}PARITY_TYPE;
endpackage : UartTxCoverParameter

`endif
