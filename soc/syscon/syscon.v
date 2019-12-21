module syscon (
           output wire clk,
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

// Sub-module for clock generation
SB_HFOSC #(
             // According to https://www.latticesemi.com/-/media/LatticeSemi/Documents/UserManuals/RZ/migration_guide_icecube2.ashx
             // HSOSC provides a 48MHz, 24MHz, 12MHz or 6MHz oscillation frequency output while LSOSC generates a 10KHz frequency out.
             // 0b00=48MHz(default), 0b01=24MHz, 0b10=12MHz, 0b11=6MHz
             .CLKHF_DIV ( "0b11" )
         ) OSC_inst0 (
             .CLKHFEN( 1'b1 ),
             .CLKHFPU( 1'b1 ),
             .CLKHF( clk )
         );

endmodule

// Simulation only
`ifdef SIMULATION 

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
            "0b00" : delay = 1 * delayFactor;
            "0b01" : delay = 2 * delayFactor;
            "0b10" : delay = 4 * delayFactor;
            "0b11" : delay = 8 * delayFactor;
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
`endif
