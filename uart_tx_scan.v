`timescale 1ns / 1ps
`include "scan_dff.v"

module uart_tx_scan (
    input clk,
    input reset,
    input tx_start,
    input [7:0] tx_data,
    input scan_enable,
    input scan_in,
    output scan_out,
    output tx_out,
    output tx_done
);

    // Internal signals
    wire [2:0] state;
    wire [2:0] bit_count;
    wire [7:0] tx_shift_reg;

    wire [2:0] next_state;
    wire [2:0] bit_count_d;
    wire [7:0] tx_shift_d;

    wire [13:0] scan_chain;

    // Scan Flip-Flops (FSM State)
    scan_dff s0 (.clk(clk), .d(next_state[0]), .scan_in(scan_chain[0]), .scan_enable(scan_enable), .q(state[0]));
    scan_dff s1 (.clk(clk), .d(next_state[1]), .scan_in(scan_chain[1]), .scan_enable(scan_enable), .q(state[1]));
    scan_dff s2 (.clk(clk), .d(next_state[2]), .scan_in(scan_chain[2]), .scan_enable(scan_enable), .q(state[2]));

    // Scan Flip-Flops (Bit Counter)
    scan_dff bc0 (.clk(clk), .d(bit_count_d[0]), .scan_in(scan_chain[3]), .scan_enable(scan_enable), .q(bit_count[0]));
    scan_dff bc1 (.clk(clk), .d(bit_count_d[1]), .scan_in(scan_chain[4]), .scan_enable(scan_enable), .q(bit_count[1]));
    scan_dff bc2 (.clk(clk), .d(bit_count_d[2]), .scan_in(scan_chain[5]), .scan_enable(scan_enable), .q(bit_count[2]));

    // Scan Flip-Flops (Shift Register)
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : shift_ff
            scan_dff reg_dff (
                .clk(clk),
                .d(tx_shift_d[i]),
                .scan_in(scan_chain[i+6]),
                .scan_enable(scan_enable),
                .q(tx_shift_reg[i])
            );
        end
    endgenerate

    // Scan chain shifting
    assign scan_chain[0] = scan_in;
    assign scan_chain[13:1] = scan_chain[12:0];
    assign scan_out = scan_chain[13];

    // FSM next state logic
    assign next_state = (reset) ? 3'b000 :
                        (state == 3'b000 && tx_start) ? 3'b001 :
                        (state == 3'b001) ? 3'b010 :
                        (state == 3'b010 && bit_count == 3'd7) ? 3'b011 :
                        (state == 3'b011) ? 3'b100 :
                        (state == 3'b100) ? 3'b000 : state;

    // Bit counter update logic
    assign bit_count_d = (state == 3'b010) ? bit_count + 1 : 3'd0;

    // Shift register update logic
    assign tx_shift_d = (state == 3'b001) ? tx_data :
                        (state == 3'b010) ? {1'b0, tx_shift_reg[7:1]} :
                        tx_shift_reg;

    // UART output signal
    assign tx_out = (state == 3'b000) ? 1'b1 :                  // IDLE
                    (state == 3'b001) ? 1'b0 :                  // START
                    (state == 3'b010) ? tx_shift_reg[0] :      // SHIFT
                    1'b1;                                      // STOP + DONE

    // UART done signal
    assign tx_done = (state == 3'b100);  // DONE

endmodule

