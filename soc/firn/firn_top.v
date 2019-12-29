`include "../syscon/syscon.v"
`include "../intercon/intercon_wb.v"
`include "../picorv32/picorv32.v"
`include "../rom/rom_wb.v"

module firn_top( );
// Syscon
wire clk;
wire rst;
syscon syscon (
           .clk( clk ),
           .rst( rst )
       );

// Intertcon
wire[ 31: 0 ] master_dat_i;
wire master_we_i;
wire [ 3: 0 ] master_sel_i;
wire [ 31: 0 ] master_adr_i;
wire master_cyc_i;
wire master_stb_i;
wire [ 31: 0 ] master_dat_o;
wire master_ack_o;

wire [ 31: 0 ] slave_dat_o;
wire [ 7: 0 ] slave_we_o;
wire [ 3: 0 ] slave_sel_o;
wire [ 31: 0 ] slave_adr_o;
wire [ 7: 0 ] slave_cyc_o;
wire [ 7: 0 ] slave_stb_o;
wire [ 255: 0 ] slave_dat_i;
wire [ 7: 0 ] slave_ack_i;
intercon_wb intercon (
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

// PicoRV32
wire trap;
/* verilator lint_off PINMISSING */
picorv32_wb picorv32(
                .trap( trap ),
                // Wishbone interfaces
                .wb_rst_i( rst ),
                .wb_clk_i( clk ),

                .wbm_adr_o( master_adr_i ),
                .wbm_dat_o( master_dat_i ),
                .wbm_dat_i( master_dat_o ),
                .wbm_we_o( master_we_i ),
                .wbm_sel_o( master_sel_i ),
                .wbm_stb_o( master_stb_i ),
                .wbm_ack_i( master_ack_o ),
                .wbm_cyc_o( master_cyc_i )
            );
/* verilator lint_on PINMISSING */

parameter ROM_INDEX = 0;
wire slave_ack_i_rom;
wire [ 31: 0 ] slave_dat_i_rom;
assign slave_ack_i[ ROM_INDEX ] = slave_ack_i_rom;
assign slave_dat_i[ 31: 0 ] = slave_dat_i_rom;

// ROM
rom_wb #( .ROM_IMAGE( "../rom/romRandom3072.hex" )
        ) rom (
           .clk( clk ),
           .wbs_ack_o( slave_ack_i_rom ),
           .wbs_dat_o( slave_dat_i_rom ),
           .wbs_stb_i( slave_stb_o[ ROM_INDEX ] ),
           .wbs_adr_i( slave_adr_o ),
           .wbs_cyc_i( slave_cyc_o[ ROM_INDEX ] )
       );

endmodule
