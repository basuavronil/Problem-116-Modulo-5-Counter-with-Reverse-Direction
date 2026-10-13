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

    // 1. Sequential state register
    always @(posedge clk or negedge rst) begin
        if (!rst)
            p_state <= S0;
        else 
            p_state <= n_state;
    end

    // 2. Combinational next-state logic
    always @(*) begin
        // Default: hold current state (prevents latches and handles en = 0)
        n_state = p_state;

        if (en) begin
            case (p_state)
                // dir = 0: count up (+1) | dir = 1: count down (-1 mod 6)
                S0: n_state = dir ? S5 : S1;
                S1: n_state = dir ? S0 : S2;
                S2: n_state = dir ? S1 : S3;
                S3: n_state = dir ? S2 : S4;
                S4: n_state = dir ? S3 : S5;
                S5: n_state = dir ? S4 : S0;
                default: n_state = S0;
            endcase
        end
    end

    // 3. Continuous output assignment
    assign current_state = p_state;

endmodule
