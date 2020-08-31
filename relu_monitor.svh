//If u want to check for syntax errors remove the // from the next 3 lines
//import uvm_pkg::*;
//`include "uvm_macros.svh"
//`include "relu_sequencer.svh"
class relu_mon_before extends uvm_monitor;

	`uvm_component_utils(relu_mon_before)
	
	virtual relu_if rif;
	uvm_analysis_port#(relu_transaction) mon_ap_before;

function new(string name,uvm_component parent);
	super.new(name, parent);
endfunction: new

function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	void'(uvm_resource_db#(virtual relu_if)::read_by_name(.scope("ifs"), .name("relu_if"), .val(rif)));
	mon_ap_before = new(.name("mon_ap_before"), .parent(this));
endfunction: build_phase

task run_phase(uvm_phase phase);
	integer counter=0;
	relu_transaction relu_tx;
	relu_tx = relu_transaction::type_id::create(.name("relu_tx"), .contxt(get_full_name()));
	forever begin
		@(posedge rif.relu_clk)
		begin
		if(rif.relu_reset==0)
			begin
			/*relu_tx.out=rif.relu_out;
			mon_ap_before.write(relu_tx);*/
			counter++;
			end
		if(counter==3)
			begin
			counter=0;
			relu_tx.out=rif.relu_out;
			mon_ap_before.write(relu_tx);
			end
		end
	end
endtask: run_phase
endclass: relu_mon_before
class relu_mon_after extends uvm_monitor;

	`uvm_component_utils(relu_mon_after)
	uvm_analysis_port#(relu_transaction) mon_ap_after;
	virtual relu_if rif;
	relu_transaction relu_tx;
	
function new(string name,uvm_component parent);
	super.new(name, parent);
	
endfunction: new

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	void'(uvm_resource_db#(virtual relu_if)::read_by_name(.scope("ifs"), .name("relu_if"), .val(rif)));
	mon_ap_after = new(.name("mon_ap_after"), .parent(this));
endfunction: build_phase

task run_phase(uvm_phase phase);
	integer counter=0;
	relu_tx = relu_transaction::type_id::create(.name("relu_tx"), .contxt(get_full_name()));
	forever begin
		@(posedge rif.relu_clk)
			begin
			if(rif.relu_reset==1'b0)
			begin
				if(rif.relu_in[19])
					begin
					relu_tx.out = 0;
					mon_ap_after.write(relu_tx);
					end
				else 
					begin
					relu_tx.out = rif.relu_in;
					mon_ap_after.write(relu_tx);
					end
			end
			end
	end
endtask: run_phase
endclass: relu_mon_after
