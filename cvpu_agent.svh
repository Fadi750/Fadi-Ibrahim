//If u want to check for syntax errors remove the // from the next 5 lines
//import uvm_pkg::*;
//`include "uvm_macros.svh"
//`include "cvpu_sequencer.sv"
//`include "cvpu_monitor.sv"
//`include "cvpu_driver.sv"
class cvpu_agent extends uvm_agent;
	`uvm_component_utils(cvpu_agent)
	uvm_analysis_port#(cvpu_transaction) agent_ap_before;
	uvm_analysis_port#(cvpu_transaction) agent_ap_after;

	cvpu_sequencer		c_seqr;
	cvpu_driver		c_drvr;
	cvpu_mon_before c_mon_before;
	cvpu_mon_after  c_mon_after;

function new(string name,uvm_component parent);
	super.new(name, parent);
endfunction: new

function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	agent_ap_before=new( .name("agent_ap_before"), .parent(this));
	agent_ap_after=new( .name("agent_ap_after"), .parent(this));

	c_seqr		= cvpu_sequencer::type_id::create(.name("c_seqr"), .parent(this));
	c_drvr		= cvpu_driver::type_id::create(.name("c_drvr"), .parent(this));
	c_mon_before = cvpu_mon_before::type_id::create(.name("c_mon_before"), .parent(this));
	c_mon_after = cvpu_mon_after::type_id::create(.name("c_mon_after"), .parent(this));
	
	`uvm_info("AGENT",$sformatf("Agent instantiated drvr,seqr,mon_before and mon_after"), UVM_LOW);
endfunction: build_phase

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	c_drvr.seq_item_port.connect(c_seqr.seq_item_export);
	c_mon_before.mon_ap_before.connect(agent_ap_before);
	c_mon_after.mon_ap_after.connect(agent_ap_after);
endfunction: connect_phase

endclass: cvpu_agent