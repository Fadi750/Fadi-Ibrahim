//If u want to check for syntax errors remove the "//" from the next 4 lines + driver and monitor @agent + sequencer @scoreboard
//import uvm_pkg::*;
//`include "uvm_macros.svh"
//`include "relu_scoreboard.svh"
//`include "relu_agent.svh"

class relu_env extends uvm_env;
	`uvm_component_utils(relu_env)

	relu_agent r_agent;
	relu_scoreboard r_sb;

function new(string name, uvm_component parent);
	super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	r_agent = relu_agent::type_id::create(.name("r_agent"), .parent(this));
	r_sb = relu_scoreboard::type_id::create(.name("r_sb"), .parent(this));
	`uvm_info("ENV",$sformatf("Environment done instantiating both Agent and Scoreboard"), UVM_LOW);
endfunction: build_phase

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	r_agent.agent_ap_before.connect(r_sb.sb_export_before);
	r_agent.agent_ap_after.connect(r_sb.sb_export_after);

endfunction: connect_phase

endclass: relu_env

