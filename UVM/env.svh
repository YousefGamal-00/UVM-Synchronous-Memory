//------------------------------------------------------------------------------
// Author      : Yousef Gamal
// Module Name : env
// Description :
//    - Top-level verification environment: agt_h, scoreboard, coverage.
//------------------------------------------------------------------------------

`ifndef ENV_SVH
`define ENV_SVH

class MEM_env extends uvm_env;

	`uvm_component_utils(MEM_env)

	MEM_agent		agt_h ; // agt_h instance
	MEM_scoreboard  sb_h  ; // Scoreboard instance
	MEM_CVG         cvg_h ; // Coverage instance

	//------------------------------------------------------------------------------
	// Constructor
	//------------------------------------------------------------------------------
	function new(string name = "MEM_env", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	//------------------------------------------------------------------------------
	// Build phase
	//------------------------------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		agt_h   = MEM_agent::type_id::create("agt_h", this);
		sb_h    = MEM_scoreboard::type_id::create("sb_h", this);
		cvg_h   = MEM_CVG::type_id::create("cvg_h", this);
	endfunction

	//------------------------------------------------------------------------------
	// connect phase 
	//------------------------------------------------------------------------------
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		agt_h.agt_ap.connect(sb_h.sb_imp);   // Connect the agt_h's analysis port to the scoreboard's analysis export
		agt_h.agt_ap.connect(cvg_h.cvg_imp); // Connect the agt_h's analysis port to the coverage's analysis export
	endfunction
endclass

`endif // ENV_SVH
