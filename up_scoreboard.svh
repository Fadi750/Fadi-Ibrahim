//If u want to check for syntax errors remove the // from the next 3 lines
//import uvm_pkg::*;
//`include "uvm_macros.svh"
//`include "up_sequencer.svh"

`uvm_analysis_imp_decl(_before) //Search about these macros
`uvm_analysis_imp_decl(_after)
class up_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(up_scoreboard)

	uvm_analysis_export#(up_transaction) sb_export_before;
	uvm_analysis_export#(up_transaction) sb_export_after;

	uvm_tlm_analysis_fifo#(up_transaction) before_fifo;
	uvm_tlm_analysis_fifo#(up_transaction) after_fifo;

	up_transaction transaction_before;
	up_transaction transaction_after;

function new(string name, uvm_component parent);
	super.new(name, parent);

	transaction_before= new("transaction_before");
	transaction_after= new("transaction_after");
endfunction: new


function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	sb_export_before = new(.name("sb_export_before"), .parent(this));
	sb_export_after = new(.name("sb_export_after"), .parent(this));

	before_fifo = new("before_fifo", this);
	after_fifo = new("after_fifo", this);
endfunction: build_phase


function void connect_phase(uvm_phase phase);
	//super.connect_phase(phase); //not written in the og code?????
	
	sb_export_before.connect(before_fifo.analysis_export);
	sb_export_after.connect(after_fifo.analysis_export);

endfunction: connect_phase

task run(); //why not run_phase!!!!
	integer i_sb=0;
	forever begin
		before_fifo.get(transaction_before);
		after_fifo.get(transaction_after);
		i_sb++;
		`uvm_info("SB",$sformatf("Scoreboard is doing comparison(%0d)",i_sb), UVM_LOW);
		compare();
	end
endtask: run

virtual function void compare();
          //integer i_c;
             //for(i_c=0;i_c<=8000;i_c++) 
              // begin
                //`uvm_info("Sb_mon_before",$sformatf("data from monitor before is:(%0d)",transaction_before.out[i_c]), UVM_LOW);
                //`uvm_info("Sb_mon_after",$sformatf("data from monitor after is:(%0d)",transaction_after.out[i_c]), UVM_LOW);
                //`uvm_info("Sb_mon_after",$sformatf("iterator is equal to:(%0d)",i_c), UVM_LOW);
                $display("queue_before = %p", transaction_before.out);
                $display("queue_after = %p", transaction_after.out);
		if(transaction_before.out == transaction_after.out) begin
			`uvm_info("SB_SUCCESS",$sformatf("Result : SUCCESS!"), UVM_LOW);
		end else begin
			`uvm_info("SB_FAILURE", $sformatf("Result : FAILURE!"), UVM_LOW);	
		end
                //end
                /*if(i_c>=0) 
                 begin
                  ++i_c;
                 end*/
            
endfunction: compare
endclass: up_scoreboard