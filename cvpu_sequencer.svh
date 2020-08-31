//If u want to check for syntax errors remove the // from the next 2 lines
//import uvm_pkg::*;
//`include "uvm_macros.svh"
class cvpu_transaction extends uvm_sequence_item;
	rand bit [1:0] mat[16];
        rand bit [1:0] fil[9];
	bit [6:0] out[4];

function new(string name=" ");
	super.new(name);
endfunction: new

	`uvm_object_utils(cvpu_transaction)

endclass: cvpu_transaction

class cvpu_sequence extends uvm_sequence#(cvpu_transaction);

	`uvm_object_utils(cvpu_sequence)

function new(string name="");
	super.new(name);
endfunction: new
	
task body();
	cvpu_transaction cvpu_tx;
	repeat(1000)
		begin
		cvpu_tx = cvpu_transaction::type_id::create(.name("cvpu_tx"), .contxt(get_full_name()));
		start_item(cvpu_tx);
		assert(cvpu_tx.randomize());
		`uvm_info("SEQ",$sformatf("transaction is %s",cvpu_tx.sprint()), UVM_LOW);
		finish_item(cvpu_tx);	
	end
	endtask: body
endclass:cvpu_sequence

typedef uvm_sequencer#(cvpu_transaction) cvpu_sequencer;