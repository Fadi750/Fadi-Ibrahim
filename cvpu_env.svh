//If u want to check for syntax errors remove the "//" from the next 4 lines + driver and monitor @agent + sequencer @scoreboard
//import uvm_pkg::*;
//`include "uvm_macros.svh"
//`include "cvpu_scoreboard.sv"
//`include "cvpu_agent.sv"

class cvpu_env extends uvm_env;
	`uvm_component_utils(cvpu_env)

	cvpu_agent c_agent;
	cvpu_scoreboard c_sb;

function new(string name, uvm_component parent);
	super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	c_agent = cvpu_agent::type_id::create(.name("c_agent"), .parent(this));
	c_sb = cvpu_scoreboard::type_id::create(.name("c_sb"), .parent(this));
	`uvm_info("ENV",$sformatf("Environment done instantiating both Agent and Scoreboard"), UVM_LOW);
endfunction: build_phase

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	c_agent.agent_ap_before.connect(c_sb.sb_export_before);
	c_agent.agent_ap_after.connect(c_sb.sb_export_after);

endfunction: connect_phase

endclass: cvpu_env