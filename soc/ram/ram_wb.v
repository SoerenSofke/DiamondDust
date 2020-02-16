module ram_wb (
           output reg wbs_ack_o,
           input wire [ 31: 0 ] wbs_adr_i,
           input wire clk_i ,
           input wire [ 31: 0 ] wbs_dat_i,
           output wire [ 31: 0 ] wbs_dat_o,
           input wire wbs_stb_i,
           input wire wbs_we_i ,
           input wire [ 3: 0 ] wbs_sel_i,
           input wire wbs_cyc_i
       );

wire[ 14: 0 ] addressRam;
reg wbs_ack_tmp;
wire[ 0: 0 ] writeEn;

// generate the ACK signal (ROM needs two clock cycles)
always @( posedge clk_i ) begin : ack_p
    wbs_ack_tmp <= wbs_stb_i;
    wbs_ack_o <= wbs_ack_tmp;
end

// write to the reg at the time, the acknoledge is set
assign writeEn[ 0 ] = wbs_ack_o;

// Address: 1024 * 32 Bit => 10 Bit Address (word aligned)
assign addressRam = wbs_adr_i[ 14: 0 ];

ram ram_inst0 (
        .clock ( clk_i ),
        .writeEnable( wbs_we_i ),
        .address ( addressRam ),
        .dataIn ( wbs_dat_i ),
        .dataOut ( wbs_dat_o )
    );

endmodule
