// timescale <time_unit>/<time_precision>
`timescale 1ns/100ps

module SB_HFOSC #(
           parameter CLKHF_DIV = "0b11"
       ) (
           input CLKHFEN,
           input CLKHFPU,
           output reg CLKHF );

real delayFactor = 10.4166666667;
real delay;
real simulationTime;

initial begin
    CLKHF = 0;
    $dumpfile( "build/top.vcd" );
    $dumpvars;

    begin
        case ( CLKHF_DIV )
            "0b00"  : delay = 1 * delayFactor;
            "0b01"  : delay = 2 * delayFactor;
            "0b10"  : delay = 4 * delayFactor;
            "0b11"  : delay = 8 * delayFactor;
            default : delay = 1 * delayFactor;
        endcase
    end

    simulationTime = delay * 2 * `SIMULATION;
    #simulationTime $finish;
end

always begin
    #delay CLKHF = !CLKHF;
end

endmodule
