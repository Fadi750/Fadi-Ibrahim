class up_test extends uvm_test;
		`uvm_component_utils(up_test)

		up_env u_env;

		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction: new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			u_env = up_env::type_id::create(.name("u_env"), .parent(this));
		endfunction: build_phase

		task run_phase(uvm_phase phase);
			up_sequence u_seq;

			phase.raise_objection(.obj(this));
				u_seq = up_sequence::type_id::create(.name("u_seq"), .contxt(get_full_name()));
				assert(u_seq.randomize());
				u_seq.start(u_env.u_agent.u_seqr);
			phase.drop_objection(.obj(this));
		endtask: run_phase
endclass: up_test
