//------------------------------------------------------------------------------
// Author      : Yousef Gamal
// Module Name : driver
// Description :
//    - Drives seq_item transactions onto the DUT interface.
//------------------------------------------------------------------------------

`ifndef DRIVER_SVH
`define DRIVER_SVH

class MEM_driver extends uvm_driver #(MEM_seq_item);

	`uvm_component_utils(MEM_driver)

	MEM_vif_t    vif      ; // Virtual interface handle
	MEM_seq_item seq_item ; // Sequence item handle
	//------------------------------------------------------------------------------
	// Constructor
	//------------------------------------------------------------------------------
	function new(string name = "MEM_driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	//------------------------------------------------------------------------------
	// Build phase
	//------------------------------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	//------------------------------------------------------------------------------
	// run phase
	//------------------------------------------------------------------------------
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever 
			begin
				seq_item = MEM_seq_item::type_id::create("seq_item");
				seq_item_port.get_next_item(seq_item);      // Get the next sequence item from the sequencer

					@(vif.cb_drv)
					vif.cb_drv.rst     <= seq_item.rst;     // Drive the reset signal
					vif.cb_drv.wr_rd_n <= seq_item.wr_rd_n; // Drive the write/read signal
					vif.cb_drv.Data_in <= seq_item.Data_in; // Drive the input data
					vif.cb_drv.Address <= seq_item.Address; // Drive the address
				seq_item_port.item_done();                  // Indicate that the sequence item is done
			end
	endtask
endclass

`endif 
