module bram_fifo_fpro 
    import display_pkg::CD;
    import display_pkg::HD;
# (
    parameter DEPTH = $clog2(HD),
    parameter DW    = CD + 1 // color depth + start bit
) (
    input  logic             arst_n,
    // read port
    input  logic             clk_rd,       // read clock
    output logic             empty,        // read port empty
    output logic             almost_empty, // read port almost empty
    input  logic             rd_ack,       // read aknowledge
    output logic [DW-1:0]    rd_data,      // read data
    // write port
    input  logic             clk_wr,       // write clock  
    output logic             full,         // write port full
    output logic             almost_full,  // write port almost full
    input  logic             wr_en,        // write aknowledge  
    input  logic [DW-1:0]    wr_data,      // write data  
    // occupancy of fifo
    output logic [DEPTH-1:0] rdcount,      // read count
    output logic [DEPTH-1:0] wrcount       // write count
);
    
    // xilinx macro instantiation
    FIFO_DUALCLOCK_MACRO #(
        .ALMOST_EMPTY_OFFSET    ( 9'h08     ),
        .ALMOST_FULL_OFFSET     ( 9'h08     ),
        .DATA_WIDTH             ( DW        ),
        .DEVICE                 ( "7SERIES" ),
        .FIFO_SIZE              ( "18kb"    ),
        .FIRST_WORD_FALL_THROUGH( "TRUE"    )
    ) bram_fifo_unit (
        .RST         ( arst_n       ),
        // READ PORT
        .RDCLK       ( clk_rd       ),
        .DO          ( rd_data      ),
        .RDEN        ( rd_ack       ),
        .EMPTY       ( empty        ),
        .ALMOSTEMPTY ( almost_empty ),
        .RDCOUNT     ( rdcount      ),
        .RDERR       (              ),
        // WRITE PORT
        .WRCLK       ( clk_wr       ),
        .DI          ( wr_data      ),
        .WREN        ( wr_en        ),
        .FULL        ( full         ),
        .ALMOSTFULL  ( almost_full  ),
        .WRCOUNT     ( wrcount      ),
        .WRERR       (              )
    );

endmodule