//If u want to check for syntax errors remove the // from the next 5 lines
//import uvm_pkg::*;
//`include "uvm_macros.svh"
//`include "up_sequencer.sv"
//`include "up_monitor.sv"
//`include "up_driver.sv"
class up_agent extends uvm_agent;
	`uvm_component_utils(up_agent)
	uvm_analysis_port#(up_transaction) agent_ap_before;
	uvm_analysis_port#(up_transaction) agent_ap_after;

	up_sequencer		u_seqr;
	up_driver		u_drvr;
	up_mon_before u_mon_before;
	up_mon_after  u_mon_after;

function new(string name,uvm_component parent);
	super.new(name, parent);
endfunction: new

function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	agent_ap_before=new( .name("agent_ap_before"), .parent(this));
	agent_ap_after=new( .name("agent_ap_after"), .parent(this));

	u_seqr		= up_sequencer::type_id::create(.name("u_seqr"), .parent(this));
	u_drvr		= up_driver::type_id::create(.name("u_drvr"), .parent(this));
	u_mon_before = up_mon_before::type_id::create(.name("u_mon_before"), .parent(this));
	u_mon_after = up_mon_after::type_id::create(.name("u_mon_after"), .parent(this));
	
	`uvm_info("AGENT",$sformatf("Agent instantiated drvr,seqr,mon_before and mon_after"), UVM_LOW);
endfunction: build_phase

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	u_drvr.seq_item_port.connect(u_seqr.seq_item_export);
	u_mon_before.mon_ap_before.connect(agent_ap_before);
	u_mon_after.mon_ap_after.connect(agent_ap_after);
endfunction: connect_phase

endclass: up_agent