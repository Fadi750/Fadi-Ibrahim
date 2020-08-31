//If u want to check for syntax errors remove the // from the next 3 lines
//import uvm_pkg::*;
//`include "uvm_macros.svh"
//`include "cvpu_sequencer.svh"
class cvpu_driver extends uvm_driver#(cvpu_transaction);
	
`uvm_component_utils(cvpu_driver)
	
virtual cvpu_if cif;

function new(string name,uvm_component parent);
	super.new(name, parent);
endfunction: new
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("AGT-DRV","Driver's checking on IF", UVM_LOW);
	void'(uvm_resource_db#(virtual cvpu_if)::read_by_name(.scope("ifs"), .name("cvpu_if"), .val(cif)));
	`uvm_info("AGT-DRV","Check done!", UVM_LOW);
endfunction: build_phase

task run_phase(uvm_phase phase);
	drive();
endtask: run_phase

virtual task drive();
      cvpu_transaction cvpu_tx;
      int counter=0,i=0;
      

          forever 
           begin
             @(posedge cif.s_clk)
                 begin
                    ++counter;
                    if(counter==1)
                       begin 
                          seq_item_port.get_next_item(cvpu_tx);
                          cif.s_rst=1;
                          cif.s_f_en=1;
                          cif.s_m_en=0;
                          i=0;
                          //++counter;
                       end
                  
                    /*else if(counter==1)
                        begin 
                          cif.s_rst=0;
                          cif.s_f_en=1;
                          cif.s_m_en=0;
                          cif.s_fil=cvpu_tx.fil[0];
                          ++counter;
                          `uvm_info("Driver",$sformatf("filter sent from driver is:(%0d)",cif.s_fil), UVM_LOW);
                        end
                    */
                   /* else if(counter==2) 
                          begin 
                           cif.s_rst=0;
                           cif.s_f_en=1;
                           cif.s_m_en=0;
                           //cif.s_fil=cvpu_tx.fil[0];
                           `uvm_info("Driver",$sformatf("filter sent from driver is:(%0d)",cif.s_fil), UVM_LOW);
                           //`uvm_info("Driver",$sformatf("iterator value is:(%0d)",i), UVM_LOW);
                           end*/
                    else if(counter>=2 && counter<=10)
                         begin 
                           //++i;
                           cif.s_rst=0;
                           cif.s_f_en=1;
                           cif.s_m_en=0;
                           cif.s_fil=cvpu_tx.fil[i];
                           ++i;
                           //++counter;
                           `uvm_info("Driver",$sformatf("filter sent from driver is:(%0d)",cif.s_fil), UVM_LOW);
                           //`uvm_info("Driver",$sformatf("iterator value is:(%0d)",i), UVM_LOW);
                         end

                   else if(counter>10 && counter<=13) 
                        begin 
                           cif.s_rst=0;
                           cif.s_f_en=1;
                           cif.s_m_en=0;
                           i=0;
                           //++counter;
                         end
                   /*else if(counter==14) 
                        begin 
                           cif.s_f_en=0;
                           cif.s_m_en=1;
                           cif.s_mat=cvpu_tx.mat[0]; 
                          `uvm_info("Driver",$sformatf("data sent from driver is:(%0d)",cif.s_mat), UVM_LOW);
                          //`uvm_info("Driver",$sformatf("iterator value is:(%0d)",i), UVM_LOW);
                         end*/
                   else if(counter>=14 && counter<=29)
                         begin 
                           //++i;
                           cif.s_f_en=0;
                           cif.s_m_en=1;
                           cif.s_mat=cvpu_tx.mat[i];
                           ++i;
                           //cif.s_mat=cvpu_tx.mat[0];
                           //++counter;
                          `uvm_info("Driver",$sformatf("data sent from driver is:(%0d)",cif.s_mat), UVM_LOW);
                          //`uvm_info("Driver",$sformatf("iterator value is:(%0d)",i), UVM_LOW);

                         end
                   

                   /*else if(counter>=15 && counter<=29)
                         begin 
                            cif.s_mat=cvpu_tx.mat[i];
                            ++i;
                            //++counter;
                           `uvm_info("Driver",$sformatf("data sent from driver is:(%0d)",cif.s_mat), UVM_LOW);
                          end*/
                    else if(counter>=29 && counter<35)
                           begin 
                             //++counter;
                             i=0;
                             //cif.s_rst=1;
                             /*cif.s_f_en=1;
                             cif.s_m_en=0;*/
                           end
                    else if(counter==35)
                           begin
                            cif.s_rst=1;
                            cif.s_f_en=1;
                            cif.s_m_en=0;
                            seq_item_port.item_done();
                            counter=0;
                          end
                         end
                       end

endtask: drive
endclass: cvpu_driver
                         