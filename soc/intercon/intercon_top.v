`include "intercon_wb.v"
`include "../syscon/syscon.v"
`include "../../utilities/testAnythingProtocol.v"

module intercon_top ();

wire clk;
wire rst;
syscon syscon_inst0 (
           .clk( clk ),
           .rst( rst )
       );

reg[ 31: 0 ] master_dat_i;
reg master_we_i;
reg [ 3: 0 ] master_sel_i;
reg [ 31: 0 ] master_adr_i;
reg master_cyc_i;
reg master_stb_i;
wire [ 31: 0 ] master_dat_o;
wire master_ack_o;

wire [ 31: 0 ] slave_dat_o;
wire [ 7: 0 ] slave_we_o;
wire [ 3: 0 ] slave_sel_o;
wire [ 31: 0 ] slave_adr_o;
wire [ 7: 0 ] slave_cyc_o;
wire [ 7: 0 ] slave_stb_o;
reg [ 255: 0 ] slave_dat_i;
reg [ 7: 0 ] slave_ack_i;

intercon_wb intercon_inst0 (
                // Wischbone master interface
                .master_dat_i( master_dat_i ),
                .master_we_i ( master_we_i ),
                .master_sel_i( master_sel_i ),
                .master_adr_i( master_adr_i ),
                .master_cyc_i( master_cyc_i ),
                .master_stb_i( master_stb_i ),
                .master_dat_o( master_dat_o ),
                .master_ack_o( master_ack_o ),

                // Wishbone slave interface
                .slave_dat_o( slave_dat_o ),
                .slave_we_o ( slave_we_o ),
                .slave_sel_o( slave_sel_o ),
                .slave_adr_o( slave_adr_o ),
                .slave_cyc_o( slave_cyc_o ),
                .slave_stb_o( slave_stb_o ),
                .slave_dat_i( slave_dat_i ),
                .slave_ack_i( slave_ack_i )
            );


testAnythingProtocol #( "build", "report.tap" ) tap ();
integer cycleCounter;

always @( posedge clk ) begin
    if ( rst == 1 ) begin
        cycleCounter = 0;

        master_dat_i = 32'hFFFFFFFF;
        master_sel_i = 4'hF;

        master_we_i = 1;
        master_adr_i = 0;
        master_cyc_i = 1;
        master_stb_i = 1;

        slave_dat_i = 0;
        slave_ack_i = 0;
    end
    else begin
        // Address slave #1
        if ( cycleCounter == 0 ) begin
            master_adr_i = 32'h00000000;
            slave_ack_i = 8'b00000001;
            slave_dat_i = 256'h00000000_00000000_00000000_00000000_00000000_00000000_00000000_FFFFFFFF;
        end
        if ( cycleCounter == 1 ) begin
            tap.assert( slave_cyc_o == 8'b00000001, "slave index 1: slave_cyc_o" );
            tap.assert( slave_stb_o == 8'b00000001, "slave index 1: slave_stb_o" );
            tap.assert( slave_we_o == 8'b00000001, "slave index 1: slave_we_o" );

            tap.assert( slave_dat_o == master_dat_i, "slave index 1: slave_dat_o == master_dat_i" );
            tap.assert( slave_sel_o == master_sel_i, "slave index 1: slave_dat_o == master_dat_i" );
            tap.assert( slave_adr_o == master_adr_i, "slave index 1: slave_dat_o == master_dat_i" );

            tap.assert( master_ack_o == 1, "slave index 1: master_ack_o" );
            tap.assert( master_dat_o == 32'hFFFFFFFF, "slave index 1: master_dat_o" );

        end

        // Address slave #2
        if ( cycleCounter == 2 ) begin
            master_adr_i = 32'h00100000;
            slave_ack_i = 8'b00000010;
            slave_dat_i = 256'h00000000_00000000_00000000_00000000_00000000_00000000_FFFFFFFF_00000000;
        end
        if ( cycleCounter == 3 ) begin
            tap.assert( slave_cyc_o == 8'b00000010, "slave index 2: slave_cyc_o" );
            tap.assert( slave_stb_o == 8'b00000010, "slave index 2: slave_stb_o" );
            tap.assert( slave_we_o == 8'b00000010, "slave index 2: slave_we_o" );

            tap.assert( slave_dat_o == master_dat_i, "slave index 2: slave_dat_o == master_dat_i" );
            tap.assert( slave_sel_o == master_sel_i, "slave index 2: slave_dat_o == master_dat_i" );
            tap.assert( slave_adr_o == master_adr_i, "slave index 2: slave_dat_o == master_dat_i" );

            tap.assert( master_ack_o == 1, "slave index 2: master_ack_o" );
            tap.assert( master_dat_o == 32'hFFFFFFFF, "slave index 2: master_dat_o" );
        end

        // Address slave #3
        if ( cycleCounter == 4 ) begin
            master_adr_i = 32'h00200000;
            slave_ack_i = 8'b00000100;
            slave_dat_i = 256'h00000000_00000000_00000000_00000000_00000000_FFFFFFFF_00000000_00000000;
        end
        if ( cycleCounter == 5 ) begin
            tap.assert( slave_cyc_o == 8'b00000100, "slave index 3: slave_cyc_o" );
            tap.assert( slave_stb_o == 8'b00000100, "slave index 3: slave_stb_o" );
            tap.assert( slave_we_o == 8'b00000100, "slave index 3: slave_we_o" );

            tap.assert( slave_dat_o == master_dat_i, "slave index 3: slave_dat_o == master_dat_i" );
            tap.assert( slave_sel_o == master_sel_i, "slave index 3: slave_dat_o == master_dat_i" );
            tap.assert( slave_adr_o == master_adr_i, "slave index 3: slave_dat_o == master_dat_i" );

            tap.assert( master_ack_o == 1, "slave index 3: master_ack_o" );
            tap.assert( master_dat_o == 32'hFFFFFFFF, "slave index 3: master_dat_o" );
        end

        // Address slave #4
        if ( cycleCounter == 6 ) begin
            master_adr_i = 32'h00300000;
            slave_ack_i = 8'b00001000;
            slave_dat_i = 256'h00000000_00000000_00000000_00000000_FFFFFFFF_00000000_00000000_00000000;
        end
        if ( cycleCounter == 7 ) begin
            tap.assert( slave_cyc_o == 8'b00001000, "slave index 4: slave_cyc_o" );
            tap.assert( slave_stb_o == 8'b00001000, "slave index 4: slave_stb_o" );
            tap.assert( slave_we_o == 8'b00001000, "slave index 4: slave_we_o" );

            tap.assert( slave_dat_o == master_dat_i, "slave index 4: slave_dat_o == master_dat_i" );
            tap.assert( slave_sel_o == master_sel_i, "slave index 4: slave_dat_o == master_dat_i" );
            tap.assert( slave_adr_o == master_adr_i, "slave index 4: slave_dat_o == master_dat_i" );

            tap.assert( master_ack_o == 1, "slave index 4: master_ack_o" );
            tap.assert( master_dat_o == 32'hFFFFFFFF, "slave index 4: master_dat_o" );
        end

        // Address slave #5
        if ( cycleCounter == 8 ) begin
            master_adr_i = 32'h00400000;
            slave_ack_i = 8'b00010000;
            slave_dat_i = 256'h00000000_00000000_00000000_FFFFFFFF_00000000_00000000_00000000_00000000;
        end
        if ( cycleCounter == 9 ) begin
            tap.assert( slave_cyc_o == 8'b00010000, "slave index 5: slave_cyc_o" );
            tap.assert( slave_stb_o == 8'b00010000, "slave index 5: slave_stb_o" );
            tap.assert( slave_we_o == 8'b00010000, "slave index 5: slave_we_o" );

            tap.assert( slave_dat_o == master_dat_i, "slave index 5: slave_dat_o == master_dat_i" );
            tap.assert( slave_sel_o == master_sel_i, "slave index 5: slave_dat_o == master_dat_i" );
            tap.assert( slave_adr_o == master_adr_i, "slave index 5: slave_dat_o == master_dat_i" );

            tap.assert( master_ack_o == 1, "slave index 5: master_ack_o" );
            tap.assert( master_dat_o == 32'hFFFFFFFF, "slave index 5: master_dat_o" );
        end

        // Address slave #6
        if ( cycleCounter == 10 ) begin
            master_adr_i = 32'h00500000;
            slave_ack_i = 8'b00100000;
            slave_dat_i = 256'h00000000_00000000_FFFFFFFF_00000000_00000000_00000000_00000000_00000000;
        end
        if ( cycleCounter == 11 ) begin
            tap.assert( slave_cyc_o == 8'b00100000, "slave index 6: slave_cyc_o" );
            tap.assert( slave_stb_o == 8'b00100000, "slave index 6: slave_stb_o" );
            tap.assert( slave_we_o == 8'b00100000, "slave index 6: slave_we_o" );

            tap.assert( slave_dat_o == master_dat_i, "slave index 6: slave_dat_o == master_dat_i" );
            tap.assert( slave_sel_o == master_sel_i, "slave index 6: slave_dat_o == master_dat_i" );
            tap.assert( slave_adr_o == master_adr_i, "slave index 6: slave_dat_o == master_dat_i" );

            tap.assert( master_ack_o == 1, "slave index 6: master_ack_o" );
            tap.assert( master_dat_o == 32'hFFFFFFFF, "slave index 6: master_dat_o" );
        end

        // Address slave #7
        if ( cycleCounter == 12 ) begin
            master_adr_i = 32'h00600000;
            slave_ack_i = 8'b01000000;
            slave_dat_i = 256'h00000000_FFFFFFFF_00000000_00000000_00000000_00000000_00000000_00000000;
        end
        if ( cycleCounter == 13 ) begin
            tap.assert( slave_cyc_o == 8'b01000000, "slave index 7: slave_cyc_o" );
            tap.assert( slave_stb_o == 8'b01000000, "slave index 7: slave_stb_o" );
            tap.assert( slave_we_o == 8'b01000000, "slave index 7: slave_we_o" );

            tap.assert( slave_dat_o == master_dat_i, "slave index 7: slave_dat_o == master_dat_i" );
            tap.assert( slave_sel_o == master_sel_i, "slave index 7: slave_dat_o == master_dat_i" );
            tap.assert( slave_adr_o == master_adr_i, "slave index 7: slave_dat_o == master_dat_i" );

            tap.assert( master_ack_o == 1, "slave index 7: master_ack_o" );
            tap.assert( master_dat_o == 32'hFFFFFFFF, "slave index 7: master_dat_o" );
        end

        // Address slave #8
        if ( cycleCounter == 14 ) begin
            master_adr_i = 32'h00700000;
            slave_ack_i = 8'b10000000;
            slave_dat_i = 256'hFFFFFFFF_00000000_00000000_00000000_00000000_00000000_00000000_00000000;
        end
        if ( cycleCounter == 15 ) begin
            tap.assert( slave_cyc_o == 8'b10000000, "slave index 8: slave_cyc_o" );
            tap.assert( slave_stb_o == 8'b10000000, "slave index 8: slave_stb_o" );
            tap.assert( slave_we_o == 8'b10000000, "slave index 8: slave_we_o" );

            tap.assert( slave_dat_o == master_dat_i, "slave index 8: slave_dat_o == master_dat_i" );
            tap.assert( slave_sel_o == master_sel_i, "slave index 8: slave_dat_o == master_dat_i" );
            tap.assert( slave_adr_o == master_adr_i, "slave index 8: slave_dat_o == master_dat_i" );

            tap.assert( master_ack_o == 1, "slave index 8: master_ack_o" );
            tap.assert( master_dat_o == 32'hFFFFFFFF, "slave index 8: master_dat_o" );
        end

        // finish
        if ( cycleCounter >= 16 ) begin
            tap.finish;
        end

        cycleCounter = cycleCounter + 1;
    end
end

endmodule
