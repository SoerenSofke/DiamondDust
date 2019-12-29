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

// Internal states
reg [ 31: 0 ] rom [ 0: 3071 ];
reg [ 11: 0 ] address;
reg [ 31: 0 ] _wbs_dat_o;
reg _wbs_ack_o;

// Initialization
initial begin
    $readmemh( ROM_IMAGE, rom );
end

// Combinational process
always @( * ) begin
    if ( wbs_cyc_i == 1 && wbs_stb_i == 1 && ~wbs_ack_o ) begin
        address = wbs_adr_i[ 13: 2 ];
        _wbs_dat_o = rom[ address ];
        _wbs_ack_o = 1;
    end
    else begin
        address = 12'hXXX;
        _wbs_dat_o = 32'hXXXXXXXX;
        _wbs_ack_o = 0;
    end
end

// Sequential process
always @( posedge clk ) begin
    wbs_dat_o <= _wbs_dat_o;
    wbs_ack_o <= _wbs_ack_o;
end

endmodule
