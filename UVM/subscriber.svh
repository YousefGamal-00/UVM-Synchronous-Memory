//------------------------------------------------------------------------------
// Author      : Yousef Gamal
// Module Name : subscriber
// Description :
//    - Analysis subscriber for functional coverage sampling.
//------------------------------------------------------------------------------

`ifndef SUBSCRIBER_SVH
`define SUBSCRIBER_SVH

class MEM_CVG extends uvm_component ;

	`uvm_component_utils(MEM_CVG)

	uvm_analysis_imp #(MEM_seq_item, MEM_CVG) cvg_imp ; // Analysis implementation for functional coverage sampling	

	MEM_seq_item cvg_item; 

	//------------------------------------------------------------------------------
	// cover group 
	//------------------------------------------------------------------------------
	covergroup cg;
        //---------------------------------------------------------------
		// Write/Read Operation
		// WR/RD is a 1-bit signal, so we can cover all possible values
        //---------------------------------------------------------------
        wr_rd_cp : coverpoint cvg_item.wr_rd_n
        {
            bins WR        = {1};
            bins RD        = {0};
            bins WR_to_RD  = (1 => 0);
            bins RD_to_WR  = (0 => 1);
            bins WR_to_WR  = (1 => 1);
            bins RD_to_RD  = (0 => 0);
        }

        //---------------------------------------------------------------
        // Address
		// Cover the first, last, and middle addresses to ensure that
        //---------------------------------------------------------------
        address_cp : coverpoint cvg_item.Address
        {
            bins ADDR_0     = {0};
            bins ADDR_MAX   = {DEPTH-1};
            bins ADDR_MID[] = {[1:DEPTH-2]};
        }

        //---------------------------------------------------------------
		// Data_in
		// Cover all zeros, all ones, and other values to ensure that
		// the memory can handle different data patterns.
        //---------------------------------------------------------------
        data_cp : coverpoint cvg_item.Data_in
        {
            bins ALL_ZEROS = {'0};
            bins ALL_ONES  = {'1};
            bins OTHERS    = default;
        }

        //---------------------------------------------------------------
		// Reset Signal
		// Cover the reset signal to ensure that the memory can handle
        //---------------------------------------------------------------
        rst_cp : coverpoint cvg_item.rst
        {
            bins ASSERTED   = {0};
            bins DEASSERTED = {1};
        }

        //---------------------------------------------------------------
        // Crosses
        //---------------------------------------------------------------
        cross_wr_rd_addr_cp : cross wr_rd_cp, address_cp; // ensure that we cover all combinations of write/read operations and addresses
        cross_wr_rd_rst_cp  : cross wr_rd_cp, rst_cp;     // ensure that we cover all combinations of write/read operations and reset signal

    endgroup
	//------------------------------------------------------------------------------
	// Constructor
	//------------------------------------------------------------------------------
	function new(string name = "MEM_CVG", uvm_component parent = null);
		super.new(name, parent);
		cg = new();
	endfunction
	//------------------------------------------------------------------------------
	// Build phase
	//------------------------------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		cvg_imp = new("cvg_imp", this);	
	endfunction
	//------------------------------------------------------------------------------
	// Write Task
	//------------------------------------------------------------------------------
	function void write(MEM_seq_item item);

		cvg_item = item; // Store the item for functional coverage sampling
		cg.sample();     // Sample the covergroup for functional coverage
		
		// Sample functional coverage here
		`uvm_info(get_type_name(), $sformatf("Functional Coverage Sampled: %s", item.convert2string()), UVM_DEBUG)

	endfunction
endclass

`endif // SUBSCRIBER_SVH
