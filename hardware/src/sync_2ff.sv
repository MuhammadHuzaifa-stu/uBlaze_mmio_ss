module sync_2ff 
# (
    parameter WIDTH     = 1, 
    parameter RESET_VAL = 1'b0
) (
    input  logic             clk,
    input  logic             arst_n,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

    (* ASYNC_REG = "TRUE" *) logic [WIDTH-1:0] s1; 
    (* ASYNC_REG = "TRUE" *) logic [WIDTH-1:0] s2;

    always_ff @(posedge clk or negedge arst_n)
    begin
        if (!arst_n) 
        begin
            s1 <= {WIDTH{RESET_VAL}};
            s2 <= {WIDTH{RESET_VAL}};
        end 
        else 
        begin
            s1 <= d;
            s2 <= s1;
        end
    end
    
    assign q = s2;

endmodule