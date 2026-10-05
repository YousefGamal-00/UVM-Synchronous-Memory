//------------------------------------------------------------------------------
// Author      : Yousef Gamal
// Module Name : agent
// Description :
//    - UVM agent containing the driver, monitor, and sequencer.
//------------------------------------------------------------------------------

`ifndef AGENT_SVH
`define AGENT_SVH

class MEM_agent extends uvm_agent;

	`uvm_component_utils(MEM_agent)

	MEM_driver                        drv_h ; 
	MEM_monitor                       mon_h ;
	MEM_sequencer                     sqr_h ;
	MEM_cfg                           cfg_h ;
	uvm_analysis_port #(MEM_seq_item) agt_ap ;
	//------------------------------------------------------------------------------
	// Constructor
	//------------------------------------------------------------------------------
	function new(string name = "MEM_agent", uvm_component parent = null);
		super.new(name, parent);
	endfunction	

	//------------------------------------------------------------------------------
	// Build phase
	//------------------------------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db#(MEM_cfg)::get(this, "", "config_obj", cfg_h))
			`uvm_fatal(get_full_name(), "MEM_cfg not found in configuration database")

		agt_ap = new("agt_ap", this);
		drv_h = MEM_driver::type_id::create("drv_h", this);
		mon_h = MEM_monitor::type_id::create("mon_h", this);
		sqr_h = MEM_sequencer::type_id::create("sqr_h", this);
	endfunction

	//------------------------------------------------------------------------------
	// Connect phase
	//------------------------------------------------------------------------------
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		drv_h.vif = cfg_h.vif;
		mon_h.vif = cfg_h.vif;
		mon_h.mon_ap.connect(agt_ap);                       // Connect the monitor's analysis port to the agent's analysis port
		drv_h.seq_item_port.connect(sqr_h.seq_item_export); // Connect the driver's sequence item port to the sequencer's export
	endfunction
endclass

`endif // AGENT_SVH
