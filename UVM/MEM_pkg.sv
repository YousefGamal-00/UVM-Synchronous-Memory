//------------------------------------------------------------------------------
// Author      : Yousef Gamal
// Module Name : MEM_pkg
// Description :
//    - UVM testbench package; includes all agent, environment, sequence,
//      and test class files.
//------------------------------------------------------------------------------

package MEM_pkg;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	//------------------------------------------------------------------------------
	// Parameters:
	// As the Design has paramters & classes & interface we should depend on one source for deriving the parameters, 
	// so we will define the parameters in the package and use them in the interface & classes & design.
	//------------------------------------------------------------------------------
		localparam int NUM_TEST = 100000;
		localparam int DEPTH    = 8;
		localparam int WIDTH    = 16;

	//------------------------------------------------------------------------------
	// As the inteface Has paramters 
	//	--> Define a type for interface to be paramterized with the same values in design & TB 
	//------------------------------------------------------------------------------
	// Parameterized Virtual Interface Typedef
	// Common virtual interface typedef
	//   - Use MEM_vif_t for all virtual MEM_if handles.
	//   - Ensures consistent interface type across TB and config_db set/get.
	//------------------------------------------------------------------------------ 
	typedef virtual MEM_if #(.DEPTH(DEPTH), .WIDTH(WIDTH)) MEM_vif_t;

	//------------------------------------------------------------------------------
	// Include all UVM class files
	//------------------------------------------------------------------------------
	`include "seq_item.svh"
	`include "config_obj.svh"
	`include "driver.svh"
	`include "monitor.svh"
	`include "sequencer.svh"  
	`include "agent.svh"
	`include "scoreboard.svh"
	`include "subscriber.svh"
	`include "env.svh"
	`include "sequence.svh"
	`include "test.svh"

endpackage

