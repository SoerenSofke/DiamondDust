// Reference: https://www.latticesemi.com/-/media/LatticeSemi/Documents/UserManuals/RZ/migration_guide_icecube2.ashx
//
// Layout of 4 SRAM blocks
//  ram01 | ram00
//  ------|------
//  ram11 | ram10

module ram (
           input clock ,
           input writeEnable,
           input [ 14: 0 ] address ,
           input [ 31: 0 ] dataIn ,
           output [ 31: 0 ] dataOut
       );

wire [ 31: 0 ] dataOutLow ;
wire [ 31: 0 ] dataOutHigh;

assign dataOut = address[ 14 ] ? dataOutHigh : dataOutLow;

// LSB: [15:0]
// Lower memory bank: !address[14]
SP256K ram00 (
           .AD ( address[ 13: 0 ] ),  // I, 14-bit address
           .DI ( dataIn[ 15: 0 ] ),  // I, 16-bit write data
           .MASKWE ( 4'b1111 ),  // I, 4-bit nibble mask control
           .WE ( writeEnable ),  // I, write(H)/read(L) mode select
           .CS ( !address[ 14 ] ),  // I, memory enable
           .CK ( clock ),  // I, clock
           .STDBY ( 1'b0 ),  // I, low leakage standby mode
           .SLEEP ( 1'b0 ),  // I, periphery shutdown sleep mode
           .PWROFF_N( 1'b1 ),  // I, no memory retention turn off
           .DO ( dataOutLow[ 15: 0 ] )   // O, 16-bit read data
       );

// MSB: [31:16]
// Lower memory bank: !address[14]
SP256K ram01 (
           .AD ( address[ 13: 0 ] ),
           .DI ( dataIn[ 31: 16 ] ),
           .MASKWE ( 4'b1111 ),
           .WE ( writeEnable ),
           .CS ( !address[ 14 ] ),
           .CK ( clock ),
           .STDBY ( 1'b0 ),
           .SLEEP ( 1'b0 ),
           .PWROFF_N( 1'b1 ),
           .DO ( dataOutLow[ 31: 16 ] )
       );

// LSB: [15:0]
// High memory bank: address[14]
SP256K ram10 (
           .AD ( address[ 13: 0 ] ),
           .DI ( dataIn[ 15: 0 ] ),
           .MASKWE ( 4'b1111 ),
           .WE ( writeEnable ),
           .CS ( address[ 14 ] ),
           .CK ( clock ),
           .STDBY ( 1'b0 ),
           .SLEEP ( 1'b0 ),
           .PWROFF_N( 1'b1 ),
           .DO ( dataOutHigh[ 15: 0 ] )
       );

// MSB: [31:16]
// High memory bank: address[14]
SP256K ram11 (
           .AD ( address[ 13: 0 ] ),
           .DI ( dataIn[ 31: 16 ] ),
           .MASKWE ( 4'b1111 ),
           .WE ( writeEnable ),
           .CS ( address[ 14 ] ),
           .CK ( clock ),
           .STDBY ( 1'b0 ),
           .SLEEP ( 1'b0 ),
           .PWROFF_N( 1'b1 ),
           .DO ( dataOutHigh[ 31: 16 ] )
       );

endmodule
