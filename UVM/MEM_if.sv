interface MEM_if (input wire logic clk);

    parameter DEPTH = 16, WIDTH = 32 ; 

    logic                        rst       ; // Active-low asynchronous reset
    logic                        wr_rd_n   ; // 1: Write, 0: Read
    logic    [WIDTH-1:0]         Data_in   ; // Input data
    logic    [$clog2(DEPTH)-1:0] Address   ; // Memory address

    logic    [WIDTH-1:0]         data_out  ; // Output data
    logic                        Valid_out ; // Output valid

    //-----------------------------------------------------------------------------
    // Clocking Block : Driver
    //-----------------------------------------------------------------------------
    clocking cb_drv @ (posedge clk);
        default output #1step;
        output rst, wr_rd_n, Data_in, Address;
    endclocking

    //-----------------------------------------------------------------------------
    // Clocking Block : Monitor
    //-----------------------------------------------------------------------------
    clocking cb_mon @ (posedge clk);
        default input #0;
        input rst, wr_rd_n, Data_in, Address, data_out, Valid_out;
    endclocking
endinterface