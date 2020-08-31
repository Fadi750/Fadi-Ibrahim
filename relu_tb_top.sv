`include "relu_pkg.sv"
`include "relu_if.sv"
`include "testrelu.v"
module relu_tb_top;
	import uvm_pkg::*;
 	import relu_pkg::*;
	relu_if rif();
	testrelu dut(rif.relu_clk,
		  rif.relu_reset,
		  rif.relu_in,

		  rif.relu_out,
		  rif.relu_en_o);

initial begin
	uvm_resource_db#(virtual relu_if)::set(.scope("ifs"), .name("relu_if"), .val(rif));
	`uvm_info("TOP",$sformatf("IF added to db, Test will be initiated"), UVM_LOW);
	run_test();
end

initial begin
	rif.relu_clk <= 1'b1;
	`uvm_info("TOP",$sformatf("CLK set and ready"), UVM_LOW);
end

always
 #5 rif.relu_clk = ~rif.relu_clk;

endmodule
