//If u want to check for syntax errors remove the // from the next 3 lines
//import uvm_pkg::*;
//`include "uvm_macros.svh"
//`include "up_sequencer.svh"
class up_mon_before extends uvm_monitor;

	`uvm_component_utils(up_mon_before)
	
	virtual up_if upif;
	uvm_analysis_port#(up_transaction) mon_ap_before;

function new(string name,uvm_component parent);
	super.new(name, parent);
endfunction: new

function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	void'(uvm_resource_db#(virtual up_if)::read_by_name(.scope("ifs"), .name("up_if"), .val(upif)));
	mon_ap_before = new(.name("mon_ap_before"), .parent(this));
endfunction: build_phase

task run_phase(uvm_phase phase);
	integer counter=1,i_b=0;
	up_transaction up_tx;
	up_tx = up_transaction::type_id::create(.name("up_tx"), .contxt(get_full_name()));
	forever begin
		@(posedge upif.up_clk)
		begin
                  /*if(counter>=1 && counter<=15 && upif.up_eno==1)
                     begin
                       mon_ap_before.write(up_tx);
                       `uvm_info("Driver",$sformatf("data output is:(%0d)",up_tx.out), UVM_LOW);
                     end */
                    if(counter>16)
                      begin
                        up_tx.out[15]=upif.up_out;
                        counter=1;
                        mon_ap_before.write(up_tx);
                        ++i_b;
                        //`uvm_info("Driver",$sformatf("transaction(%0d)",i_b), UVM_LOW);
                      end
                   
		  if(upif.up_eno==1 && counter>=1 && counter<=16)
                      begin
                        up_tx.out[counter-2]=upif.up_out;
                        //mon_ap_before.write(up_tx);
                        `uvm_info("Driver",$sformatf("data output is:(%0d)",up_tx.out[counter-1]), UVM_LOW);
                        `uvm_info("counter",$sformatf("counter is equal to :(%0d)",counter), UVM_LOW);
                        //`uvm_info("Driver",$sformatf("transaction(%0d)",i_b), UVM_LOW);
                        counter++;
                      end
                   
		end
	end
endtask: run_phase
endclass: up_mon_before




class up_mon_after extends uvm_monitor;

	`uvm_component_utils(up_mon_after)
	uvm_analysis_port#(up_transaction) mon_ap_after;
	virtual up_if upif;
	up_transaction up_tx;
	
function new(string name,uvm_component parent);
	super.new(name, parent);
	
endfunction: new

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	void'(uvm_resource_db#(virtual up_if)::read_by_name(.scope("ifs"), .name("up_if"), .val(upif)));
	mon_ap_after = new(.name("mon_ap_after"), .parent(this));
endfunction: build_phase


task run_phase(uvm_phase phase);
	integer i=0,count2=0,flag=0;
        //bit [15:0] arr[4];
	up_tx = up_transaction::type_id::create(.name("up_tx"), .contxt(get_full_name()));
	forever begin
		@(upif.up_in)
			begin
                          //if(upif.up_rst==0)
                           //begin
                           i++;
                           if(i==1)
                             begin
                               up_tx.out[0]=upif.up_in;
                                 `uvm_info("Driver",$sformatf("data output is:(%0d)",up_tx.out[0]), UVM_LOW);
                               up_tx.out[1]=upif.up_in;
                                 `uvm_info("Driver",$sformatf("data output is:(%0d)",up_tx.out[1]), UVM_LOW);
                               up_tx.out[4]=upif.up_in;
                                 `uvm_info("Driver",$sformatf("data output is:(%0d)",up_tx.out[4]), UVM_LOW);
                               up_tx.out[5]=upif.up_in;
                                  `uvm_info("Driver",$sformatf("data output is:(%0d)",up_tx.out[5]), UVM_LOW);
                             end
                         else if(i==2)
                             begin
                               up_tx.out[2]=upif.up_in;
                                 `uvm_info("Driver",$sformatf("data output is:(%0d)",up_tx.out[2]), UVM_LOW);
                               up_tx.out[3]=upif.up_in;
                                 `uvm_info("Driver",$sformatf("data output is:(%0d)",up_tx.out[3]), UVM_LOW);
                               up_tx.out[6]=upif.up_in;
                                 `uvm_info("Driver",$sformatf("data output is:(%0d)",up_tx.out[6]), UVM_LOW);
                               up_tx.out[7]=upif.up_in;
                                  `uvm_info("Driver",$sformatf("data output is:(%0d)",up_tx.out[7]), UVM_LOW);
                             end
                          else if(i==3)
                             begin
                               up_tx.out[8]=upif.up_in;
                                 `uvm_info("Driver",$sformatf("data output is:(%0d)",up_tx.out[8]), UVM_LOW);
                               up_tx.out[9]=upif.up_in;
                                 `uvm_info("Driver",$sformatf("data output is:(%0d)",up_tx.out[9]), UVM_LOW);
                               up_tx.out[12]=upif.up_in;
                                 `uvm_info("Driver",$sformatf("data output is:(%0d)",up_tx.out[12]), UVM_LOW);
                               up_tx.out[13]=upif.up_in;
                                  `uvm_info("Driver",$sformatf("data output is:(%0d)",up_tx.out[13]), UVM_LOW);
                             end
                        else if(i==4)
                             begin
                               up_tx.out[10]=upif.up_in;
                                 `uvm_info("Driver",$sformatf("data output is:(%0d)",up_tx.out[10]), UVM_LOW);
                               up_tx.out[11]=upif.up_in;
                                 `uvm_info("Driver",$sformatf("data output is:(%0d)",up_tx.out[11]), UVM_LOW);
                               up_tx.out[14]=upif.up_in;
                                 `uvm_info("Driver",$sformatf("data output is:(%0d)",up_tx.out[14]), UVM_LOW);
                               up_tx.out[15]=upif.up_in;
                                 `uvm_info("Driver",$sformatf("data output is:(%0d)",up_tx.out[15]), UVM_LOW);
                               mon_ap_after.write(up_tx);
                               i=0;
                             end
                //end
            end
	end
endtask: run_phase 
endclass: up_mon_after