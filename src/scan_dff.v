
`timescale 1ns / 1ps

module scan_dff (
    input clk,
    input d,
    input scan_in,
    input scan_enable,
    output reg q
);

    always @(posedge clk) begin
        if (scan_enable)
            q <= scan_in;
        else
            q <= d;
    end

endmodule
