`timescale 1ns/100ps

module syscon (
    output reg clk   ,
    output reg rst     = 1,
    output reg enable  = 0
);
    // Internal states
    reg next_enable;
    reg next_reset ;

    // Combinational process
    always @(*) begin
        if (enable == 0) begin
            next_reset  = 1;
            next_enable = 1;
        end else begin
            next_reset = 0;
        end
    end

    // Sequential process
    always @(posedge clk) begin
        enable <= next_enable;
        rst    <= next_reset;
    end

    // Clock generation
    `ifdef SIMULATION // Simulation only
        initial begin
            clk = 0;
            $dumpfile("build/top.vcd");
            $dumpvars;
            #`SIMULATION $finish;
        end

        always begin
            #0.5 clk = !clk;
        end

    `else // Synthesis only
        SB_LFOSC #(
            //.CLKLF_DIV ("0b11") //TODO: decide on clock speed of soc
        ) OSCInst0 (
            .CLKLFPU(1'b1),
            .CLKLFEN(1'b1),
            .CLKLF  (clk )
        );
    `endif

endmodule