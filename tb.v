`timescale 1ns/1ps

module tb_abc;

    // Testbench signals
    reg        clk;
    reg        rst;
    reg        dir;
    reg        en;
    wire [2:0] current_state;

    // Instantiate the Unit Under Test (UUT)
    abc uut (
        .clk(clk),
        .rst(rst),
        .dir(dir),
        .en(en),
        .current_state(current_state)
    );

    // Generate clock: 10ns period (50 MHz)
    always #5 clk = ~clk;

    // Initial block for stimulus, waveform dumping, and monitoring
    initial begin
        // Setup waveform dumping for VCD viewers (like GTKWave)
        $dumpfile("counter_waveform.vcd");
        $dumpvars(0, tb_abc);

        // Setup console monitoring
        $monitor("Time = %0t ns | rst = %b | en = %b | dir = %b | current_state = %d", 
                 $time, rst, en, dir, current_state);

        // Initialize signals
        clk = 0;
        rst = 0;
        dir = 0;
        en  = 0;

        // Hold reset active for 20ns
        #20;
        rst = 1;

        // Test 1: Count Up (dir = 0) with enable high
        en = 1;
        dir = 0;
        #70; // Let it count up for a few cycles

        // Test 2: Count Down (dir = 1)
        dir = 1;
        #70; // Let it count down

        // Test 3: Disable counter (en = 0), verify it holds state
        en = 0;
        #30;

        // Test 4: Re-enable and count up again
        en = 1;
        dir = 0;
        #40;

        // End simulation
        $finish;
    end

endmodule
