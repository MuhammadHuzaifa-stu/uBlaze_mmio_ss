module line_buffer 
    import display_pkg::CD; 
    import display_pkg::HD; 
(
    input  logic clk_stream_in,
    input  logic clk_stream_out,
    input  logic arst_n,
    // stream in
    input  logic [CD:0] si_data, // color depth + start
    input  logic        si_valid,
    output logic        si_ready,
    // stream out
    output logic [CD:0] so_data, // color depth + start
    output logic        so_valid,
    input  logic        so_ready
);
    
    localparam DW    = CD + 1; // color depth + start
    localparam DEPTH = $clog2(HD);

    logic             almost_full;
    logic             empty;
    
    logic             fifo_wr_en;
    logic             fifo_rd_ack;

    logic [DEPTH-1:0] rdcount;
    logic [DEPTH-1:0] wrcount; 

    bram_fifo_fpro # (
        .DEPTH ( DEPTH ),
        .DW    ( DW    )
    ) u_line_fifo_unit (
        .arst_n       ( arst_n         ),
        // read port
        .clk_rd       ( clk_stream_out ), // read clock
        .empty        ( empty          ), // read port empty
        .almost_empty (                ), // read port almost empty
        .rd_ack       ( fifo_rd_ack    ), // read aknowledge
        .rd_data      ( so_data        ), // read data
        // write port
        .clk_wr       ( clk_stream_in  ), // write clock  
        .full         (                ), // write port full
        .almost_full  ( almost_full    ), // write port almost full
        .wr_en        ( fifo_wr_en     ), // write aknowledge  
        .wr_data      ( si_data        ), // write data  
        // occupancy of fifo
        .rdcount      ( rdcount        ), // read count
        .wrcount      ( wrcount        )  // write count
    );

    assign fifo_wr_en  = si_valid;
    assign si_ready    = ~almost_full;
    assign so_valid    = ~empty;
    assign fifo_rd_ack = so_ready;

endmodule