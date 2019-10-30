`include "./syscon.v"
`timescale 1ns/1ns

module syscon_top (
    output reg clk_pin = 0,
    output reg rst_pin = 1
);
    wire clk;
    wire rst;

    always @(posedge clk) begin
        clk_pin <= !clk_pin;
        rst_pin <= rst;
    end

    syscon syscon_inst0 (
        .clk(clk),
        .rst(rst)
    );
endmodule