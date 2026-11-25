module vga_sync_core 
    import display_pkg::CD;
    import mcs_pk::VIDEO_SLOT_REG;
# (
    parameter  VIDEO_DATA_WIDTH = 32
) (
    input  logic                        clk_sys,
    input  logic                        clk_25m,
    input  logic                        arst_n,
    // video slot interface
    input  logic                        cs,
    input  logic                        write, 
    input  logic [VIDEO_SLOT_REG-1:0]   addr,
    input  logic [VIDEO_DATA_WIDTH-1:0] wr_data,

    input  logic [CD:0]                 si_data,
    input  logic                        si_valid,
    output logic                        si_ready,
    // to vga monitor
    output logic                        hsync,
    output logic                        vsync,
    output logic [CD-1:0]               rgb
);

    logic        line_so_valid;
    logic        vga_si_ready;
    logic [CD:0] line_so_data;

    // line buffer
    line_buffer u_line_buffer (
            .clk_stream_in  (clk_sys      ),
            .clk_stream_out (clk_25m      ),
            .arst_n         (arst_n       ),
            // stream in
            .si_data        (si_data      ), // color depth + start
            .si_valid       (si_valid     ),
            .si_ready       (si_ready     ),
            // stream out
            .so_data        (line_so_data ), // color depth + start
            .so_valid       (line_so_valid),
            .so_ready       (vga_si_ready )
    );

    // vga controller
    vga_sync u_vga_sync (
        .clk            (clk_25m      ),
        .arst_n         (arst_n       ),
        // stream input 
        .vga_si_data    (line_so_data ), // color + start
        .vga_si_valid   (line_so_valid),
        .vga_si_ready   (vga_si_ready ),
        // to vga monitor
        .hsync          (hsync        ),
        .vsync          (vsync        ),
        .rgb            (rgb          )
    );
    
endmodule