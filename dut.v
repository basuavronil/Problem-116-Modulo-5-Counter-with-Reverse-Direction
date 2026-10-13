module abc (
    input  wire       clk,
    input  wire       rst,
    input  wire       dir,
    input  wire       en,
    output wire [2:0] current_state
);

    localparam S0 = 3'd0;
    localparam S1 = 3'd1;
    localparam S2 = 3'd2;
    localparam S3 = 3'd3;
    localparam S4 = 3'd4;
    localparam S5 = 3'd5;

    reg [2:0] p_state, n_state;

    // Sequential state register
    always @(posedge clk or negedge rst) begin
        if (!rst)
            p_state <= S0;
        else 
            p_state <= n_state;
    end

    // Combinational next-state logic using case and if statements
    always @(*) begin
        // Default assignment prevents latches when en = 0
        n_state = p_state;

        if (en) begin
            case (p_state)
                S0: begin
                    if (dir) n_state = S5; // count down
                    else     n_state = S1; // count up
                end
                
                S1: begin
                    if (dir) n_state = S0;
                    else     n_state = S2;
                end
                
                S2: begin
                    if (dir) n_state = S1;
                    else     n_state = S3;
                end
                
                S3: begin
                    if (dir) n_state = S2;
                    else     n_state = S4;
                end
                
                S4: begin
                    if (dir) n_state = S3;
                    else     n_state = S5;
                end
                
                S5: begin
                    if (dir) n_state = S4;
                    else     n_state = S0;
                end
                
                default: n_state = S0;
            endcase
        end
    end

    // Continuous output assignment
    assign current_state = p_state;

endmodule
