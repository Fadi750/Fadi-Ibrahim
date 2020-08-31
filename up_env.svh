//If u want to check for syntax errors remove the "//" from the next 4 lines + driver and monitor @agent + sequencer @scoreboard
//import uvm_pkg::*;
//`include "uvm_macros.svh"
//`include "up_scoreboard.svh"
//`include "up_agent.svh"

class up_env extends uvm_env;
	`uvm_component_utils(up_env)

	up_agent u_agent;
	up_scoreboard u_sb;

function new(string name, uvm_component parent);
	super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	u_agent = up_agent::type_id::create(.name("u_agent"), .parent(this));
	u_sb = up_scoreboard::type_id::create(.name("u_sb"), .parent(this));
	`uvm_info("ENV",$sformatf("Environment done instantiating both Agent and Scoreboard"), UVM_LOW);
endfunction: build_phase

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	
	u_agent.agent_ap_before.connect(u_sb.sb_export_before);
	u_agent.agent_ap_after.connect(u_sb.sb_export_after);

endfunction: connect_phase

endclass: up_env
