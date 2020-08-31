//If u want to check for syntax errors remove the // from the next 3 lines
//import uvm_pkg::*;
//`include "uvm_macros.svh"
//`include "relu_sequencer.svh"
class relu_driver extends uvm_driver#(relu_transaction);
	
`uvm_component_utils(relu_driver)
	
virtual relu_if rif;

function new(string name,uvm_component parent);
	super.new(name, parent);
endfunction: new
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("AGT-DRV","Driver's checking on IF", UVM_LOW);
	void'(uvm_resource_db#(virtual relu_if)::read_by_name(.scope("ifs"), .name("relu_if"), .val(rif)));
	`uvm_info("AGT-DRV","Check done!", UVM_LOW);
endfunction: build_phase

task run_phase(uvm_phase phase);
	drive();

endtask: run_phase

virtual task drive();
	relu_transaction relu_tx;
	int counter=0;
//	relu_tx.in = 0'b0;
//	relu_tx.out = 0'b0;
//	relu_tx.en_out = 0'b0;
	forever begin
	  	if(counter==0) begin
	  	seq_item_port.get_next_item(relu_tx);
	  	//++counter;
	  	 end
		@(posedge rif.relu_clk)
		begin
	
		if(counter==0)
			begin
			++counter;
			
			//seq_item_port.get_next_item(relu_tx);
			//rif.relu_reset = 1'b1;
			end
		
	  else if (counter==1)
		  begin 
		  rif.relu_in = relu_tx.in;
			rif.relu_reset = 1'b0;
			++counter;
			//counter=0;
			//seq_item_port.item_done();
			end
		else if(counter==2)
		  begin
		    rif.relu_reset = 1'b0;
		    counter=0;
		    seq_item_port.item_done();
		    end
		  
		 end
	end
endtask: drive
endclass: relu_driver
			
		