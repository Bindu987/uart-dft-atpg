`timescale 1ns / 1ps

module uart_tx (
    input        clk,
    input        reset,
    input        tx_start,
    input  [7:0] tx_data,
    output reg   tx_out,
    output reg   tx_done
);

    // FSM states
    parameter IDLE  = 3'b000,
              START = 3'b001,
              SHIFT = 3'b010,
              STOP  = 3'b011,
              DONE  = 3'b100;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] tx_shift_reg;
    reg       tx_start_latched;

    // Latch tx_start on rising edge of clk when in IDLE
    always @(posedge clk or posedge reset) begin
        if (reset)
            tx_start_latched <= 1'b0;
        else if (state == IDLE && tx_start)
            tx_start_latched <= 1'b1;
        else if (state != IDLE)
            tx_start_latched <= 1'b0;
    end

    // FSM state transitions
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // FSM next-state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = tx_start_latched ? START : IDLE;
            START: next_state = SHIFT;
            SHIFT: next_state = (bit_count == 3'd7) ? STOP : SHIFT;
            STOP:  next_state = DONE;
            DONE:  next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output and data shift logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx_out       <= 1'b1;  // UART idle state is high
            tx_done      <= 1'b0;
            tx_shift_reg <= 8'd0;
            bit_count    <= 3'd0;
        end else begin
            case (state)
                IDLE: begin
                    tx_out  <= 1'b1;
                    tx_done <= 1'b0;
                end
                START: begin
                    tx_out       <= 1'b0;            // Start bit
                    tx_shift_reg <= tx_data;
                    bit_count    <= 3'd0;
                end
                SHIFT: begin
                    tx_out        <= tx_shift_reg[0];
                    tx_shift_reg  <= tx_shift_reg >> 1;
                    bit_count     <= bit_count + 1;
                end
                STOP: begin
                    tx_out <= 1'b1;  // Stop bit
                end
                DONE: begin
                    tx_done <= 1'b1;
                end
            endcase
        end
    end

endmodule

