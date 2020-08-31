class relu_test extends uvm_test;
		`uvm_component_utils(relu_test)

		relu_env r_env;

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction: new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			r_env = relu_env::type_id::create(.name("r_env"), .parent(this));
		endfunction: build_phase

		task run_phase(uvm_phase phase);
			relu_sequence r_seq;

			phase.raise_objection(.obj(this));
				r_seq = relu_sequence::type_id::create(.name("r_seq"), .contxt(get_full_name()));
				assert(r_seq.randomize());
				r_seq.start(r_env.r_agent.r_seqr);
			phase.drop_objection(.obj(this));
		endtask: run_phase
endclass: relu_test

