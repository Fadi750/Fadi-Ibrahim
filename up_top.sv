`include "up_pkg.sv"
`include "up_if.sv"
`include "ups.v"
module up_top;
	import uvm_pkg::*;
 	import up_pkg::*;
	up_if upif();
	ups dut(upif.up_clk,
		  upif.up_rst,
		  upif.up_in,

		  upif.up_out,
		  upif.up_eno);

initial begin
	uvm_resource_db#(virtual up_if)::set(.scope("ifs"), .name("up_if"), .val(upif));
	`uvm_info("TOP",$sformatf("IF added to db, Test will be initiated"), UVM_LOW);
	run_test();
end

initial begin
	upif.up_clk <= 1'b1;
	`uvm_info("TOP",$sformatf("CLK set and ready"), UVM_LOW);
end

always
 #5 upif.up_clk = ~upif.up_clk;

endmodule