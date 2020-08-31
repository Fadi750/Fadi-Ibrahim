//If u want to check for syntax errors remove the // from the next 2 lines
//import uvm_pkg::*;
//`include "uvm_macros.svh"
class relu_transaction extends uvm_sequence_item;
	rand bit[19:0] in;
	bit[19:0] out;
	bit en_out;

function new(string name=" ");
	super.new(name);
endfunction: new

	`uvm_object_utils(relu_transaction)

endclass: relu_transaction

class relu_sequence extends uvm_sequence#(relu_transaction);

	`uvm_object_utils(relu_sequence)

function new(string name="");
	super.new(name);
endfunction: new
	
task body();
	relu_transaction relu_tx;
	repeat(301)
		begin
		relu_tx = relu_transaction::type_id::create(.name("relu	_tx"), .contxt(get_full_name()));
		start_item(relu_tx);
		assert(relu_tx.randomize());
		`uvm_info("SEQ",$sformatf("transaction is %s",relu_tx.sprint()), UVM_LOW);
		finish_item(relu_tx);	
	end
	endtask: body
endclass:relu_sequence

typedef uvm_sequencer#(relu_transaction) relu_sequencer;