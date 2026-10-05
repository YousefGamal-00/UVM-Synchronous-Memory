//------------------------------------------------------------------------------
// Author      : Yousef Gamal
// Module Name : test
// Description :
//    - Top-level UVM test; instantiates the environment and starts sequences.
//------------------------------------------------------------------------------

`ifndef TEST_SVH
`define TEST_SVH

class MEM_test extends uvm_test;

	`uvm_component_utils(MEM_test)

	MEM_env env_h ; 
	MEM_seq seq_h ;
	MEM_cfg cfg_h ;

	//------------------------------------------------------------------------------
	// Constructor
	//------------------------------------------------------------------------------
	function new(string name = "MEM_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	//------------------------------------------------------------------------------
	// Build phase
	//------------------------------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		env_h = MEM_env::type_id::create("env_h", this);
		seq_h = MEM_seq::type_id::create("seq_h");
		cfg_h = MEM_cfg::type_id::create("cfg_h");

		if(!uvm_config_db#(MEM_vif_t)::get(this, "", "MEM_Vif", cfg_h.vif))
			`uvm_fatal(get_full_name(), "Virtual interface not found in configuration database")

		uvm_config_db#(MEM_cfg)::set(this, "env_h.agt_h", "config_obj", cfg_h);	
	endfunction

	//------------------------------------------------------------------------------
	// Run phase
	//------------------------------------------------------------------------------
	task run_phase(uvm_phase phase);
		super.run_phase(phase);

		phase.raise_objection(this);
		
		seq_h.start(env_h.agt_h.sqr_h); // Start the sequence on the sequencer
		
		#50; // wait to flush the scoreboard and print the final match/mismatch counts
		
		phase.drop_objection(this);
		
	endtask
endclass

`endif // TEST_SVH 