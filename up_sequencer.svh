//If u want to check for syntax errors remove the // from the next 2 lines
//import uvm_pkg::*;
//`include "uvm_macros.svh"
class up_transaction extends uvm_sequence_item;
	rand bit[15:0] in[4];
	bit[15:0] out[16];

function new(string name=" ");
	super.new(name);
endfunction: new

	`uvm_object_utils(up_transaction)

endclass: up_transaction

class up_sequence extends uvm_sequence#(up_transaction);

	`uvm_object_utils(up_sequence)

function new(string name="");
	super.new(name);
endfunction: new
	
task body();
	up_transaction up_tx;
	repeat(501)
		begin
		up_tx = up_transaction::type_id::create(.name("up_tx"), .contxt(get_full_name()));
		start_item(up_tx);
		assert(up_tx.randomize());
		`uvm_info("SEQ",$sformatf("transaction is %s",up_tx.sprint()), UVM_LOW);
		finish_item(up_tx);	
	end
	endtask: body
endclass:up_sequence

typedef uvm_sequencer#(up_transaction) up_sequencer;