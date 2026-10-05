//------------------------------------------------------------------------------
// Author      : Yousef Gamal
// Module Name : top
// Description :
//    - Testbench top: imports the UVM and MEM packages and starts the test.
//------------------------------------------------------------------------------

`timescale 1ns/1ps

module top;

	import MEM_pkg::*;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	//------------------------------------------------------------------------------
	// clock Genetation 
	//------------------------------------------------------------------------------
	bit clk ;
	initial 
		begin
			forever #1 clk = ~clk;		
		end

	//------------------------------------------------------------------------------
	// DUT & interface instantiation
	//------------------------------------------------------------------------------
	
	// override interface's default DEPTH/WIDTH with pkg values to match the DUT
	MEM_if #(.DEPTH(DEPTH), .WIDTH(WIDTH)) mem_if(clk); 

	// connect parameters of DUT to the parameters of the package
	MEM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) DUT 
	(
		.clk      (mem_if.clk      ),
		.rst      (mem_if.rst      ),
		.wr_rd_n  (mem_if.wr_rd_n  ),
		.Address  (mem_if.Address  ),
		.Data_in  (mem_if.Data_in  ),
		.data_out (mem_if.data_out ),
		.Valid_out(mem_if.Valid_out)
	);

	//------------------------------------------------------------------------------
	// run test
	//------------------------------------------------------------------------------
	initial
		begin
			// Set the virtual interface in the configuration database
			uvm_config_db#(MEM_vif_t)::set(null, "uvm_test_top", "MEM_Vif", mem_if); 
			run_test("MEM_test");
		end
endmodule
