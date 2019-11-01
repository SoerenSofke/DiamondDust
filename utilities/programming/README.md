# Purpose
Utility to flash a synthesized binary to a FPGA connected to your host PC.

## Prerequisites for Windows
1. Download and install the Lattice stand-alone [Programnmer](http://www.latticesemi.com/programmer)
2. Download both files from this direcory into your download directory, notably
    * [flashLatestBinary.cmd](https://github.com/soerensofke/DiamondDust/tree/master/utilities/programming/flashLatestBinary.cmd)
    * [programmer.xcf](https://github.com/soerensofke/DiamondDust/tree/master/utilities/programming/programmer.xcf)

## Programming
Download any syntesized binary (*.bin) from this Gitpod hosted IDE into the download directory and execute _flashLatestBinary.cmd_.
The script will flash the latest binary located in the download directory to the FPGA connected via USB to your host PC.