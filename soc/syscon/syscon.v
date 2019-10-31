`timescale 1ns/100ps

module syscon (
           output reg clk,
           output reg rst = 1
       );
// Internal states
reg enable = 0;
reg next_enable;
reg next_reset;

// Combinational process
always @( * ) begin
    if ( enable == 0 ) begin
        next_reset = 1;
        next_enable = 1;
    end
    else begin
        next_reset = 0;
    end
end

// Sequential process
always @( posedge clk ) begin
    enable <= next_enable;
    rst <= next_reset;
end

// Clock generation
`ifdef SIMULATION // Simulation only
initial begin
    clk = 0;
    $dumpfile( "build/top.vcd" );
    $dumpvars;
    #`SIMULATION $finish;
end

always begin
    #0.5 clk = !clk;
end
`else // Synthesis only
SB_HFOSC #(
             // https://www.latticesemi.com/-/media/LatticeSemi/Documents/ApplicationNotes/IK/iCE40OscillatorUsageGuide.ashx
             .CLKHF_DIV ( "0b11" )
         ) OSC_inst0 (
             .CLKHFEN( 1'b1 ),
             .CLKHFPU( 1'b1 ),
             .CLKHF( clk )
         );
`endif
endmodule
