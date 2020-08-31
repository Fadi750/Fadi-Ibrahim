//If u want to check for syntax errors remove the // from the next 5 lines
//import uvm_pkg::*;
//`include "uvm_macros.svh"
//`include "relu_sequencer.svh"
//`include "relu_monitor.svh"
//`include "relu_driver.svh"
class relu_agent extends uvm_agent;
	`uvm_component_utils(relu_agent)
	uvm_analysis_port#(relu_transaction) agent_ap_before;
	uvm_analysis_port#(relu_transaction) agent_ap_after;

	relu_sequencer		r_seqr;
	relu_driver		r_drvr;
	relu_mon_before r_mon_before;
	relu_mon_after  r_mon_after;

function new(string name,uvm_component parent);
	super.new(name, parent);
endfunction: new

function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	agent_ap_before=new( .name("agent_ap_before"), .parent(this));
	agent_ap_after=new( .name("agent_ap_after"), .parent(this));

	r_seqr		= relu_sequencer::type_id::create(.name("r_seqr"), .parent(this));
	r_drvr		= relu_driver::type_id::create(.name("r_drvr"), .parent(this));
	r_mon_before = relu_mon_before::type_id::create( .name("r_mon_before"), .parent(this));
	r_mon_after = relu_mon_after::type_id::create(	.name("r_mon_after"), .parent(this));
	
	`uvm_info("AGENT",$sformatf("Agent instantiated drvr,seqr,mon_before and mon_after"), UVM_LOW);
endfunction: build_phase

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	r_drvr.seq_item_port.connect(r_seqr.seq_item_export);
	r_mon_before.mon_ap_before.connect(agent_ap_before);
	r_mon_after.mon_ap_after.connect(agent_ap_after);
endfunction: connect_phase

endclass: relu_agent
