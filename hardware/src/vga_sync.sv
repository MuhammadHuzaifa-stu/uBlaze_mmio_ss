module vga_sync_demo 
    import display_pkg::CD;

    import display_pkg::HD;
    import display_pkg::HF;
    import display_pkg::HB;
    import display_pkg::HR;
    import display_pkg::HT;

    import display_pkg::VD;
    import display_pkg::VF;
    import display_pkg::VB;
    import display_pkg::VR;
    import display_pkg::VT;

(
    input  logic          clk,
    input  logic          arst_n,
    // stream input 
    input  logic [CD:0]   vga_si_data, // color + start
    input  logic          vga_si_valid,
    output logic          vga_si_ready,
    // to vga monitor
    output logic          hsync,
    output logic          vsync,
    output logic [CD-1:0] rgb
);

    typedef enum { 
        FRAME_SYNC, 
        DISP 
    } state_t;

    state_t                CS;
    state_t                NS;

    logic                  vga_st_in_start;
    logic [CD-1:0]         vga_st_in_color;
    
    logic [$clog2(HT)  :0] x;
    logic [$clog2(VT)  :0] y;

    logic                  hsync_i;
    logic                  vsync_i;
    logic                  hsync_reg;
    logic                  vsync_reg;

    logic                  video_on_i;
    logic                  scan_end;
    logic [CD-1:0]         rgb_reg;
    logic                  vga_si_ready_i;
    
    assign vga_st_in_start = vga_si_data[0];
    assign vga_st_in_color = vga_si_data[CD:1];

    frame_counter #(
        .HMAX(HT),
        .VMAX(VT)
    ) u_frame_counter (
        .clk         ( clk      ),
        .arst_n      ( arst_n   ),
        .sync_clr    ( 1'b0     ), // never clear sync
        .hcount      ( x        ),
        .vcount      ( y        ),
        .inc         ( 1'b1     ),
        .frame_start (          ),
        .frame_end   ( scan_end )
    );

    // horixontal sync: decoding
    assign hsync_i = (x >= (HD + HF)) && (x <= (HD + HF + HR - 1)) ? 0 : 1;
    // vertical sync: decoding
    assign vsync_i = (y >= (VD + VF)) && (y <= (VD + VF + VR - 1)) ? 0 : 1;
    // NOTE: Since HB and VB are related to CRT (required time to move back 
    //       physically), they do not affect the sync signal. Only HR and VR 
    //       matter for sync.

    // display on/off
    assign video_on_i = (x < HD) && (y < VD);

    //buffered output to vga monitor
    always_ff @(posedge clk) 
    begin
        vsync_reg    <= vsync_i;
        hsync_reg    <= hsync_i;
        if (video_on_i)
        begin
            rgb_reg <= vga_st_in_color;
        end
        else
        begin
            rgb_reg <= 0; // black when video off
        end
    end

    // FSM to synchronize data for each frame
    always_ff @( posedge clk or negedge arst_n ) 
    begin
        if (~arst_n)
        begin
            CS <= FRAME_SYNC;
        end
        else
        begin
            CD <= NS;
        end
    end

    always_comb 
    begin
        NS             = CS;
        vga_si_ready_i = 1'b0;

        case (CS)
            FRAME_SYNC: begin
                // wait for end of current scan
                if (scan_end)
                begin
                    if (vga_st_in_start)
                    begin
                        NS = DISP;
                    end
                    else
                    begin
                        NS = FRAME_SYNC;
                    end
                end
                // flush out partial frame fragement
                // (due to corruption or incorrectly formed long packet)
                if (~vga_st_in_start)
                begin
                    vga_si_ready_i = 1'b1;
                end
            end
            default: begin
                // resync when reaching end of the displayable data
                if ((x == HD-1) && (y == VD-1))
                begin
                    NS = FRAME_SYNC;
                end
                if (video_on_i)
                begin
                    vga_si_ready_i = 1'b1;
                end
            end
        endcase
    end

    //output
    assign hsync        = hsync_reg;
    assign vsync        = vsync_reg;
    assign rgb          = rgb_reg;
    assign vga_si_ready = vga_si_ready_i;

endmodule