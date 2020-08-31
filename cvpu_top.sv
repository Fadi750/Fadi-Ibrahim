`include "cvpu_pkg.sv"
`include "cvpu_if.sv"
`include "CVPU.v"
module cvpu_top;
	import uvm_pkg::*;
 	import cvpu_pkg::*;
	cvpu_if cif();
	cvpu dut(cif.s_clk,
		  cif.s_rst,
		  cif.s_f_en,
                  cif.s_m_en,
                  cif.s_mat,
                  cif.s_fil,

		  cif.s_out,
		  cif.s_eno);

initial begin
	uvm_resource_db#(virtual cvpu_if)::set(.scope("ifs"), .name("cvpu_if"), .val(cif));
	`uvm_info("TOP",$sformatf("IF added to db, Test will be initiated"), UVM_LOW);
	run_test();
end

initial begin
	cif.s_clk <= 1'b1;
	`uvm_info("TOP",$sformatf("CLK set and ready"), UVM_LOW);
end

always
 #5 cif.s_clk = ~cif.s_clk;

endmodule