//If u want to check for syntax errors remove the // from the next 3 lines
//import uvm_pkg::*;
//`include "uvm_macros.svh"
//`include "up_sequencer.sv"
class up_driver extends uvm_driver#(up_transaction);
	
`uvm_component_utils(up_driver)
	
virtual up_if upif;

function new(string name,uvm_component parent);
	super.new(name, parent);
endfunction: new
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("AGT-DRV","Driver's checking on IF", UVM_LOW);
	void'(uvm_resource_db#(virtual up_if)::read_by_name(.scope("ifs"), .name("up_if"), .val(upif)));
	`uvm_info("AGT-DRV","Check done!", UVM_LOW);
endfunction: build_phase

task run_phase(uvm_phase phase);
	drive();

endtask: run_phase
virtual task drive();
      up_transaction up_tx;
      int counter=0,i=0;
      
      forever 
         begin
            //seq_item_port.get_next_item(up_tx);
           @(posedge upif.up_clk)
		begin
                   //seq_item_port.get_next_item(up_tx);
                   //++counter;
                   if(counter==0)
                      begin
                        seq_item_port.get_next_item(up_tx);
                        upif.up_rst=1;
                        ++counter;
                       end
                   else if(counter==1)
                       begin
                        //seq_item_port.get_next_item(up_tx);
                        upif.up_rst=0;
                        upif.up_in=up_tx.in[0];
                        ++counter;
                        `uvm_info("Driver",$sformatf("data sent from driver is:(%0d)",upif.up_in), UVM_LOW);
                       end
                   
                  else if(counter>=2 && counter<=4)
                       begin
                         upif.up_rst=0;
                         ++i;
                         upif.up_in=up_tx.in[i];
                         ++counter;
                         `uvm_info("Driver",$sformatf("data sent from driver is:(%0d)",upif.up_in), UVM_LOW);
                        end
                   else if(counter>4 && counter<22)
                        begin
                          i=0;
                          ++counter;
                        end
                   else if(counter==22)
                      begin
                        upif.up_rst=1;
                        seq_item_port.item_done();
                        counter=0;
                        
                       end
               end
               //seq_item_port.item_done();
             end
           
endtask: drive
endclass: up_driver
                         