//if u want to test remove the "//" in the next 2 lines
//import uvm_pkg::*;
//`include "uvm_macros.svh"
class cvpu_configuration extends uvm_object;
	`uvm_object_utils(cvpu_configuration)

	function new(string name= "");
		super.new(name);
	endfunction: new
endclass: cvpu_configuration