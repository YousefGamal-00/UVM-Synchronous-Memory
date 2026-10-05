//------------------------------------------------------------------------------
// Author      : Yousef Gamal
// Module Name : MEM
// Description :
//    - Parameterized synchronous memory.
//    - Supports synchronous write and synchronous read.
//    - Valid_out indicates a valid data on output port.
//    - During the writing operation, Valid_out is set to 0 
//      and the data out is latch the value during the last read operation.
//------------------------------------------------------------------------------

module MEM #(parameter DEPTH = 16, WIDTH = 32)
(
    input  wire logic                        clk       , // Clock signal
    input  wire logic                        rst       , // Active-low asynchronous reset
    input  wire logic                        wr_rd_n   , // 1: Write, 0: Read
    input  wire logic    [WIDTH-1:0]         Data_in   , // Input data
    input  wire logic    [$clog2(DEPTH)-1:0] Address   , // Memory address

    output wire logic    [WIDTH-1:0]         data_out  , // Output data
    output wire logic                        Valid_out   // Output valid
);

    //-----------------------------------------------------------------------------
    // Internal Signals
    //-----------------------------------------------------------------------------
    reg    [WIDTH-1:0]           mem [DEPTH-1:0]; // Memory array
    reg    [WIDTH-1:0]           data_out_reg   ; // Registered output data 
    reg                          Valid_out_reg  ; // Registered output valid signal

    //-----------------------------------------------------------------------------
    // Output Assignments
    //-----------------------------------------------------------------------------
    assign data_out  = data_out_reg;
    assign Valid_out = Valid_out_reg;

    //-----------------------------------------------------------------------------
    // Read Operation Logic
    // When wr_rd_n = 0, read data from memory.
    //-----------------------------------------------------------------------------
    always @(posedge clk or negedge rst)
        begin
            if (!rst)
                begin
                    data_out_reg  <= '0;
                    Valid_out_reg <= 1'b0;
                end
            else if (!wr_rd_n)
                begin
                    data_out_reg  <= mem[Address];
                    Valid_out_reg <= 1'b1;
                end
            else
                begin
                    Valid_out_reg <= 1'b0;
                end
        end

    //-----------------------------------------------------------------------------
    // Write Operation Logic
    // When wr_rd_n = 1, write data into memory.
    //-----------------------------------------------------------------------------
    always @(posedge clk or negedge rst)
        begin
            if (!rst)
                begin
                    mem <= '{default:'0};
                end
            else if (wr_rd_n)
                begin
                    mem[Address] <= Data_in;
                end
        end

endmodule