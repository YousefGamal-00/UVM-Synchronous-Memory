//------------------------------------------------------------------------------
// Author      : Yousef Gamal
// Module Name : monitor
// Description :
//    - Samples interface activity and publishes transactions via analysis port.
//------------------------------------------------------------------------------

`ifndef MONITOR_SVH
`define MONITOR_SVH

class MEM_monitor extends uvm_monitor;

	`uvm_component_utils(MEM_monitor)

	MEM_vif_t    vif      ; // Virtual interface handle
	MEM_seq_item seq_item ; // Sequence item transaction

	uvm_analysis_port #(MEM_seq_item) mon_ap; // Analysis port for Broadcasting transactions

	//------------------------------------------------------------------------------
	// Constructor
	//------------------------------------------------------------------------------
	function new(string name = "MEM_monitor", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	//------------------------------------------------------------------------------
	// Build phase
	//------------------------------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon_ap = new("mon_ap", this); // Create the analysis port
	endfunction

	//------------------------------------------------------------------------------
	// Run phase
	//------------------------------------------------------------------------------
	task run_phase(uvm_phase phase);
		super.run_phase(phase);

		@(vif.cb_mon) ;  // Discard the first transaction as cb_mon samples before driver

		seq_item = MEM_seq_item::type_id::create("seq_item"); // Create a sequence item object
		forever
			begin

				@(vif.cb_mon) ;
				seq_item.rst       <= vif.cb_mon.rst;       // Sample the reset signal
				seq_item.wr_rd_n   <= vif.cb_mon.wr_rd_n;   // Sample the write/read signal
				seq_item.Data_in   <= vif.cb_mon.Data_in;   // Sample the input data
				seq_item.Address   <= vif.cb_mon.Address;   // Sample the address
				seq_item.data_out  <= vif.cb_mon.data_out;  // Sample the data output
				seq_item.Valid_out <= vif.cb_mon.Valid_out; // Sample the valid output signal

				#1step;
				`uvm_info("MONITOR", seq_item.convert2string(), UVM_HIGH) // Print the sampled transaction

				mon_ap.write(seq_item); // Broadcast the transaction via analysis port
			end
	endtask
endclass

`endif // MONITOR_SVH
