# Verilog RTL descriptions of ITC'99 benchmark circuits

Circuits from https://github.com/cad-polito-it/I99T/tree/master conveted to RTL Verilog.

Converted using vhd2vl by Larry Doolittle 
https://github.com/ldoolitt/vhd2vl

## Conversion process

Replaced ```bit``` and ```bit_vector``` structures with std_logic.

Removed ```type``` and ```subtype``` and replaced them with the represented structure or 1 bit registers.

Replaced ```downto``` with to.

Edited ```mem``` value assignments to single values.

Moved all declarations to the top of the file.

Removed ```for all: <module> use entity work.<module>(behav);```


After the edits the circuits were converted using vhd2vl.

After the conversions, the altered and removed parts were written in Verilog by hand, and the memory structures were assigned the appropriate values ​​in initial blocks.

The converted circuits were cross-checked against their VHDL counterparts by simulating them with 10^6 random input vectors (a number of reset activations were performed throughout simulation).

