`include "rom_wb.v"
`include "../syscon/syscon.v"

module rom_top(
           output reg rst_pin,
           output reg wbs_ack_pin
       );

wire clk;
wire rst;
syscon syscon_inst0 (
           .clk( clk ),
           .rst( rst )
       );

wire wbs_ack_o;
wire [ 31: 0 ] wbs_dat_o;
reg wbs_stb_i;
reg [ 31: 0 ] wbs_adr_i;
reg wbs_cyc_i;

rom_wb rom_inst0 (
           .clk( clk ),
           .wbs_ack_o( wbs_ack_o ),
           .wbs_dat_o( wbs_dat_o ),
           .wbs_stb_i( wbs_stb_i ),
           .wbs_adr_i( wbs_adr_i ),
           .wbs_cyc_i( wbs_cyc_i )
       );

// stimulus
integer cycleCounter;
always @( posedge clk ) begin
    rst_pin <= rst;
    wbs_ack_pin <= wbs_ack_o;

    if ( rst == 1 ) begin
        cycleCounter <= 0;
    end
    else begin
        // Address #0
        if ( cycleCounter == 0 ) begin
            wbs_adr_i <= 0 * 4;
            wbs_stb_i <= 1;
            wbs_cyc_i <= 1;
        end
        if ( cycleCounter == 2 ) begin
            wbs_stb_i <= 0;
            wbs_cyc_i <= 0;
        end
        // Address #1
        if ( cycleCounter == 4 ) begin
            wbs_adr_i <= 1 * 4;
            wbs_stb_i <= 1;
            wbs_cyc_i <= 1;
        end
        if ( cycleCounter == 6 ) begin
            wbs_stb_i <= 0;
            wbs_cyc_i <= 0;
        end
        // Address #3071
        if ( cycleCounter == 8 ) begin
            wbs_adr_i <= 3071 * 4;
            wbs_stb_i <= 1;
            wbs_cyc_i <= 1;
        end
        if ( cycleCounter == 10 ) begin
            wbs_stb_i <= 0;
            wbs_cyc_i <= 0;
        end
        cycleCounter <= cycleCounter + 1;
    end
end

// test
`ifdef SIMULATION
testAnythingProtocol #( "build", "report.tap" ) tap ();
always @( * ) begin
    case ( cycleCounter )
        2 : begin
            tap.assert( wbs_dat_o == 32'h6b36f49d, "data address #0: 6b36f49d" );
            tap.assert( wbs_ack_o == 1'b1, "ack: OK" );
        end
        6 : begin
            tap.assert( wbs_dat_o == 32'he0ee1ba5, "data address #1: e0ee1ba5" );
            tap.assert( wbs_ack_o == 1'b1, "ack: OK" );
        end
        10 : begin
            tap.assert( wbs_dat_o == 32'h916142d8, "data address #3071: 916142d8" );
            tap.assert( wbs_ack_o == 1'b1, "ack: OK" );
        end
    endcase
    if ( cycleCounter >= 16 ) begin
        tap.finish;
    end
end
`endif

endmodule
