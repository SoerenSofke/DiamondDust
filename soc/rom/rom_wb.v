module rom_wb #(
           parameter ROM_IMAGE = "romRandom3072.hex"
       ) (
           input wire clk,

           output reg wbs_ack_o,
           output reg[ 31: 0 ] wbs_dat_o,
           input wire wbs_stb_i,

           /* verilator lint_off UNUSED */
           input wire[ 31: 0 ] wbs_adr_i,
           input wire wbs_cyc_i
           /* verilator lint_on UNUSED */
       );

// Initialization
reg [ 31: 0 ] rom [ 0: 3071 ];
initial begin
    $readmemh( ROM_IMAGE, rom );
end

// Combinational process
reg [ 11: 0 ] address;
reg [ 31: 0 ] next_data;
reg next_ack;
always @( * ) begin
    if ( wbs_cyc_i == 1 && wbs_stb_i == 1 && ~wbs_ack_o ) begin
        address = wbs_adr_i[ 13: 2 ];
        next_data = rom[ address ];
        next_ack = 1;
    end
    else begin
        address = 12'hXXX;
        next_data = 32'hXXXXXXXX;
        next_ack = 0;
    end
end

// Sequential process
always @( posedge clk ) begin
    wbs_dat_o <= next_data;
    wbs_ack_o <= next_ack;
end

endmodule
