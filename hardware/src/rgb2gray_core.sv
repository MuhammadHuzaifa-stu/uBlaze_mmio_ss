module rgb2gray_core
    import display_pkg::CD;
    import mcs_pkg::VIDEO_SLOT_REG;
#(
    parameter  VIDEO_DATA_WIDTH = 32
)(
    input  logic                        clk,
    input  logic                        arst_n,
    // video slot interface
    input  logic                        cs,
    input  logic                        write,
    input  logic [VIDEO_SLOT_REG-1  :0] addr,
    input  logic [VIDEO_DATA_WIDTH-1:0] wr_data,
    // stream interface
    input  logic [CD-1:0]               si_rgb,
    output logic [CD-1:0]               so_rgb
);

    logic          wr_en;
    logic          bypass_reg;
    logic [CD-1:0] gray_rgb;
    
    assign wr_en  = write & cs;
    // blending: bypass mux
    assign so_rgb = bypass_reg ? si_rgb : gray_rgb;

    rgb2gray u_rgb2gray_unit (
        .color_rgb( si_rgb   ),
        .gray_rgb ( gray_rgb )
    );

    always_ff @( posedge clk or negedge arst_n ) 
    begin
        if (~arst_n)
        begin
            bypass_reg <= 'd1;
        end
        else if (wr_en)
        begin
            bypass_reg <= wr_data[0];
        end
    end

endmodule