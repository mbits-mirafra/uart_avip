
`ifndef UARTRXTRANSACTION_INLCLUDED_ 
`define UARTRXTRANSACTION_INCLUDED_
//--------------------------------------------------------------------------------------------
// Class: UartRxTransaction
// It's a transaction class that holds the UART data items for generating the stimulus
//--------------------------------------------------------------------------------------------
class UartRxTransaction extends uvm_sequence_item;
  //register with factory so we can override with uvm method in future if necessary.
  `uvm_object_utils(UartRxTransaction)
 
  //input signals
  bit[DATA_WIDTH+5: 0]receivingData[];
  bit parity;
  
  //-------------------------------------------------------
  // Externally defined Tasks and Functions
  //-------------------------------------------------------
  extern function new(string name = "UartRxTransaction");
  extern function void do_copy(uvm_object rhs);
  extern function void do_print(uvm_printer printer);
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer = null);
endclass : UartRxTransaction

//--------------------------------------------------------------------------------------------
// Construct: new
// Constructs the device1_tx object
//  
//
// Parameters:
// name - UartRxTransaction
//--------------------------------------------------------------------------------------------
function UartRxTransaction :: new(string name = "UartRxTransaction");
  super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// do_copy method
//--------------------------------------------------------------------------------------------

function void UartRxTransaction :: do_copy(uvm_object rhs);
  UartRxTransaction rhs1;

  if(! $cast(rhs1,rhs))
   `uvm_fatal("do_copy","casting failed during copying");

  super.copy(rhs);
  this.receivingData = rhs1.receivingData;
  this.parity = rhs1.parity;
endfunction : do_copy
    
//--------------------------------------------------------------------------------------------
// do_compare method
//-------------------------------------------------------------------------------------------- 
    
function bit UartRxTransaction :: do_compare(uvm_object rhs, uvm_comparer comparer = null);
  UartRxTransaction rhs1;
  if(! $cast(rhs1,rhs))
   `uvm_fatal("do_compare","Casting failed during comparing");
  return (super.compare(rhs,comparer) && (this.receivingData == rhs1.receivingData) && (this.parity && rhs1.parity));
endfunction : do_compare

//--------------------------------------------------------------------------------------------
// Function: do_print method
// Print method can be added to display the data members values
//--------------------------------------------------------------------------------------------
    
function void UartRxTransaction :: do_print(uvm_printer printer);
  super.do_print(printer);
  foreach(this.receivingData[i])
   printer.print_field($sformatf("receivingData[%0d]",i),receivingData[i],$bits(receivingData[i]),UVM_BIN);
endfunction : do_print

`endif
