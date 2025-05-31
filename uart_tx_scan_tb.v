`timescale 1ns / 1ps

module uart_tx_scan_tb;

    // Inputs
    reg clk;
    reg reset;
    reg tx_start;
    reg [7:0] tx_data;
    reg scan_enable;
    reg scan_in;

    // Outputs
    wire scan_out;
    wire tx_out;
    wire tx_done;

    // Instantiate the scan-enabled UART transmitter
    uart_tx_scan uut (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .scan_enable(scan_enable),
        .scan_in(scan_in),
        .scan_out(scan_out),
        .tx_out(tx_out),
        .tx_done(tx_done)
    );

    // Generate 100 MHz clock (10ns period)
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        tx_start = 0;
        tx_data = 8'b10101010;
        scan_enable = 0;
        scan_in = 0;

        // Apply reset
        #20;
        reset = 0;

        // Wait for FSM to reach IDLE
        repeat(2) @(posedge clk);

        // Trigger UART transmission
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;

        // Wait for UART transmission to complete
        #200;

        $finish;
    end

    // Monitor simulation output
    initial begin
        $monitor("Time=%0t | tx_out=%b | tx_done=%b | scan_out=%b", $time, tx_out, tx_done, scan_out);
    end

endmodule
