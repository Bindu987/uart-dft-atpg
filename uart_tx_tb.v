`timescale 1ns / 1ps

module uart_tx_tb;

    reg clk;
    reg reset;
    reg tx_start;
    reg [7:0] tx_data;
    wire tx_out;
    wire tx_done;

    // Instantiate DUT
    uart_tx uut (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_out(tx_out),
        .tx_done(tx_done)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        tx_start = 0;
        tx_data = 8'b10101010;

        // Apply reset
        #20;
        reset = 0;

        // Wait for 2 clock cycles (ensure FSM enters IDLE)
        repeat(2) @(posedge clk);

        // Pulse tx_start
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;

        // Wait long enough to complete transmission
        #200;
        $finish;
    end

    // Monitor output values
    initial begin
        $monitor("Time=%0t | tx_out=%b | tx_done=%b", $time, tx_out, tx_done);
    end

endmodule

