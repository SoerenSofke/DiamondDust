module intercon_wb #(
           parameter WB_DATA_WIDTH = 32,
           parameter WB_ADDR_WIDTH = 32,
           parameter WB_NUM_SLAVES = 8,
           parameter WB_NUM_SLAVES_BITS = 3,
           parameter SLAVE_ADDRESS_BITS = 20
       ) (
           // Wischbone master interface
           input wire [ WB_DATA_WIDTH - 1: 0 ] master_dat_i,
           input wire master_we_i ,
           input wire [ 3: 0 ] master_sel_i,
           input wire [ WB_ADDR_WIDTH - 1: 0 ] master_adr_i,
           input wire master_cyc_i,
           input wire master_stb_i,
           output reg [ WB_DATA_WIDTH - 1: 0 ] master_dat_o,
           output reg master_ack_o,

           // Wishbone slave interface
           output reg [ WB_DATA_WIDTH - 1: 0 ] slave_dat_o,
           output reg [ WB_NUM_SLAVES - 1: 0 ] slave_we_o ,
           output reg [ 3: 0 ] slave_sel_o,
           output reg [ WB_ADDR_WIDTH - 1: 0 ] slave_adr_o,
           output reg [ WB_NUM_SLAVES - 1: 0 ] slave_cyc_o,
           output reg [ WB_NUM_SLAVES - 1: 0 ] slave_stb_o,
           input wire [ WB_DATA_WIDTH * WB_NUM_SLAVES - 1: 0 ] slave_dat_i,
           input wire [ WB_NUM_SLAVES - 1: 0 ] slave_ack_i
       );

// Master / Slave Connection
reg [ WB_NUM_SLAVES - 1: 0 ] mask;
reg [ WB_NUM_SLAVES_BITS - 1 : 0 ] index;

always @( * ) begin
    // Address decoder
    index = master_adr_i[ SLAVE_ADDRESS_BITS + WB_NUM_SLAVES_BITS - 1 : SLAVE_ADDRESS_BITS ];
    mask = ( { WB_NUM_SLAVES{ 1'b0 } } + 1'b1 ) << index;

    // Set outputs to slave (from maser)
    slave_cyc_o = mask & { WB_NUM_SLAVES{ master_cyc_i } };
    slave_stb_o = mask & { WB_NUM_SLAVES{ master_stb_i } };
    slave_we_o = mask & { WB_NUM_SLAVES{ master_we_i } };

    slave_dat_o = master_dat_i;
    slave_sel_o = master_sel_i;
    slave_adr_o = master_adr_i;

    // Set outputs to master (from slave)
    master_dat_o = slave_dat_i[ WB_DATA_WIDTH * index +: WB_DATA_WIDTH ];
    master_ack_o = slave_ack_i[ index ];
end
endmodule
