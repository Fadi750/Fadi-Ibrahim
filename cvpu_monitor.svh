//If u want to check for syntax errors remove the // from the next 3 lines
//import uvm_pkg::*;
//`include "uvm_macros.svh"
//`include "cvpu_sequencer.svh"
class cvpu_mon_before extends uvm_monitor;

	`uvm_component_utils(cvpu_mon_before)
	
	virtual cvpu_if cif;
	uvm_analysis_port#(cvpu_transaction) mon_ap_before;

function new(string name,uvm_component parent);
	super.new(name, parent);
endfunction: new

function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	void'(uvm_resource_db#(virtual cvpu_if)::read_by_name(.scope("ifs"), .name("cvpu_if"), .val(cif)));
	mon_ap_before = new(.name("mon_ap_before"), .parent(this));
endfunction: build_phase

task run_phase(uvm_phase phase);
	integer counter=0,i_b=0;
	cvpu_transaction cvpu_tx;
	cvpu_tx = cvpu_transaction::type_id::create(.name("cvpu_tx"), .contxt(get_full_name()));
	forever begin
		@(posedge cif.s_clk)
		begin
                    
                    if(cif.s_eno==1)
                      begin
                         cvpu_tx.out[counter]=cif.s_out;
                        `uvm_info("mon_before",$sformatf("data output is:(%0d)",cvpu_tx.out[counter]), UVM_LOW);
                         counter++;
                        `uvm_info("counter",$sformatf("counter is equal to :(%0d)",counter), UVM_LOW);
                        
                      end
                  
                    if(counter==4)
                      begin
                         cvpu_tx.out[3]=cif.s_out;
                         //`uvm_info("mon_before",$sformatf("data output is:(%0d)",cvpu_tx.out[3]), UVM_LOW);
                         mon_ap_before.write(cvpu_tx);
                         ++i_b;
                        `uvm_info("Driver",$sformatf("transaction(%0d)",i_b), UVM_LOW);
                         counter=0;
                      end
                   
		  
                   
		end
	end
endtask: run_phase
endclass: cvpu_mon_before



class cvpu_mon_after extends uvm_monitor;

	`uvm_component_utils(cvpu_mon_after)
	uvm_analysis_port#(cvpu_transaction) mon_ap_after;
	virtual cvpu_if cif;
	cvpu_transaction cvpu_tx;
	
function new(string name,uvm_component parent);
	super.new(name, parent);
	
endfunction: new

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	void'(uvm_resource_db#(virtual cvpu_if)::read_by_name(.scope("ifs"), .name("cvpu_if"), .val(cif)));
	mon_ap_after = new(.name("mon_ap_after"), .parent(this));
endfunction: build_phase


task run_phase(uvm_phase phase);
             integer i_f=0,i_m=0,flag=0;
             bit [1:0] fil[9];
             bit [1:0] data[16];
             cvpu_tx = cvpu_transaction::type_id::create(.name("cvpu_tx"), .contxt(get_full_name()));
	     forever begin
                   @(cif.s_clk)
                        begin
                        if(cif.s_clk==1)
                        begin  
                        if(cif.s_rst==0 && i_f<9 && cif.s_f_en==1 && cif.s_m_en==0)
                             begin 
                             
                               
                               i_f++;
                               fil[i_f-1]=cif.s_fil;
                               //i_f++;
                               `uvm_info("array",$sformatf("array_fil is equal to :(%0d)",fil[i_f-1]), UVM_LOW);
                                //`uvm_info("interface_in",$sformatf("in is equal to :(%0d)",cif.s_fil), UVM_LOW);
                               `uvm_info("iterator",$sformatf("iterator is equal to :(%0d)",i_f), UVM_LOW);
                               i_m=0;
                               flag=0;
                            end   
                           /*else if(i_f==9)
                              begin 
                               //fil[8]=cif.s_fil;
                               //i_f=0;
                               i_m=0;
                               flag=0;
                              end*/
                            
                     

                           else if(i_m<=16 && flag==0 && cif.s_f_en==0 && cif.s_m_en==1) 
                            begin 
                             i_m++;
                             `uvm_info("iterator_mat",$sformatf("iterator_mat is equal to :(%0d)",i_m), UVM_LOW);
                             data[i_m-1]=cif.s_mat;
                             `uvm_info("array",$sformatf("array_mat is equal to :(%0d)",data[i_m-1]), UVM_LOW);
                             /*if(i_m<11)
                                begin
                                  //data[i_m-1]=cif.s_mat;
                                end*/
                              if(i_m==11)
                                begin 
                                   //data[i_m-1]=cif.s_mat;
                                   cvpu_tx.out[0]=fil[0]*data[0]+fil[1]*data[1]+fil[2]*data[2]+fil[3]*data[4]+fil[4]*data[5]+fil[5]*data[6]+fil[6]*data[8]+fil[7]*data[9]+fil[8]*data[10];
                                   `uvm_info("mon_after",$sformatf("data output is:(%0d)",cvpu_tx.out[0]), UVM_LOW);
                                 end
                              

                              else if(i_m==12)
                                  begin
                                     //data[i_m-1]=cif.s_mat;
                                     cvpu_tx.out[1]=fil[0]*data[1] + fil[1]*data[2] + fil[2]*data[3] + fil[3]*data[5] + fil[4]*data[6] + fil[5]*data[7] + fil[6]*data[9] +fil[7]*data[10] +fil[8]*data[11];
                                     `uvm_info("mon_after",$sformatf("data output is:(%0d)",cvpu_tx.out[1]), UVM_LOW);
                                  end
    

                              /*else if(i_m>12 && i_m<15)
                                    begin 
                                      //data[i_m-1]=cif.s_mat;
                                    end*/
                              

                              else if(i_m==15)
                                     begin 
                                        //data[i_m-1]=cif.s_mat;  
                                        cvpu_tx.out[2]=fil[0]*data[4] + fil[1]*data[5] + fil[2]*data[6] + fil[3]*data[8] + fil[4]*data[9] + fil[5]*data[10] + fil[6]*data[12] +fil[7]*data[13] +fil[8]*data[14];
                                        `uvm_info("mon_after",$sformatf("data output is:(%0d)",cvpu_tx.out[2]), UVM_LOW);
                                    end
                              
                              else if(i_m==16)
                                      begin
                                        //data[i_m-1]=cif.s_mat;
                                        cvpu_tx.out[3]=fil[0]*data[5] + fil[1]*data[6] + fil[2]*data[7] + fil[3]*data[9] + fil[4]*data[10] + fil[5]*data[11] + fil[6]*data[13] +fil[7]*data[14] +fil[8]*data[15];
                                        mon_ap_after.write(cvpu_tx);
                                         i_m=0;
                                        `uvm_info("mon_after",$sformatf("data output is:(%0d)",cvpu_tx.out[3]), UVM_LOW);
                                        i_f=0;
                                        flag=1;
                                       end
 
                                end 
                               end
                              end
	                    end
endtask: run_phase 
endclass: cvpu_mon_after