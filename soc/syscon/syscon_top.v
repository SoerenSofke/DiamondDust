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

    // Unit test
    `ifdef SIMULATION
        testAnythingProtocol #("build", "report.tap") tap ();
        reg[63*8:0] test_message;
        integer cycleCounter = 0;

        always @(posedge clk) begin
            cycleCounter = cycleCounter + 1;

            // reset pin level: 1 1 1 0 0 0 0 0...
            $sformat(test_message, "Reset Pin Level: %d", rst_pin);
            if (cycleCounter <= 3)
                tap.assert(rst_pin == 1, test_message);
            else
                tap.assert(rst_pin == 0, test_message);

            // clock pin level: 1 0 1 0 1 0 1 0...
            $sformat(test_message, "Clock Pin Level: %d", clk_pin);
            if (cycleCounter % 2 == 0)
                tap.assert(clk_pin == 1, test_message);
            else
                tap.assert(clk_pin == 0, test_message);

            // finish after 10 cycles
            if (cycleCounter >= 10)
                tap.finish;
        end
    `endif
endmodule