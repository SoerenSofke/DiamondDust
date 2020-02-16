`include "../syscon/syscon.v"
`include "../vexRiscv/VexRiscv.v" 
//`include "../ram/ram_wb.v"
`include "../rom/rom_wb.v"

module firn_top( );

// Syscon
wire clk;
wire reset;
syscon syscon (
           .clk( clk ),
           .rst( reset )
       );

// ROM
wire inst_ack;
wire inst_str;
wire inst_cyc;
wire [ 31: 0 ] inst_data_miso;
wire [ 31: 0 ] inst_adr;

rom_wb #(
           .ROM_IMAGE( "../rom/romRandom3072.hex" )
       ) rom (
           .clk( clk ),
           .wbs_ack_o( inst_ack ),
           .wbs_dat_o( inst_data_miso ),
           .wbs_stb_i( inst_str ),
           .wbs_adr_i( inst_adr ),
           .wbs_cyc_i( inst_cyc )
       );

// RAM
wire data_ack;
wire data_str;
wire [ 31: 0 ] data_data_miso;
wire [ 31: 0 ] data_data_mosi;
wire [ 31: 0 ] data_adr;
wire [ 3: 0 ] data_sel;
wire data_cyc;

/*
ram_wb ram(
           .clk_i ( clk ),
           .wbs_ack_o( data_ack ),
           .wbs_adr_i ( data_adr ),
 
           .wbs_dat_i ( data_data_mosi ),
           .wbs_dat_o ( data_data_miso ),
           .wbs_stb_i ( data_str ),
           .wbs_we_i ( 4'b1111 ),
           .wbs_sel_i ( data_sel ),
           .wbs_cyc_i ( data_cyc )
       );
//*/

// VexRiscV
assign inst_adr[ 1: 0 ] = 0;
assign data_adr[ 1: 0 ] = 0;

VexRiscv vex(
             .clk( clk ),
             .reset ( reset ),
             // Instruction bus
             .iBusWishbone_CYC( inst_cyc ),
             .iBusWishbone_STB ( inst_str ),
             .iBusWishbone_ACK ( inst_ack ),
             .iBusWishbone_WE (),
             .iBusWishbone_ADR( inst_adr[ 31: 2 ] ),
             .iBusWishbone_DAT_MISO( inst_data_miso ),
             .iBusWishbone_DAT_MOSI (),
             .iBusWishbone_SEL (),
             .iBusWishbone_ERR ( 1'b0 ),
             .iBusWishbone_BTE (),
             .iBusWishbone_CTI (),
             // Data bus
             .dBusWishbone_CYC( data_cyc ),
             .dBusWishbone_STB( data_str ),
             .dBusWishbone_ACK( data_ack ),
             .dBusWishbone_WE(),
             .dBusWishbone_ADR( data_adr[ 31: 2 ] ),
             .dBusWishbone_DAT_MISO( data_data_miso ),
             .dBusWishbone_DAT_MOSI( data_data_mosi ),
             .dBusWishbone_SEL( data_sel ),
             .dBusWishbone_ERR( 1'b0 ),
             .dBusWishbone_BTE(),
             .dBusWishbone_CTI(),
             // Interrupts
             .timerInterrupt( 1'b0 ),
             .externalInterrupt( 1'b0 ),
             .softwareInterrupt( 1'b0 )
         );
endmodule
