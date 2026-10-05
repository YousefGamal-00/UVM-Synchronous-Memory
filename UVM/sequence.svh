//------------------------------------------------------------------------------
// Author      : Yousef Gamal
// Module Name : sequence
// Description :
//    - Base sequence class.
//------------------------------------------------------------------------------

`ifndef SEQIENCE_SVH
`define SEQIENCE_SVH

class MEM_seq extends uvm_sequence;

	`uvm_object_utils(MEM_seq)

	MEM_seq_item seq_item ; // Sequence item handle

	//------------------------------------------------------------------------------
	// Constructor
	//------------------------------------------------------------------------------
	function new(string name = "MEM_seq");
		super.new(name);
	endfunction

	//------------------------------------------------------------------------------
	// task: body
	//------------------------------------------------------------------------------
	task body();
		
		seq_item = MEM_seq_item::type_id::create("seq_item"); // Create a sequence item object
		start_item(seq_item);  // Start the sequence item
			seq_item.rst     = 0;
			seq_item.wr_rd_n = 0;
			seq_item.Data_in = 0;
			seq_item.Address = 0;
		finish_item(seq_item); // Finish the sequence item

		repeat(NUM_TEST)
			begin
				start_item(seq_item);     // Start the sequence item
					 // Randomize the sequence item
					assert(seq_item.randomize())
					else 
						begin
							`uvm_fatal("RANDOMIZE_FAIL", "Failed to randomize sequence item")
						end
				finish_item(seq_item);    // Finish the sequence item
			end
	endtask
	
endclass

`endif // SEQUENCE_SVH
