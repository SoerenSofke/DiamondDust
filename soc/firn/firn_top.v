`include "../syscon/syscon.v"
`include "../vexRiscv/VexRiscv.v"
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
wire [ 31: 0 ] inst_adr_mosi;

rom_wb #(
           .ROM_IMAGE( "../rom/romRandom3072.hex" )
       ) rom (
           .clk( clk ),
           .wbs_ack_o( inst_ack ),
           .wbs_dat_o( inst_data_miso ),
           .wbs_stb_i( inst_str ),
           .wbs_adr_i( inst_adr_mosi ),
           .wbs_cyc_i( inst_cyc )
       );

       

// VexRiscV
assign inst_adr_mosi[ 1: 0 ] = 0;
VexRiscv vex(
             .clk( clk ),
             .reset ( reset ),
             // Instruction bus
             .iBusWishbone_CYC( inst_cyc ),
             .iBusWishbone_STB ( inst_str ),
             .iBusWishbone_ACK ( inst_ack ),
             .iBusWishbone_WE (),
             .iBusWishbone_ADR( inst_adr_mosi[ 31: 2 ] ),
             .iBusWishbone_DAT_MISO( inst_data_miso ),
             .iBusWishbone_DAT_MOSI (),
             .iBusWishbone_SEL (),
             .iBusWishbone_ERR ( 1'b0 ),
             .iBusWishbone_BTE (),
             .iBusWishbone_CTI (),
             // Data bus
             .dBusWishbone_CYC(),
             .dBusWishbone_STB(),
             .dBusWishbone_ACK( 1'b0 ),
             .dBusWishbone_WE(),
             .dBusWishbone_ADR(),
             .dBusWishbone_DAT_MISO( 32'b0 ),
             .dBusWishbone_DAT_MOSI(),
             .dBusWishbone_SEL(),
             .dBusWishbone_ERR( 1'b0 ),
             .dBusWishbone_BTE(),
             .dBusWishbone_CTI(),
             // Interrupts
             .timerInterrupt( 1'b0 ),
             .externalInterrupt( 1'b0 ),
             .softwareInterrupt( 1'b0 )
         );
endmodule
