class cvpu_test extends uvm_test;
		`uvm_component_utils(cvpu_test)

		cvpu_env c_env;

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction: new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			c_env = cvpu_env::type_id::create(.name("c_env"), .parent(this));
		endfunction: build_phase

		task run_phase(uvm_phase phase);
			cvpu_sequence c_seq;

			phase.raise_objection(.obj(this));
				c_seq = cvpu_sequence::type_id::create(.name("c_seq"), .contxt(get_full_name()));
				assert(c_seq.randomize());
				c_seq.start(c_env.c_agent.c_seqr);
			phase.drop_objection(.obj(this));
		endtask: run_phase
endclass: cvpu_test