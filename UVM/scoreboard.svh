//------------------------------------------------------------------------------
// Author      : Yousef Gamal
// Module Name : scoreboard
// Description :
//    - Checks DUT output against the reference model.
//------------------------------------------------------------------------------

`ifndef SCOREBOARD_SVH
`define SCOREBOARD_SVH

class MEM_scoreboard extends uvm_scoreboard;

	`uvm_component_utils(MEM_scoreboard)

	uvm_analysis_imp #(MEM_seq_item, MEM_scoreboard) sb_imp ; // Analysis implementation

	bit [WIDTH-1:0] mem_model     [DEPTH-1:0] ; // Reference model
	bit [WIDTH-1:0] data_out_ref              ; // Reference model output
	bit             Valid_out_ref             ; // Reference model output validity

	int match_count    = 0; // Count of matching transactions
	int mismatch_count = 0; // Count of mismatching transactions
	//------------------------------------------------------------------------------
	// Constructor
	//------------------------------------------------------------------------------
	function new(string name = "MEM_scoreboard", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	//------------------------------------------------------------------------------
	// Build phase
	//------------------------------------------------------------------------------
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sb_imp = new("sb_imp", this);
	endfunction

	//------------------------------------------------------------------------------
	// Write method for analysis port
	//------------------------------------------------------------------------------
	function void write(MEM_seq_item item);
		`uvm_info("SCOREBOARD", $sformatf("Received transaction: %0s", item.convert2string()), UVM_HIGH)
		ref_model(item);
		compare(item);
	endfunction

	//------------------------------------------------------------------------------
	// Reference model
	//------------------------------------------------------------------------------
	function void ref_model(MEM_seq_item item);
		if(!item.rst) 
			begin
				mem_model = '{default:0}; // Reset the reference model
				data_out_ref  = '0;
				Valid_out_ref = 0;
			end
		else 
			begin
				if (item.wr_rd_n)
					begin		
						mem_model[item.Address] = item.Data_in; // Write to the reference model
						Valid_out_ref = 0;
					end	
				else	
					begin
						Valid_out_ref = 1;
						data_out_ref  = mem_model[item.Address]; // Read from the reference model
					end
			end
	endfunction

	//------------------------------------------------------------------------------
	// Compare DUT output with reference model
	//------------------------------------------------------------------------------
	function void compare(MEM_seq_item item);
		if (item.data_out !== data_out_ref || item.Valid_out !== Valid_out_ref)
			begin
				mismatch_count++;
				`uvm_error("SCOREBOARD", $sformatf("Mismatch: %0s | Reference output = 0x%0h, Reference Valid = %0b", item.convert2string(), data_out_ref, Valid_out_ref))
			end
		else
			begin
				match_count++;
				`uvm_info("SCOREBOARD", $sformatf("Match: %0s | Reference output = 0x%0h, Reference Valid = %0b", item.convert2string(), data_out_ref, Valid_out_ref), UVM_HIGH)
			end
	endfunction

	//------------------------------------------------------------------------------
	// Report phase: print the final match/mismatch counts
	//------------------------------------------------------------------------------
	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("SCOREBOARD", $sformatf("Total Matches: %0d || Total Mismatches: %0d", match_count, mismatch_count), UVM_LOW)
	endfunction
endclass

`endif // SCOREBOARD_SVH

