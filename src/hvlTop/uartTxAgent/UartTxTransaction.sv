`ifndef UARTTXTRANSACTION_INCLUDED_ 
`define UARTTXTRANSACTION_INCLUDED_
//--------------------------------------------------------------------------------------------
// Class: UartTxTransaction
//--------------------------------------------------------------------------------------------
class UartTxTransaction extends uvm_sequence_item;
   
	`uvm_object_utils(UartTxTransaction)
   
   //input signals
	rand logic [DATA_WIDTH-1 : 0] transmissionData;
        logic  parity;
	logic parityError; 
	logic breakingError; 
	logic overrunError;
	logic framingError;
   

   //-------------------------------------------------------
   // constraints for uart
   //-------------------------------------------------------
   
	
   //-------------------------------------------------------
   // Externally defined Tasks and Functions
   //-------------------------------------------------------
   extern function new(string name = "UartTxTransaction");
   extern function void do_copy(uvm_object rhs);
   extern function void do_print(uvm_printer printer);
   extern function bit do_compare(uvm_object rhs, uvm_comparer comparer = null);
   endclass : UartTxTransaction
   
//--------------------------------------------------------------------------------------------
// Construct: new
// initializes the class object
// name - UartTxTransaction
//--------------------------------------------------------------------------------------------
function UartTxTransaction :: new(string name = "UartTxTransaction");
	super.new(name);
endfunction : new

//--------------------------------------------------------------------------------------------
// do_copy method
//--------------------------------------------------------------------------------------------
function void UartTxTransaction :: do_copy(uvm_object rhs);
	UartTxTransaction rhs1;
  if(! $cast(rhs1,rhs))
  	`uvm_fatal("do_copy","casting failed during copying");
  super.copy(rhs);
  this.transmissionData = rhs1.transmissionData;
  this.parity = rhs1.parity;
  this.framingError =rhs1.framingError;
  this.parityError = rhs1.parityError;
  this.breakingError = rhs1.breakingError;
  this.overrunError = rhs1.overrunError;
endfunction : do_copy

//--------------------------------------------------------------------------------------------
// do_compare method
//--------------------------------------------------------------------------------------------
function bit UartTxTransaction :: do_compare(uvm_object rhs, uvm_comparer comparer = null);
	UartTxTransaction rhs1;
	if(! $cast(rhs1,rhs))
		`uvm_fatal("do_compare","Casting failed during comparing");
	return (super.compare(rhs,comparer) && this.transmissionData == rhs1.transmissionData && this.parity == rhs1.parity);
endfunction : do_compare

//--------------------------------------------------------------------------------------------
// Function: do_print method
//--------------------------------------------------------------------------------------------
function void UartTxTransaction :: do_print(uvm_printer printer);
	super.do_print(printer);
	foreach(this.transmissionData[i])
		printer.print_field($sformatf("transmissionData[%0d]",i),transmissionData[i],$bits(transmissionData[i]),UVM_BIN);
		printer.print_field("parity",parity,$bits(parity),UVM_BIN);
endfunction : do_print

`endif
