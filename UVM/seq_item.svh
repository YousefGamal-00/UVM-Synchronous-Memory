//------------------------------------------------------------------------------
// Author      : Yousef Gamal
// class Name  : MEM_seq_item
// Description :
//    - Sequence item transaction class.
//------------------------------------------------------------------------------

`ifndef SEQ_ITEM_SVH
`define SEQ_ITEM_SVH

class MEM_seq_item extends uvm_sequence_item;

	`uvm_object_utils(MEM_seq_item)

	//------------------------------------------------------------------------------
	// Data members
	//------------------------------------------------------------------------------
    rand logic                        rst       ; // Active-low asynchronous reset
    rand logic                        wr_rd_n   ; // 1: Write, 0: Read
    rand logic    [WIDTH-1:0]         Data_in   ; // Input data
    rand logic    [$clog2(DEPTH)-1:0] Address   ; // Memory address

    logic    [WIDTH-1:0]         data_out  ; // Output data
    logic                        Valid_out ; // Output valid

	//------------------------------------------------------------------------------
	// constructor
	//------------------------------------------------------------------------------
	function new(string name = "MEM_seq_item");
		super.new(name);
	endfunction

	//------------------------------------------------------------------------------
	// Constraints
	//------------------------------------------------------------------------------
	constraint rst_c {rst dist {1:/95, 0:/5};}
	
	constraint read_write_c {wr_rd_n dist {1:/60, 0:/40};}

	constraint address_c 
	{
		Address dist 
		{
			0             := 50,
			DEPTH-1       := 50,
			[1:DEPTH-2]   := 10
		};
	}

	constraint data_in_c 
	{
		Data_in dist 
		{
			0                := 5 ,
			{WIDTH{1'b1}}    := 5 ,
			[1: 1<<WIDTH -2] := 10
		};
	}
	//------------------------------------------------------------------------------
	// convert2string: one-line, human-readable dump of the transaction
	// (used in `uvm_info` logging from driver/monitor/scoreboard)
	//------------------------------------------------------------------------------
	function string convert2string();
		return $sformatf
		(
			"RST=%0b | OP=%-2s | ADDR=0x%0h | DATA_IN=0x%0h | DATA_OUT=0x%0h | VALID_OUT=%0b",
			rst,
			(wr_rd_n ? "WR" : "RD"),
			Address,
			Data_in,
			data_out,
			Valid_out
		);
	endfunction

endclass

`endif // SEQ_ITEM_SVH
