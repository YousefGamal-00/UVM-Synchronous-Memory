//------------------------------------------------------------------------------
// Author      : Yousef Gamal
// Module Name : sequencer
// Description :
//    - Arbitrates sequence items between sequences and the driver.
//------------------------------------------------------------------------------

`ifndef SEQUENCER_SVH
`define SEQUENCER_SVH

class MEM_sequencer extends uvm_sequencer #(MEM_seq_item);

	`uvm_component_utils(MEM_sequencer)

	//------------------------------------------------------------------------------
	// Constructor
	//------------------------------------------------------------------------------
	function new(string name = "MEM_sequencer", uvm_component parent = null);
		super.new(name, parent);
	endfunction

endclass

`endif // SEQUENCER_SVH

